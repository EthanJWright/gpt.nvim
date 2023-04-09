local M = {}

local gpt_command = "g"

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

function get_visual_selection()
  local start_line, start_col, end_line, end_col = visual_selection_range()
  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  -- merge all lines into one string
  local text = table.concat(lines, "")
  return text
end


local function send_to_gpt_with_prompt(prompt)
  local text = get_visual_selection()
  text = string.gsub(text, "\"", "\\\"")
  local cmd = gpt_command .. " " .. " \"" .. prompt ..  " ".. text .. "\""
  vim.cmd('vsplit')
  vim.cmd('terminal ' .. cmd)
end

-- runs the command 'g flush' without a terminal, but as a command
function M.flush()
  local cmd = '!' .. gpt_command .. " flush"
  vim.cmd(cmd)
end


function M.send_to_gpt()
  send_to_gpt_with_prompt("")
end

function M.send_to_gpt_refactor()
  print("refactoring, please wait...")
  send_to_gpt_with_prompt("please help me refactor the following code:")
end

function M.send_to_gpt_comment()
  print("commenting, please wait...")
  send_to_gpt_with_prompt("please help me comment the following code:")
end

function M.send_to_gpt_document()
  print("documenting, please wait...")
  send_to_gpt_with_prompt("please help me document the following code:")
end

function M.send_to_gpt_test()
  print("testing, please wait...")
  send_to_gpt_with_prompt("please help me write a test for the following code:")
end

function M.send_to_gpt_debug()
  print("debugging, please wait...")
  send_to_gpt_with_prompt("please help me debug the following code:")
end

function M.send_to_gpt_explain()
  print("explaining, please wait...")
  send_to_gpt_with_prompt("please help me explain the following code:")
end

function M.send_to_gpt_example()
  print("writing an example, please wait...")
  send_to_gpt_with_prompt("please help me write an example for the following code:")
end

function M.send_to_gpt_custom()
  local prompt = vim.fn.input("prompt: ")
  send_to_gpt_with_prompt(prompt)
end

function M.setup(opts)
  if opts == nil then
    return
  end
  if opts.gpt_command then
    M.set_gpt_command(opts.gpt_command)
  end
end

return M
