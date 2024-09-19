return {
    {
        "williamboman/mason.nvim",
        config = function()
            -- setup mason with default properties
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            -- ensure that we have lua language server, typescript launguage server, java language server, and java test language server are installed
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pylsp", "bashls", "jdtls" },
            })
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            -- ensure the java debug adapter is installed
            require("mason-nvim-dap").setup({
                ensure_installed = { "javadbg", "javatest" }
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = cmp_lsp.default_capabilities()

            require("fidget").setup({})
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "it", "describe", "before_each", "after_each" },
                        }
                    }
                }
            })

            lspconfig.pylsp.setup({
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            -- formatter options
                            black = {
                                enabled = true,
                                line_length = 79
                            },
                            autopep8 = { enabled = false },
                            yapf = { enabled = false },

                            -- linter options
                            -- pylint = { enabled = false, executable = "pylint" },
                            -- pyflakes = { enabled = true },
                            -- pycodestyle = { enabled = false },

                            -- type checker
                            pylsp_mypy = { enabled = true },
                            -- auto-completion options
                            jedi_completion = { fuzzy = true },
                            -- import sorting
                            pyls_isort = { enabled = true },
                        },
                    }
                }
            })

            -- Set vim motion for <Space> + c + h to show code documentation about the code the cursor is currently over if available
            vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
            -- Set vim motion for <Space> + c + d to go where the code/variable under the cursor was defined
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
            -- Set vim motion for <Space> + c + a for display code action suggestions for code diagnostics in both normal and visual mode
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
            -- Set vim motion for <Space> + c + r to display references to the code under the cursor
            vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode Goto [R]eferences" })
            -- Set vim motion for <Space> + c + i to display implementations to the code under the cursor
            vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Goto [I]mplementations" })
            -- Set a vim motion for <Space> + c + <Shift>R to smartly rename the code under the cursor
            vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
            -- Set a vim motion for <Space> + c + <Shift>D to go to where the code/object was declared in the project (class file)
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
        end
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            'theHamsta/nvim-dap-virtual-text',
            'rcarriga/nvim-dap-ui',
            'nvim-neotest/nvim-nio',
            'jbyuki/one-small-step-for-vimkind',
            'nvim-telescope/telescope.nvim',
            'nvim-telescope/telescope-dap.nvim',
            'mfussenegger/nvim-dap-python',
        },
        config = function()
            local keymap = vim.keymap.set


            require('nvim-dap-virtual-text').setup({
                -- Use eol instead of inline
                virt_text_pos = "eol",
            })

            keymap(
                { 'n', 'v' },
                '<F3>',
                "<cmd>lua require('dapui').toggle()<CR>",
                { silent = true, desc = 'DAP toggle UI' }
            )
            keymap(
                { 'n', 'v' },
                '<F4>',
                "<cmd>lua require('dap').pause()<CR>",
                { silent = true, desc = 'DAP pause (thread)' }
            )
            keymap(
                { 'n', 'v' },
                '<F5>',
                "<cmd>lua require('dap').continue()<CR>",
                { silent = true, desc = 'DAP launch or continue' }
            )
            keymap(
                { 'n', 'v' },
                '<F6>',
                "<cmd>lua require('dap').step_into()<CR>",
                { silent = true, desc = 'DAP step into' }
            )
            keymap(
                { 'n', 'v' },
                '<F7>',
                "<cmd>lua require('dap').step_over()<CR>",
                { silent = true, desc = 'DAP step over' }
            )
            keymap(
                { 'n', 'v' },
                '<F8>',
                "<cmd>lua require('dap').step_out()<CR>",
                { silent = true, desc = 'DAP step out' }
            )
            keymap(
                { 'n', 'v' },
                '<F9>',
                "<cmd>lua require('dap').step_back()<CR>",
                { silent = true, desc = 'DAP step back' }
            )
            keymap(
                { 'n', 'v' },
                '<leader>bp',
                "<cmd>lua require('dap').toggle_breakpoint()<CR>",
                { silent = true, desc = 'DAP toggle breakpoint' }
            )
            keymap(
                { 'n', 'v' },
                '<leader>dB',
                "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
                { silent = true, desc = 'DAP set breakpoint with condition' }
            )
            keymap(
                { 'n', 'v' },
                '<leader>dp',
                "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
                { silent = true, desc = 'DAP set breakpoint with log point message' }
            )

            local telescope_dap = require('telescope').extensions.dap

            keymap({ 'n', 'v' }, '<leader>d?', function()
                telescope_dap.commands({})
            end, { silent = true, desc = 'DAP builtin commands' })
            keymap({ 'n', 'v' }, '<leader>dl', function()
                telescope_dap.list_breakpoints({})
            end, { silent = true, desc = 'DAP breakpoint list' })
            keymap({ 'n', 'v' }, '<leader>df', function()
                telescope_dap.frames()
            end, { silent = true, desc = 'DAP frames' })
            keymap({ 'n', 'v' }, '<leader>dv', function()
                telescope_dap.variables()
            end, { silent = true, desc = 'DAP variables' })
            keymap({ 'n', 'v' }, '<leader>dc', function()
                telescope_dap.configurations()
            end, { silent = true, desc = 'DAP debugger configurations' })
            local dapui = require("dapui")
            dapui.setup({
                layouts = {
                    -- Changing the layout order will give more space to the first element
                    {
                        -- You can change the order of elements in the sidebar
                        elements = {
                            -- { id = "scopes", size = 0.25, },
                            { id = 'stacks', size = 0.50 },
                            { id = 'breakpoints', size = 0.25 },
                            { id = 'watches', size = 0.25 },
                        },
                        size = 56,
                        position = 'right', -- Can be "left" or "right"
                    },
                    {
                        elements = {
                            { id = 'repl', size = 0.60 },
                            { id = 'console', size = 0.40 },
                        },
                        size = 8,
                        position = 'bottom', -- Can be "bottom" or "top"
                    },
                },
                controls = {
                    icons = {
                        pause = '',
                        play = ' (F5)',
                        step_into = ' (F6)',
                        step_over = ' (F7)',
                        step_out = ' (F8)',
                        step_back = ' (F9)',
                        run_last = ' (F10)',
                        terminate = ' (F12)',
                        disconnect = ' ([l]d)',
                    },
                },
            })

            local dap = require('dap')

            dap.listeners.after.event_initialized['dapui_config'] = function()
                dapui.open()
            end
        end
    },
    {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        -- get access to the none-ls functions
        local null_ls = require("null-ls")
        -- run the setup function for none-ls to setup our different formatters
        null_ls.setup({
            sources = {
                -- setup lua formatter
                null_ls.builtins.formatting.stylua,
                -- setup prettier to format languages that are not lua
                null_ls.builtins.formatting.prettier
            }
        })

        -- set up a vim motion for <Space> + c + f to automatically format our code based on which langauge server is active
        vim.keymap.set({"n", "v"}, "<leader>cf", vim.lsp.buf.format, { desc = "[C]ode [F]ormat" })
    end
}
}
