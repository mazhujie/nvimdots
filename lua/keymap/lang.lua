local bind = require("keymap.bind")
local map_cr = bind.map_cr

local mappings = {
	plugins = {
		-- Plugin: render-markdown.nvim
		["n|<F1>"] = map_cr("RenderMarkdown toggle")
			:with_noremap()
			:with_silent()
			:with_desc("工具：切换 Markdown 内嵌预览"),
		-- Plugin: MarkdownPreview
		["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("工具：打开／关闭 Markdown 浏览器预览"),
	},
}

bind.nvim_load_mapping(mappings.plugins)
