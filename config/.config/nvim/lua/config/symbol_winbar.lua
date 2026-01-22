local M = {}

-- バッファごとのシンボル情報を保存するテーブル
local symbol_state = {}
-- autocmdをグループ化するためのグループ名
local symbol_group = vim.api.nvim_create_augroup("my_symbol_winbar", { clear = true })

-- バッファの状態を初期化・取得する
-- @param bufnr バッファ番号
-- @return バッファの状態テーブル
local function ensure_state(bufnr)
	symbol_state[bufnr] = symbol_state[bufnr] or {
		breadcrumb = "",
	}
	return symbol_state[bufnr]
end

-- LSPの位置情報をLua用に正規化する(0始まり→1始まりに変換)
-- @param range LSPから取得した範囲情報
-- @return 正規化された範囲情報
local function normalize_range(range)
	return {
		start_line = range.start.line + 1,
		start_col = range.start.character,
		end_line = range["end"].line + 1,
		end_col = range["end"].character,
	}
end

-- 後方参照のための宣言
local sort_by_position

-- LSPシンボルからノードを作成する
-- @param symbol LSPから取得したシンボル情報
-- @return 作成されたノード、またはnil
local function create_node(symbol)
	local range = symbol.range or (symbol.location and symbol.location.range)
	if not range then
		return nil
	end

	local node = {
		name = symbol.name or "[No Name]",
		kind = symbol.kind,
		range = normalize_range(range),
		children = {},
	}

	if symbol.children then
		for _, child in ipairs(symbol.children) do
			local child_node = create_node(child)
			if child_node then
				table.insert(node.children, child_node)
			end
		end
		sort_by_position(node.children)
	end

	return node
end

-- シンボルのリストを位置順(行、列)でソートする
-- @param items ソート対象のノードのリスト
sort_by_position = function(items)
	table.sort(items, function(a, b)
		local ra = a.range
		local rb = b.range
		if ra.start_line == rb.start_line then
			return ra.start_col < rb.start_col
		end
		return ra.start_line < rb.start_line
	end)
end

-- シンボルのリストから階層構造のツリーを構築する
-- @param symbols LSPから取得したシンボルのリスト
-- @return ルートノード
local function build_tree(symbols)
	local root = { children = {} }
	if not symbols then
		return root
	end

	local nodes = {}
	for _, symbol in ipairs(symbols) do
		local node = create_node(symbol)
		if node then
			table.insert(nodes, node)
		end
	end

	sort_by_position(nodes)
	root.children = nodes
	return root
end

-- 指定した位置が範囲内にあるか判定する
-- @param line 行番号
-- @param col 列番号
-- @param range 判定対象の範囲
-- @return 範囲内ならtrue、それ以外はfalse
local function position_in_range(line, col, range)
	if line < range.start_line or line > range.end_line then
		return false
	end
	if line == range.start_line and col < range.start_col then
		return false
	end
	if line == range.end_line and col > range.end_col then
		return false
	end
	return true
end

-- 指定した位置を含むシンボルの階層パスを再帰的に検索する
-- @param tree シンボルツリー
-- @param line 行番号
-- @param col 列番号
-- @return シンボルのパス(配列)
local function find_symbol_path(tree, line, col)
	local path = {}
	local function recurse(node)
		if not node.children or #node.children == 0 then
			return
		end
		for _, child in ipairs(node.children) do
			if position_in_range(line, col, child.range) then
				table.insert(path, child)
				recurse(child)
				return
			end
		end
	end

	recurse(tree)
	return path
end

-- documentSymbolProviderをサポートするLSPクライアントを検索する
-- @param bufnr バッファ番号
-- @return LSPクライアント、または見つからなければnil
local function find_client(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client.server_capabilities and client.server_capabilities.documentSymbolProvider then
			return client
		end
	end
end

-- シンボルパスからパンくずリスト文字列を生成する
-- @param bufnr バッファ番号
-- @param nodes シンボルノードの配列
local function set_breadcrumb(bufnr, nodes)
	local labels = {}
	for _, node in ipairs(nodes) do
		labels[#labels + 1] = node.name
	end
	ensure_state(bufnr).breadcrumb = table.concat(labels, " > ")
end

-- カーソル位置に基づいてコンテキストを更新する
-- @param bufnr バッファ番号
function M.update_context(bufnr)
	local state = symbol_state[bufnr]
	if not state or not state.tree then
		return
	end
	local ok, cursor = pcall(vim.api.nvim_win_get_cursor, 0)
	if not ok then
		return
	end
	local path = find_symbol_path(state.tree, cursor[1], cursor[2])
	set_breadcrumb(bufnr, path)
end

-- LSPから取得したシンボルを処理してツリーを構築する
-- @param bufnr バッファ番号
-- @param symbols LSPから取得したシンボルのリスト
function M._handle_symbols(bufnr, symbols)
	local state = ensure_state(bufnr)
	state.pending = false
	state.tree = build_tree(symbols)
	M.update_context(bufnr)
end

-- LSPにドキュメントシンボルのリクエストを送信する
-- @param bufnr バッファ番号
function M.request_symbols(bufnr)
	local state = ensure_state(bufnr)
	if state.pending then
		return
	end
	local client = find_client(bufnr)
	if not client then
		return
	end
	state.pending = true
	local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
	client.request("textDocument/documentSymbol", params, function(err, result)
		if err then
			state.pending = false
			return
		end
		M._handle_symbols(bufnr, result or {})
	end, bufnr)
end

-- バッファにシンボル追跡機能をアタッチする
-- カーソル移動やファイル編集時のautocmdを設定する
-- @param bufnr バッファ番号
function M.attach(bufnr)
	local state = ensure_state(bufnr)
	if state.attached then
		return
	end
	state.attached = true
	M.request_symbols(bufnr)
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
		group = symbol_group,
		buffer = bufnr,
		callback = function(args)
			M.update_context(args.buf)
		end,
	})
	vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "TextChangedI" }, {
		group = symbol_group,
		buffer = bufnr,
		callback = function(args)
			M.request_symbols(args.buf)
		end,
	})
	vim.api.nvim_create_autocmd("BufDelete", {
		group = symbol_group,
		buffer = bufnr,
		callback = function(args)
			symbol_state[args.buf] = nil
		end,
	})
end

-- 指定したバッファのパンくずリスト文字列を取得する
-- @param bufnr バッファ番号
-- @return パンくずリスト文字列
function M.breadcrumb(bufnr)
	local state = symbol_state[bufnr]
	if not state or state.breadcrumb == nil then
		return ""
	end
	return state.breadcrumb
end

-- 現在のバッファのパンくずリスト文字列を取得する
-- lualineなどのステータスライン用のコンポーネントとして使用
-- @return パンくずリスト文字列
function M.component_text()
	local buf = vim.api.nvim_get_current_buf()
	return M.breadcrumb(buf)
end

-- 現在のバッファにシンボル情報が存在するか確認する
-- @return シンボル情報があればtrue、なければfalse
function M.has_symbols()
	local buf = vim.api.nvim_get_current_buf()
	local state = symbol_state[buf]
	return state ~= nil and state.breadcrumb ~= nil and state.breadcrumb ~= ""
end

return M
