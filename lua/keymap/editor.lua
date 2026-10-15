---@diagnostic disable: undefined-global
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode
local helpers = require("keymap.helpers")

local ts_to_select = require("nvim-treesitter-textobjects.select")
local ts_to_swap = require("nvim-treesitter-textobjects.swap")
local ts_to_move = require("nvim-treesitter-textobjects.move")
local ts_to_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

local mappings = {
	builtins = {
		-- Builtins: Save & Quit
		["n|<C-s>"] = map_cu("write"):with_noremap():with_silent():with_desc("编辑：保存文件"),
		["n|<C-q>"] = map_cr("wq"):with_desc("编辑：保存并退出"),
		["n|<A-S-q>"] = map_cr("q!"):with_desc("编辑：强制退出"),

		-- Builtins: Insert mode
		["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap():with_desc("编辑：删除光标前的内容"),
		["i|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("编辑：光标左移"),
		["i|<C-a>"] = map_cmd("<ESC>^i"):with_noremap():with_desc("编辑：光标移到行首"),
		["i|<C-s>"] = map_cmd("<Esc>:w<CR>"):with_desc("编辑：保存文件"),
		["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"):with_desc("编辑：保存并退出"),

		-- Builtins: Command mode
		["c|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("编辑：光标左移"),
		["c|<C-f>"] = map_cmd("<Right>"):with_noremap():with_desc("编辑：光标右移"),
		["c|<C-a>"] = map_cmd("<Home>"):with_noremap():with_desc("编辑：移到行首"),
		["c|<C-e>"] = map_cmd("<End>"):with_noremap():with_desc("编辑：移到行尾"),
		["c|<C-d>"] = map_cmd("<Del>"):with_noremap():with_desc("编辑：删除"),
		["c|<C-h>"] = map_cmd("<BS>"):with_noremap():with_desc("编辑：退格删除"),
		["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]])
			:with_noremap()
			:with_desc("编辑：插入当前文件路径"),

		-- Builtins: Visual mode
		["v|J"] = map_cmd(":m '>+1<CR>gv=gv"):with_desc("编辑：将选中行下移"),
		["v|K"] = map_cmd(":m '<-2<CR>gv=gv"):with_desc("编辑：将选中行上移"),
		["v|<"] = map_cmd("<gv"):with_desc("编辑：减少缩进"),
		["v|>"] = map_cmd(">gv"):with_desc("编辑：增加缩进"),

		-- Builtins: "Suckless" - named after r/suckless
		["n|Y"] = map_cmd("y$"):with_desc("编辑：复制到行尾"),
		["n|D"] = map_cmd("d$"):with_desc("编辑：删除到行尾"),
		["n|n"] = map_cmd("nzzzv"):with_noremap():with_desc("编辑：下一个搜索结果"),
		["n|N"] = map_cmd("Nzzzv"):with_noremap():with_desc("编辑：上一个搜索结果"),
		["n|J"] = map_cmd("mzJ`z"):with_noremap():with_desc("编辑：合并下一行"),
		["n|<S-Tab>"] = map_cr("normal za"):with_noremap():with_silent():with_desc("编辑：展开／折叠代码"),
		["n|<Esc>"] = map_callback(function()
				helpers.flash_esc_or_noh()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("编辑：清除搜索高亮"),
		["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("编辑：开启／关闭拼写检查"),
	},
	plugins = {
		-- Plugin: persisted.nvim
		["n|<leader>ss"] = map_cu("SessionSave"):with_noremap():with_silent():with_desc("会话：保存会话"),
		["n|<leader>sl"] = map_cu("SessionLoad"):with_noremap():with_silent():with_desc("会话：恢复当前目录会话"),
		["n|<leader>sd"] = map_cu("SessionDelete"):with_noremap():with_silent():with_desc("会话：删除会话"),

		-- Plugin: comment.nvim
		["n|gcc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
					or et("<Plug>(comment_toggle_linewise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("编辑：添加／取消行注释"),
		["n|gbc"] = map_callback(function()
				return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
					or et("<Plug>(comment_toggle_blockwise_count)")
			end)
			:with_silent()
			:with_noremap()
			:with_expr()
			:with_desc("编辑：添加／取消块注释"),
		["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑：按范围添加／取消行注释"),
		["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑：按范围添加／取消块注释"),
		["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑：添加／取消选中内容的行注释"),
		["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)")
			:with_silent()
			:with_noremap()
			:with_desc("编辑：添加／取消选中内容的块注释"),

		-- Plugin: diffview.nvim
		["n|<leader>gd"] = map_cr("DiffviewOpen"):with_silent():with_noremap():with_desc("Git：查看差异"),
		["n|<leader>gD"] = map_cr("DiffviewClose"):with_silent():with_noremap():with_desc("Git：关闭差异视图"),

		-- Plugin: hop.nvim
		["nv|<leader>w"] = map_cmd("<Cmd>HopWordMW<CR>"):with_noremap():with_desc("跳转：跳转到单词"),
		["nv|<leader>j"] = map_cmd("<Cmd>HopLineMW<CR>"):with_noremap():with_desc("跳转：跳转到行"),
		["nv|<leader>k"] = map_cmd("<Cmd>HopLineMW<CR>"):with_noremap():with_desc("跳转：跳转到行"),
		["nv|<leader>c"] = map_cmd("<Cmd>HopChar1MW<CR>"):with_noremap():with_desc("跳转：按一个字符跳转"),
		["nv|<leader>C"] = map_cmd("<Cmd>HopChar2MW<CR>"):with_noremap():with_desc("跳转：按两个字符跳转"),

		-- Plugin: grug-far
		["n|<leader>Ss"] = map_callback(function()
				require("grug-far").open()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：打开搜索替换面板"),
		["n|<leader>Sp"] = map_callback(function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：在项目中搜索替换当前单词"),
		["v|<leader>Sp"] = map_callback(function()
				require("grug-far").with_visual_selection()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：在项目中搜索替换选中内容"),
		["n|<leader>Sf"] = map_callback(function()
				require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：在当前文件中搜索替换"),

		-- Plugin: nvim-treehopper
		["o|m"] = map_cu("lua require('tsht').nodes()"):with_silent():with_desc("跳转：选择语法树节点"),

		-- Plugin: suda.vim
		["n|<A-s>"] = map_cu("SudaWrite"):with_silent():with_noremap():with_desc("编辑：使用 sudo 保存文件"),

		-- Plugin: nvim-treesitter-textobjects
		-- Text objects: select
		["xo|af"] = map_callback(function()
				ts_to_select.select_textobject("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：选择整个函数"),
		["xo|if"] = map_callback(function()
				ts_to_select.select_textobject("@function.inner", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：选择函数内部"),
		["xo|ac"] = map_callback(function()
				ts_to_select.select_textobject("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：选择整个类"),
		["xo|ic"] = map_callback(function()
				ts_to_select.select_textobject("@class.inner", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：选择类内部"),
		-- Text objects: swap
		["n|<leader>a"] = map_callback(function()
				ts_to_swap.swap_next("@parameter.inner")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：与下一个参数交换内容"),
		["n|<leader>A"] = map_callback(function()
				ts_to_swap.swap_next("@parameter.outer")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：与下一个参数交换（含分隔符）"),
		-- Text objects: move
		["nxo|]["] = map_callback(function()
				ts_to_move.goto_next_start("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：跳到下一个函数开头"),
		["nxo|]m"] = map_callback(function()
				ts_to_move.goto_next_start("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：跳到下一个类开头"),
		["nxo|]]"] = map_callback(function()
				ts_to_move.goto_next_end("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：跳到下一个函数结尾"),
		["nxo|]M"] = map_callback(function()
				ts_to_move.goto_next_end("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：跳到下一个类结尾"),
		["nxo|[["] = map_callback(function()
				ts_to_move.goto_previous_start("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：跳到上一个函数开头"),
		["nxo|[m"] = map_callback(function()
				ts_to_move.goto_previous_start("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：跳到上一个类开头"),
		["nxo|[]"] = map_callback(function()
				ts_to_move.goto_previous_end("@function.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：跳到上一个函数结尾"),
		["nxo|[M"] = map_callback(function()
				ts_to_move.goto_previous_end("@class.outer", "textobjects")
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：跳到上一个类结尾"),
		-- movements repeat
		["nxo|;"] = map_callback(function()
				ts_to_repeat_move.repeat_last_move_next()
			end)
			:with_silent()
			:with_noremap()
			:with_desc("编辑：重复上次跳转"),
	},
}

bind.nvim_load_mapping(mappings.builtins)
bind.nvim_load_mapping(mappings.plugins)
