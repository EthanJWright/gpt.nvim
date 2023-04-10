local M = {}

local gpt_command = "chatgpt_cli"
local pipe_to = nil

function M.set_pipe_to(target)
	pipe_to = target
end

function M.set_gpt_command(command)
	gpt_command = command
end

local function visual_selection_range()
	local _, csrow, cscol, _ = unpack(vim.fn.getpos("v"))
	local _, cerow, cecol, _ = unpack(vim.fn.getcurpos())
	if csrow < cerow or (csrow == cerow and cscol <= cecol) then
		return csrow - 1, cscol - 1, cerow - 1, cecol
	else
		return cerow - 1, cecol - 1, csrow - 1, cscol
	end
end

local function get_visual_selection()
	local start_line, _, end_line, _ = visual_selection_range()
	local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)
	-- merge all lines into one string
	local text = table.concat(lines, " ")
	return text
end

local function send_to_gpt_with_prompt(prompt)
	local text = get_visual_selection()
	-- add markdown code blocks to increase the likelihood gpt will respond in
	-- kind
	text = string.gsub(text, "'", "'")
	local filetype = vim.bo.filetype
	text = "```" .. filetype .. text .. "```"

	local cmd = gpt_command .. " " .. " '" .. prompt .. " " .. text .. "'"
	if pipe_to ~= nil then
		cmd = cmd .. " | " .. pipe_to
	end
	vim.cmd("vsplit")
	vim.cmd("terminal " .. cmd)
end

-- runs the command 'g flush' without a terminal, but as a command
function M.flush()
	local cmd = "!" .. gpt_command .. " flush"
	vim.cmd(cmd)
end

function M.send_to_gpt()
	send_to_gpt_with_prompt("")
end

local PROPT_PREFIX = ""
local PROMPT_SUFFIX = ""

local function build_prompt(prompt)
	local filetype = vim.bo.filetype
	return PROPT_PREFIX .. prompt .. PROMPT_SUFFIX
end

function M.send_to_gpt_refactor()
	print("refactoring, please wait...")
	send_to_gpt_with_prompt(build_prompt("refactor this code "))
end

function M.send_to_gpt_comment()
	print("commenting, please wait...")
	send_to_gpt_with_prompt(build_prompt("comment this code "))
end

function M.send_to_gpt_document()
	print("documenting, please wait...")
	send_to_gpt_with_prompt(build_prompt("document this code "))
end

function M.send_to_gpt_test()
	print("testing, please wait...")
	send_to_gpt_with_prompt(build_prompt("write a test for this code "))
end

function M.send_to_gpt_debug()
	print("debugging, please wait...")
	send_to_gpt_with_prompt(build_prompt("debug this code "))
end

function M.send_to_gpt_explain()
	print("explaining, please wait...")
	send_to_gpt_with_prompt(build_prompt("explain this code "))
end

function M.send_to_gpt_example()
	print("writing an example, please wait...")
	send_to_gpt_with_prompt(build_prompt("write an example for this code "))
end

function M.send_to_gpt_custom()
	local prompt = vim.fn.input("prompt: ")
	send_to_gpt_with_prompt(build_prompt(prompt))
end

function M.setup(opts)
	if opts == nil then
		return
	end
	if opts.gpt_command then
		M.set_gpt_command(opts.gpt_command)
	end
	if opts.pipe_to then
		M.set_pipe_to(opts.pipe_to)
	end
end

return M
