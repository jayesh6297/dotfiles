return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	init = function()
		vim.cmd.colorscheme("catppuccin")
	end,
	config = function()
		require("catppuccin").setup({
			transparent_background = false,
			term_colors = true,
			no_bold = true,
			no_italic = true,
			flavor = "mocha",
			default_integration = true,
		})
	end,
}
