local mason_lspconfig = require("mason-lspconfig")
local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")

mason_lspconfig.setup({
	ensure_installed = {
		"ruff", -- Linter and formatter for python
		"stylua", -- Lua formatter
		"lua_ls",
		"vtsls",
		"gopls", -- Golang language server
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
	exclude = {
		"clangd",
		"rust_analyzer",
	},
})

if vim.fn.executable("clangd") then
	vim.lsp.enable("clangd")
end
if vim.fn.executable("rust_analyzer") then
	vim.lsp.enable("rust_analyzer")
end
if vim.fn.executable("gofmt") then
	vim.lsp.enable("gofmt")
end

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "-j=4", -- Limit to not use all cores
        "--clang-tidy",
    },
})

-- Remove warning for undefined vim
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- luasnip
-- Add friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()
-- Add custom snippets
require("luasnip.loaders.from_vscode").lazy_load({
	paths = { "~/.config/nvim/snippets" },
})

-- setup cmp
cmp.setup({
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim-lsp-signature-help" },
		{ name = "luasnip" }, -- "saadparwaiz1/cmp_luasnip"
		{ name = "buffer" },
	}),

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- for `luasnip` users.
		end,
	},

	formatting = {
		fields = { "abbr", "kind", "menu" },
		expandable_indicator = true,
		format = lspkind.cmp_format({
			-- mode = 'symbol', -- show only symbol annotations
			-- maxwidth = 50,
			-- ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
			show_labeldetails = true, -- show labeldetails in menu. disabled by default
			before = function(entry, vim_item)
				return vim_item
			end,
		}),
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),

		["<CR>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if luasnip.expandable() then
					luasnip.expand()
				else
					cmp.confirm({
						select = true,
					})
				end
			else
				fallback()
			end
		end),

		-- Luasnippet, press tab to jump to next input field
		-- or Shift-tab to jump back to previous
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})
require("cmp_git").setup() ]]
--

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})
