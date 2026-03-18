local cmp_lsp_status, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = cmp_lsp_status and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

-- Setup servers natively using Neovim 0.11+ vim.lsp.config API
vim.lsp.config('basedpyright', {
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
        }
    }
})
vim.lsp.enable('basedpyright')

vim.lsp.config('terraformls', {
    capabilities = capabilities,
})
vim.lsp.enable('terraformls')

vim.lsp.config('ts_ls', {
    capabilities = capabilities,
})
vim.lsp.enable('ts_ls')

vim.lsp.config('rust_analyzer', {
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            diagnostics = { enable = true, experimental = { enable = true } },
            imports = { granularity = { group = "module" }, prefix = "self" },
            cargo = { buildScripts = { enable = true }, features = 'all' },
            inlay_hint = { enable = true },
            procMacro = { enable = true },
        }
    }
})
vim.lsp.enable('rust_analyzer')

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = 'rounded',
        close_events = {"CursorMoved", "BufHidden", "InsertCharPre"},
    }
)

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end
    end
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
    
    actions_preview.setup {
      telescope = vim.tbl_extend("force", theme, {
          previewer = true,
          layout_config = { height = 20, width = 80 }
      }),
    }
end

local lsp_file_ops_status, lsp_file_ops = pcall(require, "lsp-file-operations")
if lsp_file_ops_status then
    lsp_file_ops.setup()
end

vim.keymap.set('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader><CR>', '<cmd>lua require("actions-preview").code_actions()<CR>', { noremap = true, silent = true })