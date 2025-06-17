return {
	"michaelrommel/nvim-silicon",
	lazy = true,
	cmd = "Silicon",
	opts = {
		disable_defaults = true,
		debug = false,
		font = "JetBrainsMono NF=34; Noto Color Emoji=34",
		theme = "OneHalfDark",
		language = function()
			return vim.bo.filetype
		end,
		-- to_clipboard = true,
		window_title = function()
			return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ":t")
		end,
		-- wslclipboard = "always",
		-- wslclipboardcopy = "keep",
		command = "silicon",
		output = "/mnt/d/code.png",
	},
}
