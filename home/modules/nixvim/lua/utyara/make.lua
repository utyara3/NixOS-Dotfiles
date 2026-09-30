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
      "direnv exec %s env LC_ALL=C make",
      vim.fn.shellescape(root)
    )
  else
    command = "env LC_ALL=C make"
  end

  if target then
    command = command .. " " .. vim.fn.shellescape(target)
  end

  return command
end

local function parse_targets(output)
  local phony = {}

  -- Сначала собираем .PHONY.
  for line in output:gmatch("[^\r\n]+") do
    local values = line:match("^%.PHONY:%s*(.*)$")

    if values then
      for target in values:gmatch("%S+") do
        if not target:match("^%.") and not target:find("%%") then
          phony[target] = true
        end
      end
    end
  end

  local targets = {}
  local seen = {}

  local in_files_section = false
  local skip_not_target = false
  local current = nil

  local function add_target(target)
    if not target
      or target == ""
      or target:match("^%.")
      or target:find("%%")
      or seen[target]
    then
      return
    end

    seen[target] = true
    table.insert(targets, target)
  end

  local function finish_current()
    if not current then
      return
    end

    -- Берём:
    -- 1. .PHONY targets
    -- 2. targets, у которых есть recipe
    for _, target in ipairs(current.names) do
      if current.is_phony or current.has_recipe then
        add_target(target)
      end
    end

    current = nil
  end

  for line in output:gmatch("[^\r\n]+") do
    if line == "# Files" then
      in_files_section = true
      skip_not_target = false

    elseif in_files_section
      and line:match("^# Finished Make data base")
    then
      finish_current()
      break

    elseif in_files_section then
      if line == "# Not a target:" then
        finish_current()
        skip_not_target = true

      elseif skip_not_target then
        -- После "# Not a target:" следующая строка
        -- обычно является самим именем файла/правила.
        if line:match("^[^#%s]") then
          skip_not_target = false
        end

      elseif line:match("^[^#%s][^:]*:") then
        finish_current()

        local target_part = line:match("^([^:]+):")
        local names = {}

        for target in target_part:gmatch("%S+") do
          table.insert(names, target)
        end

        current = {
          names = names,
          has_recipe = false,
          is_phony = false,
        }

        for _, target in ipairs(names) do
          if phony[target] then
            current.is_phony = true
            break
          end
        end

      elseif current
        and line:match("^#%s+recipe to execute")
      then
        current.has_recipe = true

      elseif line == "" then
        finish_current()
      end
    end
  end

  finish_current()

  table.sort(targets, function(a, b)
    return a:lower() < b:lower()
  end)

  return targets
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
      "env",
      "LC_ALL=C",
      "make",
      "-qpRr",
      "-f",
      makefile,
    }
  else
    command = {
      "env",
      "LC_ALL=C",
      "make",
      "-qpRr",
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
        if result.stdout == nil or result.stdout == "" then
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
