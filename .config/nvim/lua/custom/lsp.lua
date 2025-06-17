local M = {}

M.setup = function()
	M.install()
	M.go()
	M.lua()
	M.json()
	M.toml()
	M.yaml()
	M.python()
end

M.lspconfig = require("lspconfig")

M.capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	require("cmp_nvim_lsp").default_capabilities()
)

M.on_attach = function(client, bufnr)
	local builtin = require("telescope.builtin")

	vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
	vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr })
	vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr })
	vim.keymap.set("n", "gi", builtin.lsp_implementations, { buffer = bufnr })
	vim.keymap.set("n", "<leader>D", builtin.lsp_type_definitions, { buffer = bufnr })
	vim.keymap.set("n", "ds", builtin.lsp_document_symbols, { buffer = bufnr })
	vim.keymap.set("n", "ws", builtin.lsp_dynamic_workspace_symbols, { buffer = bufnr })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })

	if client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end

	if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		vim.keymap.set("n", "<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
		end)
	end
end

M.install = function()
	require("mason").setup()
	local ensure_installed = {
		-- linters
		"jsonlint", -- Used to lint json
		"golangci-lint", -- Used to lint go code
		"hadolint", -- used to lint Dockerfile

		-- formatters
		"stylua", -- Used to format Lua code
		"prettier", -- used to formatter html, css, javascript
		"ruff",

		-- debuggers
		"delve",

		-- golang specific
		"gomodifytags",
		"impl",
		"gotests",
		"iferr",

		-- lsp server
		"gopls",
		"lua-language-server",
		"yaml-language-server",
		"pyright",
		"taplo",
		"templ",
		"json-lsp",
		"helm-ls",
	}
	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
end

M.go = function()
	M.lspconfig.gopls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = {
			gopls = {
				buildFlags = { "-tags=integration functional testing pact" },
				analyses = {
					shadow = false,
					unusedvariable = true,
					useany = true,
				},
				codelenses = {
					gc_details = false,
					run_govulncheck = true,
				},
				hints = {
					assignVariableTypes = true,
					functionTypeParameters = true,
					parameterNames = true,
				},
				vulncheck = "Imports",
				gofumpt = true,
			},
		},
	})
	M.lspconfig.templ.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
	})
end

M.python = function()
	M.lspconfig.pyright.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = {
			pyright = {
				-- Using Ruff's import organizer
				disableOrganizeImports = true,
			},
			python = {
				analysis = {
					-- Ignore all files for analysis to exclusively use Ruff for linting
					ignore = { "*" },
				},
			},
		},
	})
end

M.lua = function()
	M.lspconfig.lua_ls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	})
end

M.yaml = function()
	M.lspconfig.helm_ls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = {
			["helm-ls"] = {
				path = "yaml-language-server",
			},
		},
	})
	local cfg = require("yaml-companion").setup({
		builtin_matchers = {
			kubernetes = { enabled = true },
		},

		schemas = {
			{
				name = "Argo CD Application",
				uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
			},
			{
				name = "SealedSecret",
				uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
			},
			{
				name = "Kustomization",
				uri = "https://json.schemastore.org/kustomization.json",
			},
			{
				name = "GitHub Workflow",
				uri = "https://json.schemastore.org/github-workflow.json",
			},
		},
		lspconfig = {
			on_attach = M.on_attach,
			capabilities = M.capabilities,
			settings = {
				yaml = {
					validate = true,
					format = { enable = true },
					hover = true,
					schemaStore = {
						enable = true,
						url = "https://www.schemastore.org/api/json/catalog.json",
					},
					schemaDownload = { enable = true },
					schemas = {},
				},
			},
		},
	})
	M.lspconfig.yamlls.setup(cfg)
	require("telescope").load_extension("yaml_schema")
end

M.toml = function()
	M.lspconfig.taplo.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
	})
end

M.json = function()
	M.lspconfig.jsonls.setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	})
end

return M
