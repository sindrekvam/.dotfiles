require("nvim-treesitter").setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({
	"bash",
	"zsh",
	"toml",
	"json",
	"cmake",
	"make",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"dockerfile",

	"c",
	"cpp",
	"lua",
	"python",
	"vhdl",
	"go",
	"html",
	"javascript",
	"typescript",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(event)
		local lang = vim.treesitter.language.get_lang(event.match)
		if lang and vim.treesitter.language.add(lang) and vim.treesitter.query.get(lang, "highlights") then
			vim.treesitter.start(event.buf, lang)
		end
	end,
})
