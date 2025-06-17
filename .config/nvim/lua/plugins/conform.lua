return { -- Autoformat
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	config = function()
		require("conform").setup({
			notify_on_error = false,
			formatters_by_ft = {
				lua = { "stylua" },
				html = { "prettier" },
				python = { "ruff" },
				sh = { "shfmt" },
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function(args)
				if vim.bo[args.buf].filetype == "go" then
					local params = vim.lsp.util.make_range_params()
					params.context = { diagnostics = vim.diagnostic.get(args.buf), only = { "source.organizeImports" } }

					local results, err = vim.lsp.buf_request_sync(args.buf, "textDocument/codeAction", params, 500)
					if err then
						return
					end

					if results then
						for _, response in pairs(results) do
							if response.result and #response.result > 0 then
								for _, action in ipairs(response.result) do
									if action.edit then
										vim.lsp.util.apply_workspace_edit(
											action.edit,
											vim.lsp.util._get_offset_encoding(args.buf)
										)
									end
								end
							end
						end
					end
				end
				require("conform").format({
					timeout_ms = 500,
					lsp_fallback = true,
					quite = true,
				})
			end,
		})
	end,
}
