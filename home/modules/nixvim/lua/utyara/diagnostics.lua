local M = {}

function M.setup()
  vim.diagnostic.config({
    virtual_text = {
      spacing = 2,
    },

    signs = true,
    underline = true,
    severity_sort = true,

    float = {
      border = "rounded",
      source = "if_many",
    },
  })
end

function M.current_buffer()
  vim.diagnostic.setloclist({
    open = true,
    title = "Buffer Diagnostics",
  })
end

function M.workspace()
  vim.diagnostic.setqflist({
    open = true,
    title = "Workspace Diagnostics",
  })
end

function M.next()
  vim.diagnostic.jump({
    count = 1,
  })
end

function M.previous()
  vim.diagnostic.jump({
    count = -1,
  })
end

function M.details()
  vim.diagnostic.open_float({
    border = "rounded",
    source = "always",
    focus = false,
  })
end

return M
