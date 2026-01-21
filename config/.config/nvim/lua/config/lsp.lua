vim.lsp.enable({
	"lua_ls",
	"gopls",
	"pyright",
	"rust_analyzer",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local buf = args.buf

		-- デフォルトで設定されている言語サーバー用キーバインドに設定を追加する
		-- See https://neovim.io/doc/user/lsp.html#lsp-defaults
		-- 言語サーバーのクライアントがLSPで定められた機能を実装していたら設定を追加するという流れ

		if client:supports_method("textDocument/definition") then
			vim.keymap.set("n", "<C-i>", vim.lsp.buf.definition, { buffer = buf, desc = "定義へジャンプ" })
			-- 定義ジャンプ前の位置に戻る
			vim.keymap.set("n", "<C-o>", "<C-o>", { buffer = buf, desc = "前の位置に戻る" })
		end

		if client:supports_method("textDocument/hover") then
			vim.keymap.set("n", "<C-p>", function()
				vim.lsp.buf.hover({ border = "single" })
			end, { buffer = buf, desc = "ホバードキュメントを表示" })
		end

		-- 保存時に自動フォーマット（conform.nvimで処理されるLua、Go、Python、Rust、JavaScript、TypeScriptを除く）
		-- サーバーが"textDocument/willSaveWaitUntil"をサポートしている場合は通常不要
		if
			vim.bo[buf].filetype ~= "lua"
			and vim.bo[buf].filetype ~= "go"
			and vim.bo[buf].filetype ~= "python"
			and vim.bo[buf].filetype ~= "rust"
			and vim.bo[buf].filetype ~= "javascript"
			and vim.bo[buf].filetype ~= "typescript"
			and vim.bo[buf].filetype ~= "javascriptreact"
			and vim.bo[buf].filetype ~= "typescriptreact"
			and not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

-- Go言語用のLSPとTree-sitterの設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.treesitter.start()
		vim.lsp.start({
			name = "gopls",
			cmd = { "gopls" },
			root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})
	end,
})

-- Python用のLSPとTree-sitterの設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.treesitter.start()
		vim.lsp.start({
			name = "pyright",
			cmd = { "pyright-langserver", "--stdio" },
			root_dir = vim.fs.root(0, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" }),
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
						typeCheckingMode = "basic",
					},
				},
			},
		})
	end,
})

-- Rust用のLSPとTree-sitterの設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function()
		vim.treesitter.start()

		vim.lsp.start({
			name = "rust_analyzer",
			cmd = { "rust-analyzer" },
			root_dir = vim.fs.root(0, { "Cargo.toml", ".git" }),
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		})
	end,
})

-- TypeScript/JavaScript用のLSPとTree-sitterの設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		vim.treesitter.start()
		vim.lsp.start({
			name = "typescript-language-server",
			cmd = { "typescript-language-server", "--stdio" },
			root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", "jsconfig.json", ".git" }),
		})
	end,
})
