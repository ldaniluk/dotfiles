local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map("n", "<Leader>f", "<CMD>Telescope find_files<CR>", opts)
map("n", "<Leader>/", "<CMD>Telescope live_grep<CR>", opts)
map("n", "<Leader>[", "<CMD>Telescope grep_string<CR>", opts)
map("n", "<Leader><Tab>", "<CMD>Telescope buffers<CR>", opts)
map("n", "<Leader>-", "<CMD>Telescope diagnostics<CR>", opts)
map("n", "<Leader>]", "<CMD>Telescope lsp_references<CR>", opts)
