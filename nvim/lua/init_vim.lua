-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

require("nvim-tree").setup({
	update_focused_file = { enable = true },
	view = { width = 50 },
})

require('copilot').setup({
	panel = {
		auto_refresh = true,
	},
	suggestion = {
		auto_trigger = false,
		hide_during_completion = false,
		keymap = {
			accept = '<M-Space>',
		},
	},
})


require('dark_notify').run({
	schemes = {
		dark = 'base16-tomorrow-night-eighties',
		light = 'base16-atelier-heath-light',
	}
})

require("bufferline").setup()

local cmp_kinds = {
	Text = '',
	Method = '',
	Function = '',
	Constructor = '',
	Field = '',
	Variable = '',
	Class = '',
	Interface = '',
	Module = '',
	Property = '',
	Unit = '',
	Value = '',
	Enum = '',
	Keyword = '',
	Snippet = '',
	Color = '',
	File = '',
	Reference = '',
	Folder = '',
	EnumMember = '',
	Constant = '',
	Struct = '',
	Event = '',
	Operator = '',
	TypeParameter = '',
}


local lsp = require('lspconfig')


local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require('cmp')
cmp.setup({
	matching = {
		disallow_partial_fuzzy_matching = false,
		disallow_fuzzy_matching = false,
		disallow_prefix_unmatching = false,
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. (strings[1] or "") .. " "
			kind.menu = "    (" .. (strings[2] or "") .. ")"
			kind.menu = strings[3]

			return kind
		end,
	},
	snippet = {
		expand = function (args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() and cmp.visible() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'buffer' },
		{ name = 'vsnip' },
		{ name = 'path' },
	},
	-- sources = cmp.config.sources({
	-- 	{ name = 'nvim_lsp' },
	-- 	{ name = 'nvim_lsp_signature_help' },
	-- 	{ name = 'buffer' },
	-- 	{ name = 'vsnip' },
	-- 	{ name = 'path' },
	-- }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
		, 
		{ name = 'cmdline' }
	})
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp.basedpyright.setup{
	settings = {
		python  = {
			venvPath = "/Users/ldaniluk/.pyenv/versions/",
			venv = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
		},
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
}

-- lsp.pyright.setup({
-- 	capabilities = capabilities,
-- 	settings = {
-- 		python = {
-- 			venvPath = "/Users/ldaniluk/.pyenv/versions/",
-- 			venv = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
-- 		}
-- 	},
-- 	-- cmd = {
-- 	-- 	"pyright-langserver", "--stdio", "--venvPath=/Users/ldaniluk/.pyenv/versions/", "--venv=" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
-- 	-- }
-- })

lsp.terraformls.setup({})

lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
	    diagnostics = {
		enable = true,
		experimental = { enable = true, },
	    },
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
	    inlay_hint = { enable = true, },
            procMacro = {
                enable = true
            },
        }
    }
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
vim.lsp.handlers.signature_help, {
	border = 'rounded',
	close_events = {"CursorMoved", "BufHidden", "InsertCharPre"},
}
)


require("nvim-dap-virtual-text").setup()
require('dap-python').setup()
-- require('symbols-outline').setup()
require("aerial").setup({
  open_automatic = false,
  layout = {
    min_width = { 40, 0.2 },
    max_width = { 60, 0.2 },
  },
  filter_kind = {
  -- defaults
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  -- additional
    "Constant",
    "Variable",
  },
})

require('lualine').setup({
    sections = {
	lualine_c = {
		"filename", "aerial",
	},
    },
})


require('gitlinker').setup({
	mappings = false,
})

local command_center = require("commander")
command_center.setup({
   components = {"DESC", "KEYS"},
   sort_by = { "DESC" }
})
command_center.add({{
   desc = "get github url to current line",
   cmd = '<CMD>lua require"gitlinker".get_buf_range_url()<CR>',
   keys = {"n", "<Leader>p"}
}})
command_center.add({{
   desc = "black",
   cmd = '<CMD>!black %<CR>',
   keys = {"n", "<Leader>b"}
}})
command_center.add({{
   desc = "coerce to upper",
   cmd = 'cru',
}})


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end
        -- whatever other lsp config you want
    end
})

require("actions-preview").setup {
  telescope = {
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.8,
      height = 0.9,
      prompt_position = "top",
      preview_cutoff = 20,
      preview_height = function(_, _, max_lines)
        return max_lines - 15
      end,
    },
  },
}

-- require("CopilotChat").setup{}
