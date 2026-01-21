---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
		})
		require("nvim-treesitter").install({
			"go",
			"gomod",
			"gosum",
			"python",
			"javascript",
			"typescript",
			"php",
			"ruby",
			"rust",
			"lua",
			"bash",
			"zsh",
			"terraform",
			"html",
			"css",
			"json",
			"yaml",
			"make",
			"sql",
		}, {
			force = false, -- 既にインストール済みのパーサーを強制的に再インストール
			generate = true, -- コンパイル前に`grammar.json`または`grammar.js`から`parser.c`を生成
			max_jobs = 4, -- 並列タスクを制限（メモリ制限システムで{generate}と組み合わせて使用すると便利）
			summary = false, -- 複数言語の成功および合計操作のサマリーを出力
		})
	end,
}
