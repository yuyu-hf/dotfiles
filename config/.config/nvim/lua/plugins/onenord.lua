---@type LazyPluginSpec
return {
	"rmehri01/onenord.nvim",
	event = { "VimEnter" },
	priority = 1000,
	config = function()
		require("onenord").setup({
			theme = "dark",
			borders = true,
			fade_nc = false,
			styles = {
				comments = "NONE",
				strings = "NONE",
				keywords = "bold",
				functions = "bold",
				variables = "NONE",
				diagnostics = "underline",
			},
			disable = {
				background = true,
				float_background = false,
				cursorline = false,
				eob_lines = true,
			},
			inverse = {
				match_paren = false,
			},
			custom_highlights = {},
			custom_colors = {},
		})
	end,
}
