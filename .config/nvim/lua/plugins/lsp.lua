-- LSP Configuration & Pluginslsp
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "towolf/vim-helm", ft = "helm" },
		"someone-stole-my-name/yaml-companion.nvim",

		{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			dependencies = { "Bilal2453/luvit-meta", lazy = true },
			opts = {
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		"b0o/SchemaStore.nvim",
	},
	config = function()
		require("custom.lsp").setup()
		require("lsp_lines").setup()
		vim.diagnostic.config({
			virtual_text = false,
			highlight_whole_line = false,
			virtual_lines = true,
		})
	end,
}
