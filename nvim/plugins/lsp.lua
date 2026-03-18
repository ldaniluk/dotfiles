local cmp_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = cmp_lsp_status and cmp_nvim_lsp.default_capabilities()
	or vim.lsp.protocol.make_client_capabilities()

-- Setup servers natively using Neovim 0.11+ vim.lsp.config API
vim.lsp.config("basedpyright", {
	capabilities = capabilities,
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,
				diagnosticMode = "workspace",
				typeCheckingMode = "strict",
			},
		},
	},
})
vim.lsp.enable("basedpyright")

vim.lsp.config("terraformls", {
	capabilities = capabilities,
})
vim.lsp.enable("terraformls")

local function get_typescript_lib()
	local cwd = vim.uv.cwd()
	-- Search for node_modules/typescript/lib in the current directory and subdirectories (up to 3 levels deep)
	-- or upwards towards the root.
	local lib_dirs = vim.fs.find("typescript/lib", {
		path = cwd,
		upward = true,
		type = "directory",
		limit = 10,
	})

	-- Also search downward specifically in common monorepo structures if not found upward
	if #lib_dirs == 0 then
		local downward = vim.fn.glob(cwd .. "/**/node_modules/typescript/lib", false, true)
		for _, path in ipairs(downward) do
			table.insert(lib_dirs, path)
		end
	end

	for _, path in ipairs(lib_dirs) do
		if path:match("node_modules") and vim.uv.fs_stat(path) then
			print("LSP: Found typescript lib at " .. path)
			return path
		end
	end

	local tsserver_bin = vim.fn.exepath("typescript-language-server")
	if tsserver_bin ~= "" then
		local bin_dir = vim.fn.fnamemodify(tsserver_bin, ":h")
		local global_lib = bin_dir .. "/../lib/node_modules/typescript/lib"
		if vim.uv.fs_stat(global_lib) then
			print("LSP: Found global typescript lib at " .. global_lib)
			return global_lib
		end

		local pnpm_lib = bin_dir .. "/node_modules/typescript/lib"
		if vim.uv.fs_stat(pnpm_lib) then
			print("LSP: Found pnpm global typescript lib at " .. pnpm_lib)
			return pnpm_lib
		end
	end
	print("LSP: Could not find typescript lib path!")
	return nil
end

vim.lsp.config("ts_ls", {
	capabilities = capabilities,
	init_options = {
		hostInfo = "neovim",
		tsserver = {
			path = get_typescript_lib(),
		},
	},
})
vim.lsp.enable("ts_ls")

vim.lsp.config("rust_analyzer", {
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			diagnostics = { enable = true, experimental = { enable = true } },
			imports = { granularity = { group = "module" }, prefix = "self" },
			cargo = { buildScripts = { enable = true }, features = "all" },
			inlay_hint = { enable = true },
			procMacro = { enable = true },
		},
	},
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("marksman", { capabilities = capabilities })
vim.lsp.enable("marksman")

vim.lsp.config("taplo", { capabilities = capabilities })
vim.lsp.enable("taplo")

vim.lsp.config("yamlls", { capabilities = capabilities })
vim.lsp.enable("yamlls")

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.enable("lua_ls")

vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
	return vim.lsp.handlers.signature_help(
		err,
		result,
		ctx,
		vim.tbl_extend("force", config or {}, {
			border = "rounded",
			close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
		})
	)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true)
		end
	end,
})

local conform_status, conform = pcall(require, "conform")
if conform_status then
	conform.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			rust = { "rustfmt" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
		format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
	})
end

local actions_status, actions_preview = pcall(require, "actions-preview")
if actions_status then
	local telescope_themes_status, telescope_themes = pcall(require, "telescope.themes")
	local theme = telescope_themes_status and telescope_themes.get_cursor() or {}

	actions_preview.setup({
		telescope = vim.tbl_extend("force", theme, {
			previewer = true,
			layout_config = { height = 20, width = 80 },
		}),
	})
end

local lsp_file_ops_status, lsp_file_ops = pcall(require, "lsp-file-operations")
if lsp_file_ops_status then
	lsp_file_ops.setup()
end

vim.keymap.set(
	"n",
	"<Leader>e",
	'<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>',
	{ noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<Leader><CR>",
	'<cmd>lua require("actions-preview").code_actions()<CR>',
	{ noremap = true, silent = true }
)
