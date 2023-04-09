local M = {}

M.chat = require("gpt.chat")

M.setup(opts)
  if opts == nil then
    return
  end
  if opts.gpt_command then
    M.chat.set_gpt_command(opts.gpt_command)
  end
end

return M
