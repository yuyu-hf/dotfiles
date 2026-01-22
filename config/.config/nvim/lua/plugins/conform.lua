---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = "ConformInfo",
	opts = {
		format_on_save = function(bufnr)
			local ft = vim.bo[bufnr].filetype

			local format_config = {
				lua = { timeout_ms = 1000, lsp_fallback = false },
				go = { timeout_ms = 1500, lsp_format = "fallback" },
				python = { timeout_ms = 1500, lsp_fallback = false },
				javascript = { timeout_ms = 1500, lsp_fallback = false },
				typescript = { timeout_ms = 1500, lsp_fallback = false },
				javascriptreact = { timeout_ms = 1500, lsp_fallback = false },
				typescriptreact = { timeout_ms = 1500, lsp_fallback = false },
				rust = { timeout_ms = 1500, lsp_fallback = false },
			}

			return format_config[ft]
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

		-- カスタムフォーマッタの設定
		formatters = {
			-- biome-checkに--unsafeフラグを追加して未使用importを削除
			["biome-check"] = {
				args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" },
			},
		},
	},
}
