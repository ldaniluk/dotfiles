vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local status_tree, nvim_tree = pcall(require, "nvim-tree")
if status_tree then
	nvim_tree.setup({
		update_focused_file = { enable = true },
		view = { width = 50 },
	})
else
	vim.notify("Failed to load nvim-tree", vim.log.levels.WARN)
end

vim.keymap.set("n", "<Leader>t", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree", noremap = true, silent = true })
