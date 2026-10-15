local vim_path = require("core.global").vim_path
local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local helpers = require("keymap.helpers")

local mappings = {
	plugins = {
		-- Plugin: vim-fugitive
		["n|gps"] = map_cr("G push"):with_noremap():with_silent():with_desc("Git：推送"),
		["n|gpl"] = map_cr("G pull"):with_noremap():with_silent():with_desc("Git：拉取"),
		["n|<leader>gG"] = map_cu("Git"):with_noremap():with_silent():with_desc("Git：打开 Git 操作面板"),

		-- Plugin: edgy
		["n|<C-n>"] = map_callback(function()
				require("edgy").toggle("left")
			end)
			:with_noremap()
			:with_silent()
			:with_desc("文件树：显示／隐藏"),

		-- Plugin: nvim-tree
		["n|<leader>nf"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent():with_desc("文件树：定位当前文件"),
		["n|<leader>nr"] = map_cr("NvimTreeRefresh"):with_noremap():with_silent():with_desc("文件树：刷新"),

		-- Plugin: sniprun
		["v|<leader>r"] = map_cr("SnipRun"):with_noremap():with_silent():with_desc("工具：运行选中代码"),
		["n|<leader>r"] = map_cu([[%SnipRun]]):with_noremap():with_silent():with_desc("工具：运行整个文件"),

		-- Plugin: toggleterm
		["t|<Esc><Esc>"] = map_cmd([[<C-\><C-n>]]):with_noremap():with_silent(), -- switch to normal mode in terminal.
		["n|<C-\\>"] = map_cr("ToggleTerm direction=horizontal")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏底部终端"),
		["i|<C-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=horizontal<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏底部终端"),
		["t|<C-\\>"] = map_cmd("<Cmd>ToggleTerm<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏底部终端"),
		["n|<A-\\>"] = map_cr("ToggleTerm direction=vertical")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏侧边终端"),
		["i|<A-\\>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏侧边终端"),
		["t|<A-\\>"] = map_cmd("<Cmd>ToggleTerm<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏侧边终端"),
		["n|<F5>"] = map_cr("ToggleTerm direction=vertical")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏侧边终端"),
		["i|<F5>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏侧边终端"),
		["t|<F5>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("终端：显示／隐藏侧边终端"),
		["n|<A-d>"] = map_cr("ToggleTerm direction=float")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏浮动终端"),
		["i|<A-d>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=float<CR>")
			:with_noremap()
			:with_silent()
			:with_desc("终端：显示／隐藏浮动终端"),
		["t|<A-d>"] = map_cmd("<Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("终端：显示／隐藏浮动终端"),
		["n|<leader>gg"] = map_callback(function()
				helpers.toggle_lazygit()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("Git：打开／关闭 lazygit"),

		-- Plugin: trouble
		["n|gt"] = map_cr("Trouble diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("代码：显示／隐藏诊断列表"),
		["n|<leader>lw"] = map_cr("Trouble diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("代码：查看工作区诊断"),
		["n|<leader>lp"] = map_cr("Trouble project_diagnostics toggle")
			:with_noremap()
			:with_silent()
			:with_desc("代码：查看项目诊断"),
		["n|<leader>ld"] = map_cr("Trouble diagnostics toggle filter.buf=0")
			:with_noremap()
			:with_silent()
			:with_desc("代码：查看当前文件诊断"),

		-- Plugin: telescope
		["n|<C-p>"] = map_callback(function()
				helpers.picker("keymaps", {
					prompt_title = "快捷键查询",
					lhs_filter = function(lhs)
						return not string.find(lhs, "Þ")
					end,
				})
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：打开快捷键查询面板"),
		["n|<leader>fc"] = map_callback(function()
				helpers.telescope_collections(require("telescope.themes").get_dropdown())
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：选择搜索类别"),
		["n|<leader>ff"] = map_callback(function()
				require("search").open({ collection = "file" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：按文件名查找"),
		["n|<leader>fp"] = map_callback(function()
				require("search").open({ collection = "pattern" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：搜索项目内容"),
		["v|<leader>fs"] = map_callback(function()
				local is_config = vim.uv.cwd() == vim_path
				if require("core.settings").search_backend == "fzf" then
					require("fzf-lua").grep_project({
						search = require("fzf-lua.utils").get_visual_selection(),
						rg_opts = "--column --line-number --no-heading --color=always --smart-case"
							.. (is_config and " --no-ignore --hidden --glob '!.git/*'" or ""),
					})
				else
					require("telescope-live-grep-args.shortcuts").grep_visual_selection(
						is_config and { additional_args = { "--no-ignore" } } or {}
					)
				end
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：搜索选中文字"),
		["n|<leader>fg"] = map_callback(function()
				require("search").open({ collection = "git" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：查找 Git 分支和提交"),
		["n|<leader>fd"] = map_callback(function()
				require("search").open({ collection = "dossier" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：查找项目和会话"),
		["n|<leader>fm"] = map_callback(function()
				require("search").open({ collection = "misc" })
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：其他搜索工具"),
		["n|<leader>fr"] = map_cr("Telescope resume")
			:with_noremap()
			:with_silent()
			:with_desc("工具：恢复上次搜索"),
		["n|<leader>fR"] = map_callback(function()
				if require("core.settings").search_backend == "fzf" then
					require("fzf-lua").resume()
				end
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：恢复上次搜索"),

		-- Plugin: dap
		["n|<F6>"] = map_callback(function()
				require("dap").continue()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：启动／继续"),
		["n|<F7>"] = map_callback(function()
				require("dap").terminate()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：停止"),
		["n|<F8>"] = map_callback(function()
				require("dap").toggle_breakpoint()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：设置／取消断点"),
		["n|<F9>"] = map_callback(function()
				require("dap").step_into()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：单步进入"),
		["n|<F10>"] = map_callback(function()
				require("dap").step_out()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：单步跳出"),
		["n|<F11>"] = map_callback(function()
				require("dap").step_over()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：单步跳过"),
		["n|<leader>db"] = map_callback(function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：设置条件断点"),
		["n|<leader>dc"] = map_callback(function()
				require("dap").run_to_cursor()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：运行到光标处"),
		["n|<leader>dl"] = map_callback(function()
				require("dap").run_last()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：重新运行上次调试"),
		["n|<leader>do"] = map_callback(function()
				require("dap").repl.open()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：打开交互控制台"),
		["n|<leader>dC"] = map_callback(function()
				require("dapui").close()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("调试：关闭调试界面"),

		--- Plugin: CodeCompanion and edgy
		["n|<leader>cs"] = map_callback(function()
				helpers.select_chat_model()
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：选择聊天模型"),
		["nv|<leader>cc"] = map_callback(function()
				require("edgy").toggle("right")
			end)
			:with_noremap()
			:with_silent()
			:with_desc("工具：显示／隐藏 AI 聊天"),
		["nv|<leader>ck"] = map_cr("CodeCompanionActions")
			:with_noremap()
			:with_silent()
			:with_desc("工具：选择 AI 操作"),
		["v|<leader>ca"] = map_cr("CodeCompanionChat Add")
			:with_noremap()
			:with_silent()
			:with_desc("工具：将选中内容添加到 AI 聊天"),
	},
}

bind.nvim_load_mapping(mappings.plugins)
