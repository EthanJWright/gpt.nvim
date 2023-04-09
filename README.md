gpt.nvim
===============

A Neovim plugin that sends selected code to the OpenAI GPT-3 chatbot for refactoring, commenting, documenting, testing, debugging, explaining, and generating examples.

Installation
------------

Install the plugin using your preferred package manager. For example, using [Packer.nvim](https://github.com/wbthomason/packer.nvim):

    use 'EthanJWright/gpt.nvim'

Use a chat gpt cli that persists chat and exits after a command. I'm using the
one I threw together [here](https://github.com/EthanJWright/gptCLI)

Setup
-----

Configure the plugin by calling the `setup()` function:

    require('gpt.chat').setup {
      gpt_command = "chatgpt_cli <YOUR-API-KEY-HERE>",
    }

The only configuration option is the `gpt_command`, which should be set to the command to run to invoke the OpenAI GPT-3 chatbot. This command should include any required API keys or authentication tokens.

Usage
-----

Most of the functions are designed to be called when you have code visually
selected.

Use the following whichkey keybindings to send code to the chatbot:

    local visual_mappings = {
      o = {
        name = "OpenAI",
        r = { "<cmd>lua require('gpt.chat').send_to_gpt_refactor()<cr>", "Refactor" },
        c = { "<cmd>lua require('gpt.chat').send_to_gpt_custom()<cr>", "Custom" },
        C = { "<cmd>lua require('gpt.chat').send_to_gpt_comment()<cr>", "Comment" },
        D = { "<cmd>lua require('gpt.chat').send_to_gpt_document()<cr>", "Document" },
        t = { "<cmd>lua require('gpt.chat').send_to_gpt_test()<cr>", "Test" },
        d = { "<cmd>lua require('gpt.chat').send_to_gpt_debug()<cr>", "Debug" },
        e = { "<cmd>lua require('gpt.chat').send_to_gpt_explain()<cr>", "Explain" },
        E = { "<cmd>lua require('gpt.chat').send_to_gpt_example()<cr>", "Example" },
        f = { "<cmd>lua require('gpt.chat').flush()<cr>", "Flush" },
      }
    }

The default prefix for the keybindings is `o`, which can be customized by modifying the `prefix` option when calling `which-key.register()`.
