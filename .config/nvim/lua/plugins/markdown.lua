return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim", "nvim-tree/nvim-web-devicons" }, -- if you use the mini.nvim suite
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
	config = function()
		local md = require("render-markdown")
		md.setup({
			file_types = { "markdown", "vimwiki" },
			render_modes = { "n", "c" },
			heading = {
				sign = false,
				above = "",
				below = "",
				backgrounds = {},
			},
		})

		-- set to toggle if needed
		vim.keymap.set("n", "tm", md.toggle)
	end,
}
