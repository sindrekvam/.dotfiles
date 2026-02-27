local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = {
			"ruff",
			-- To fix auto-fixable lint errors.
			"ruff_fix",
			-- To run the Ruff formatter.
			"ruff_format",
			-- To organize the imports.
			"ruff_organize_imports",
		},
		go = { "gofmt" },
		yaml = { "prettier" },
		json = { "prettier" },
		cpp = { "clang-format" },
	},
})

vim.keymap.set("n", "<S-A-F>", function()
	conform.format({ lsp_fallback = true })
end, { desc = "Format document" })

vim.keymap.set("v", "<S-A-F>", function()
	conform.format({ lsp_fallback = true })
end, { desc = "Format selection" })
