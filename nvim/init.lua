-- Core Options
vim.opt.cul = true
vim.opt.nu = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.signcolumn = "yes"
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Core Keymaps
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Space>", "\\", { remap = true })

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map("n", "<Leader>h", "<CMD>noh<CR>", opts)
map("n", "((", "<CMD>cp<CR>", opts)
map("n", "))", "<CMD>cn<CR>", opts)
map("n", "<Leader>sv", "<CMD>source $MYVIMRC<CR>", opts)

-- Simple native package manager
local function ensure_plugin(repo, branch_or_tag)
	local name = repo:match(".*/(.*)")
	local path = vim.fn.stdpath("data") .. "/site/pack/vendor/start/" .. name

	if vim.fn.isdirectory(path) == 0 then
		print("Installing " .. name .. "...")
		local cmd = { "git", "clone", "--depth=1" }
		if branch_or_tag then
			table.insert(cmd, "-b")
			table.insert(cmd, branch_or_tag)
		end
		table.insert(cmd, "https://github.com/" .. repo)
		table.insert(cmd, path)
		vim.fn.system(cmd)
	end
	vim.opt.rtp:prepend(path)
end

-- 1. Ensure all plugins exist
ensure_plugin("nvim-lua/plenary.nvim")
ensure_plugin("nvim-tree/nvim-web-devicons")
ensure_plugin("nvim-telescope/telescope.nvim")
ensure_plugin("nvim-tree/nvim-tree.lua")
ensure_plugin("neovim/nvim-lspconfig")
ensure_plugin("stevearc/conform.nvim")
ensure_plugin("aznhe21/actions-preview.nvim")
ensure_plugin("antosha417/nvim-lsp-file-operations")
ensure_plugin("hrsh7th/nvim-cmp")
ensure_plugin("hrsh7th/cmp-nvim-lsp")
ensure_plugin("hrsh7th/cmp-nvim-lsp-signature-help")
ensure_plugin("hrsh7th/cmp-path")
ensure_plugin("hrsh7th/cmp-buffer")
ensure_plugin("hrsh7th/cmp-cmdline")
ensure_plugin("hrsh7th/cmp-vsnip")
ensure_plugin("hrsh7th/vim-vsnip")
ensure_plugin("onsails/lspkind.nvim")
ensure_plugin("mfussenegger/nvim-dap")
ensure_plugin("rcarriga/nvim-dap-ui")
ensure_plugin("nvim-neotest/nvim-nio")
ensure_plugin("theHamsta/nvim-dap-virtual-text")
ensure_plugin("mfussenegger/nvim-dap-python")
ensure_plugin("yannvanhalewyn/jujutsu.nvim")
ensure_plugin("swaits/lazyjj.nvim")
ensure_plugin("julienvincent/hunk.nvim")
ensure_plugin("tpope/vim-fugitive")
ensure_plugin("zbirenbaum/copilot.lua")
ensure_plugin("CopilotC-Nvim/CopilotChat.nvim", "main")
ensure_plugin("stevearc/aerial.nvim")
ensure_plugin("ruifm/gitlinker.nvim")
ensure_plugin("FeiyouG/commander.nvim")
ensure_plugin("tpope/vim-abolish")
ensure_plugin("varnishcache-friends/vim-varnish")
ensure_plugin("duane9/nvim-rg")
ensure_plugin("dstein64/vim-startuptime")
ensure_plugin("kkharji/sqlite.lua")
ensure_plugin("LintaoAmons/bookmarks.nvim", "v2.0.0")
ensure_plugin("RRethy/nvim-base16")
ensure_plugin("cormacrelf/dark-notify")
ensure_plugin("nvim-lualine/lualine.nvim")
ensure_plugin("akinsho/bufferline.nvim", "v4.6.1")
ensure_plugin("nvim-treesitter/nvim-treesitter")

-- 2. Force Neovim to index the newly added runtime paths instantly
vim.cmd("packloadall!")

-- 3. Load configurations from the plugins folder explicitly
local config_dir = vim.fn.stdpath("config")
dofile(config_dir .. "/plugins/theme.lua")
dofile(config_dir .. "/plugins/treesitter.lua")
dofile(config_dir .. "/plugins/telescope.lua")
dofile(config_dir .. "/plugins/file_explorer.lua")
dofile(config_dir .. "/plugins/lsp.lua")
dofile(config_dir .. "/plugins/cmp.lua")
dofile(config_dir .. "/plugins/dap.lua")
dofile(config_dir .. "/plugins/jujutsu.lua")
dofile(config_dir .. "/plugins/copilot.lua")
dofile(config_dir .. "/plugins/tools.lua")
