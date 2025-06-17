return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("obsidian").setup({
			ui = { enable = false },
			workspaces = {
				{
					name = "personal",
					path = "/mnt/d/notes",
				},
			},
			log_level = vim.log.levels.ERROR,
			completion = {
				nvim_cmp = true,
				min_chars = 2,
			},
		})
	end,
}
