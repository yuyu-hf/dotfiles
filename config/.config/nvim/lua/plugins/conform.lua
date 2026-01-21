---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = "ConformInfo",
	opts = {
		format_on_save = function(bufnr)
			if vim.bo[bufnr].filetype == "lua" then
				return { timeout_ms = 1000, lsp_fallback = false }
			elseif vim.bo[bufnr].filetype == "go" then
				return { timeout_ms = 1500, lsp_format = "fallback" }
			elseif vim.bo[bufnr].filetype == "python" then
				return { timeout_ms = 1500, lsp_fallback = false }
			elseif vim.bo[bufnr].filetype == "javascript" or vim.bo[bufnr].filetype == "typescript" or vim.bo[bufnr].filetype == "javascriptreact" or vim.bo[bufnr].filetype == "typescriptreact" then
				return { timeout_ms = 1500, lsp_fallback = false }
			elseif vim.bo[bufnr].filetype == "rust" then
				return { timeout_ms = 1500, lsp_fallback = false }
			end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "goimports" },
			python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
			javascript = { "biome-check" },
			typescript = { "biome-check" },
			javascriptreact = { "biome-check" },
			typescriptreact = { "biome-check" },
			rust = { "rustfmt" },
		},
	},
}
