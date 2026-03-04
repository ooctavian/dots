vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.swapfile = false

vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.keymap.set('n', '<leader>e', function()
  return ':e ' .. vim.fn.expand '%:p:h' .. '/'
end, { expr = true, noremap = true })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<leader>x', '<cmd>bd<CR>')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Create directories when saving files
vim.cmd [[
    au BufWritePre,FileWritePre * if @% !~# '\(://\)' | call mkdir(expand('<afile>:p:h'), 'p') | endif
]]

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      local git_hunks = function()
        require('telescope.pickers')
          .new({
            finder = require('telescope.finders').new_oneshot_job({ 'git', 'jump', '--stdout', 'diff' }, {
              entry_maker = function(line)
                local filename, lnum_string = line:match '([^:]+):(%d+).*'

                -- I couldn't find a way to use grep in new_oneshot_job so we have to filter here.
                -- return nil if filename is /dev/null because this means the file was deleted.
                if filename:match '^/dev/null' then
                  return nil
                end

                return {
                  value = filename,
                  display = line,
                  ordinal = line,
                  filename = filename,
                  lnum = tonumber(lnum_string),
                }
              end,
            }),
            sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
            previewer = require('telescope.config').values.grep_previewer {},
            results_title = 'Git hunks',
            prompt_title = 'Git hunks',
            layout_strategy = 'flex',
          }, {})
          :find()
      end
      require('telescope').setup {
        defaults = vim.tbl_extend('force', require('telescope.themes').get_ivy(), {}),
        extensions = {},
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>.', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<Leader>gh', git_hunks, {})
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require 'nvim-tmux-navigation'
      nvim_tmux_nav.setup {
        disable_when_zoomed = true,
      }
      vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set('n', '<C-\\>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set('n', '<C-Space>', nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },

  {
    'aserowy/tmux.nvim',
    config = function()
      return require('tmux').setup {
        copy_sync = {
          enable = true,
          ignore_buffers = { empty = false },
          redirect_to_clipboard = false,
          register_offset = 0,
          sync_clipboard = true,
          sync_registers = true,
          sync_registers_keymap_put = true,
          sync_registers_keymap_reg = true,
          sync_deletes = true,
          sync_unnamed = true,
        },
        navigation = {
          cycle_navigation = true,
          enable_default_keybindings = true,
          persist_zoom = false,
        },
        resize = {
          enable_default_keybindings = true,
          resize_step_x = 1,
          resize_step_y = 1,
        },
      }
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', config = true },
      { 'mason-org/mason-lspconfig.nvim' },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        clangd = {
          capabilities = capabilities,
        },
        gopls = {
          capabilities = capabilities,
        },
        basedpyright = {
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = true
          end,
          capabilities = (function()
            local caps = vim.lsp.protocol.make_client_capabilities()
            caps = vim.tbl_deep_extend('force', caps, capabilities)
            caps.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return caps
          end)(),
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = 'standard',
                useLibraryCodeForTypes = true,
                diagnosticSeverityOverrides = {
                  reportUnusedVariable = 'warning',
                },
              },
            },
          },
        },
        ruff = {
          on_attach = function(client, _)
            if client.name == 'ruff' then
              client.server_capabilities.hoverProvider = false
            end
          end,
          init_options = {
            settings = {
              args = {
                '--ignore',
                'F821',
                '--ignore',
                'E402',
                '--ignore',
                'E722',
                '--ignore',
                'E712',
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }
      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {
    'stevanmilic/nvim-lspimport',
    config = function()
      vim.keymap.set('n', '<leader>a', require('lspimport').import, { noremap = true })
    end,
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 100000,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          {
            name = 'lazydev',
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_background = 'medium'
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  -- {
  --   'EdenEast/nightfox.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   init = function()
  --     vim.opt.background = 'dark'
  --     vim.cmd.colorscheme 'carbonfox'
  --     vim.cmd [[
  --      hi Normal       guibg=none ctermbg=none
  --      hi NormalNC     guibg=none ctermbg=none
  --      hi NormalFloat  guibg=none ctermbg=none
  --      hi FloatBorder  guibg=none ctermbg=none
  --      hi SignColumn   guibg=none ctermbg=none
  --      hi VertSplit    guibg=none ctermbg=none
  --      hi StatusLine   guibg=none ctermbg=none
  --      hi StatusLineNC guibg=none ctermbg=none
  --      hi EndOfBuffer  guibg=none ctermbg=none
  --      hi MsgArea      guibg=none ctermbg=none
  --     ]]
  --   end,
  -- },
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = true,
  },
  {
    'LunarVim/bigfile.nvim',
    config = function(self, opts)
      require('bigfile').setup {
        filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
        pattern = { '*' }, -- autocmd pattern or function see <### Overriding the detection of big files>
        features = { -- features to disable
          'indent_blankline',
          'illuminate',
          'lsp',
          'treesitter',
          'syntax',
          'matchparen',
          'vimopts',
          'filetype',
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'python' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  {
    'jay-babu/mason-nvim-dap.nvim',
    opts = {
      handlers = {},
      automatic_installation = {
        exclude = {
          'delve',
          'python',
        },
      },
      ensure_installed = {
        'bash',
        'codelldb',
        'php',
        'python',
      },
    },
    dependencies = {
      'mfussenegger/nvim-dap',
      'mason-org/mason.nvim',
    },
  },

  {
    'mfussenegger/nvim-dap',
    lazy = true,
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Continue',
      },
      {
        '<leader>dC',
        function()
          require('dap').run_to_cursor()
        end,
        desc = 'Run to Cursor',
      },
      {
        '<leader>dT',
        function()
          require('dap').terminate()
        end,
        desc = 'Terminate',
      },
    },
  },

  {
    'rcarriga/nvim-dap-ui',
    config = true,
    keys = {
      {
        '<leader>du',
        function()
          require('dapui').toggle {}
        end,
        desc = 'Dap UI',
      },
    },
    dependencies = {
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
    },
  },

  {
    'numToStr/Comment.nvim',
    opts = {},
    config = function(self, opts)
      require('Comment').setup(opts)
    end,
  },

  {
    'mfussenegger/nvim-dap-python',
    lazy = true,
    config = function()
      local python = vim.fn.expand '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(python)
    end,
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    keys = {
      {
        '<leader>dn',
        function()
          require('dap-python').test_method()
        end,
        mode = 'n',
        desc = 'Test Method',
      },
      {
        '<leader>df',
        function()
          require('dap-python').test_class()
        end,
        mode = 'n',
        desc = 'Test Class',
      },
    },
  },

  {
    'leoluz/nvim-dap-go',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = true,
  },

  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = true,
  },
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    config = function()
      local mc = require 'multicursor-nvim'
      mc.setup()

      local set = vim.keymap.set

      set({ 'n', 'x' }, '<M-D>', function()
        mc.lineAddCursor(-1)
      end)
      set({ 'n', 'x' }, '<M-d>', function()
        mc.lineAddCursor(1)
      end)

      set({ 'n', 'x' }, '<M-S>', function()
        mc.lineSkipCursor(-1)
      end)
      set({ 'n', 'x' }, '<M-s>', function()
        mc.lineSkipCursor(1)
      end)

      set('n', '<c-leftmouse>', mc.handleMouse)
      set('n', '<c-leftdrag>', mc.handleMouseDrag)
      set('n', '<c-leftrelease>', mc.handleMouseRelease)

      set({ 'n', 'x' }, '<c-q>', mc.toggleCursor)

      mc.addKeymapLayer(function(layerSet)
        layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
        layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

        layerSet({ 'n', 'x' }, '<leader>x', mc.deleteCursor)

        layerSet('n', '<esc>', function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      local hl = vim.api.nvim_set_hl
      hl(0, 'MultiCursorCursor', { reverse = true })
      hl(0, 'MultiCursorVisual', { link = 'Visual' })
      hl(0, 'MultiCursorSign', { link = 'SignColumn' })
      hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
      hl(0, 'MultiCursorDisabledCursor', { reverse = true })
      hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
      hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
    end,
  },
}, {})

-- Additional keymaps and configuration
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- DAP REPL integration for visual selection
vim.keymap.set('x', '<leader>di', function()
  local lines = vim.fn.getregion(vim.fn.getpos '.', vim.fn.getpos 'v')
  require('dap').repl.open()
  require('dap').repl.execute(table.concat(lines, '\n'))
end, { desc = 'Debug selection in REPL' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
