local status_aerial, aerial = pcall(require, "aerial")
if status_aerial then
    aerial.setup({
      open_automatic = false,
      layout = { min_width = { 40, 0.2 }, max_width = { 60, 0.2 } },
      filter_kind = {
        "Class", "Constructor", "Enum", "Function", "Interface", "Module", "Method", "Struct", "Constant", "Variable",
      },
    })
end

local status_gitlinker, gitlinker = pcall(require, "gitlinker")
if status_gitlinker then
    gitlinker.setup({ mappings = false })
end

local status_bookmarks, bookmarks = pcall(require, "bookmarks")
if status_bookmarks then
    bookmarks.setup({})
    vim.keymap.set({ "n", "v" }, "ma", "<cmd>BookmarksCommands<cr>", { desc = "Find and trigger a bookmark command." })
end

local status_commander, commander = pcall(require, "commander")
if status_commander then
    commander.setup({ components = {"DESC", "KEYS"}, sort_by = { "DESC" } })
    commander.add({{
       desc = "get github url to current line",
       cmd = '<CMD>lua require"gitlinker".get_buf_range_url()<CR>',
       keys = {"n", "<Leader>p"}
    }})
    commander.add({{
       desc = "Format file",
       cmd = '<CMD>lua require("conform").format({ lsp_format = "fallback" })<CR>',
       keys = {"n", "<Leader>b"}
    }})
    commander.add({{
       desc = "coerce to upper",
       cmd = 'cru',
    }})
    commander.add({{
       desc = "rename symbol under cursor",
       cmd = '<CMD>lua vim.lsp.buf.rename()<CR>',
    }})
end

local map = vim.keymap.set
map('n', '<C-P>', '<CMD>Telescope commander<CR>', { noremap = true, silent = true })
map('v', '<C-P>', '<CMD>Telescope commander<CR>', { noremap = true, silent = true })