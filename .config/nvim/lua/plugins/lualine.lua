return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"diff",
					{
						"diagnostics",
						source = { "nvim_diagnostic", "nvim_lsp", "vim_lsp" },
					},
				},
				lualine_c = {
					{
						"filename",
						symbols = {
							modified = " ",
							readonly = " ",
						},
					},
					{
						require("noice.api").status.mode.get,
						cond = require("noice.api").status.mode.has,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					function()
						local schema = require("yaml-companion").get_buf_schema(0)
						if schema.result[1].name == "none" then
							return ""
						end
						return schema.result[1].name
					end,
				},
				lualine_y = { "filesize" },
				lualine_z = { "location" },
			},
		})
	end,
}
