vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<C-t>", "<cmd>terminal<CR>", { silent = true })
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>:w<cr>", { silent = true })
vim.keymap.set({ "n", "i" }, "<C-c>", "<cmd>:bd!<cr>", { silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Window navigations keymap
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Visual Mode yanking and pasting without delete result in it
vim.keymap.set("v", "p", '"_dP', { desc = "after yanking something it keeps in that register" })

-- nvim tree binding
vim.keymap.set("n", "<leader>ee", "<Cmd>NvimTreeToggle<CR>", { desc = "toggle nvim tree expolorer" })
vim.keymap.set(
	"n",
	"<leader>ef",
	"<Cmd>NvimTreeFindFile<CR>",
	{ desc = "open file focusing it and opening folder if neccessary" }
)

-- todo comments toggle
vim.keymap.set("n", "td", "<Cmd>TodoTelescope<CR>", { desc = "open todo in telescope" })
vim.keymap.set("n", "tdq", "<Cmd>TodoQuickFix<CR>", { desc = "open todo in quick fix list" })

-- quickfix list navigation
vim.keymap.set("n", "<C-n>", "<Cmd>cnext<CR>", { desc = "navigate forward in quickfix" })
vim.keymap.set("n", "<C-p>", "<Cmd>cprev<CR>", { desc = "navigate backward in quickfix" })

-- stay in indent mode in Visual
vim.keymap.set("v", "<", "<gv", { desc = "indent prev keeping in visual mode", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "indent next keeping in visual mode", silent = true })

-- move test up or down in visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "indent next keeping in visual mode", silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "indent next keeping in visual mode", silent = true })

-- snapshot
vim.keymap.set("v", "<leader>cs", function()
	require("nvim-silicon").file()
end, { desc = "saves screenshot to file", silent = true })

vim.keymap.set(
	"n",
	"gbl",
	":Gitsigns toggle_current_line_blame<cr>",
	{ desc = "toggle current line blame", silent = true }
)
vim.keymap.set("n", "gb", ":Gitsigns blame_line<cr>", { desc = "show current line blame", silent = true })

local signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
