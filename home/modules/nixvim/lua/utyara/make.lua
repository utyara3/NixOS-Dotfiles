local terminal = require("utyara.terminal")

local M = {}

local MAKEFILES = {
  "Makefile",
  "makefile",
  "GNUmakefile",
}

local function find_root()
  return vim.fs.root(0, MAKEFILES)
end

local function find_makefile(root)
  for _, name in ipairs(MAKEFILES) do
    local path = vim.fs.joinpath(root, name)

    if vim.uv.fs_stat(path) then
      return path
    end
  end

  return nil
end

local function has_direnv(root)
  local envrc = vim.fs.joinpath(root, ".envrc")

  return vim.uv.fs_stat(envrc) ~= nil
    and vim.fn.executable("direnv") == 1
end

local function make_command(root, target)
  local command

  if has_direnv(root) then
    command = string.format(
      "direnv exec %s make",
      vim.fn.shellescape(root)
    )
  else
    command = "make"
  end

  if target then
    command = command .. " -- " .. vim.fn.shellescape(target)
  end

  return command
end

local function parse_targets(output)
  local all_targets = {}
  local phony_targets = {}

  local in_files_section = false

  for line in output:gmatch("[^\r\n]+") do
    if line == "# Files" then
      in_files_section = true

    elseif line:match("^# Implicit Rules") then
      in_files_section = false

    elseif in_files_section then
      local phony = line:match("^%.PHONY:%s*(.*)$")

      if phony then
        for target in phony:gmatch("%S+") do
          if not target:match("^%.") then
            phony_targets[target] = true
          end
        end
      end

      local target_part = line:match("^([^#%s][^:]*):")

      if target_part
        and not target_part:find("=")
        and not target_part:find("%$")
      then
        for target in target_part:gmatch("%S+") do
          if not target:match("^%.")
            and not target:find("%%")
          then
            all_targets[target] = true
          end
        end
      end
    end
  end

  local result = {}

  -- Если Makefile явно объявляет .PHONY,
  -- считаем именно эти targets пользовательскими командами.
  if next(phony_targets) then
    for target in pairs(phony_targets) do
      table.insert(result, target)
    end
  else
    for target in pairs(all_targets) do
      table.insert(result, target)
    end
  end

  table.sort(result, function(a, b)
    return a:lower() < b:lower()
  end)

  return result
end

local function get_root_or_notify()
  local root = find_root()

  if not root then
    vim.notify(
      "Makefile not found",
      vim.log.levels.WARN
    )

    return nil
  end

  return root
end

function M.default()
  local root = get_root_or_notify()

  if not root then
    return
  end

  vim.cmd("update")

  terminal.run(
    make_command(root),
    root
  )
end

function M.pick()
  local root = get_root_or_notify()

  if not root then
    return
  end

  local makefile = find_makefile(root)

  if not makefile then
    vim.notify(
      "Makefile not found",
      vim.log.levels.WARN
    )

    return
  end

  local command

  if has_direnv(root) then
    command = {
      "direnv",
      "exec",
      root,
      "make",
      "-qp",
      "-f",
      makefile,
    }
  else
    command = {
      "make",
      "-qp",
      "-f",
      makefile,
    }
  end

  vim.system(
    command,
    {
      cwd = root,
      text = true,
    },
    function(result)
      vim.schedule(function()
        if not result.stdout or result.stdout == "" then
          local error_text = result.stderr

          if not error_text or error_text == "" then
            error_text = "Could not read Makefile targets"
          end

          vim.notify(
            error_text,
            vim.log.levels.ERROR
          )

          return
        end

        local targets = parse_targets(result.stdout)

        if #targets == 0 then
          vim.notify(
            "No Make targets found",
            vim.log.levels.WARN
          )

          return
        end

        vim.ui.select(
          targets,
          {
            prompt = "Make target: ",
          },
          function(target)
            if not target then
              return
            end

            vim.cmd("update")

            terminal.run(
              make_command(root, target),
              root
            )
          end
        )
      end)
    end
  )
end

return M
