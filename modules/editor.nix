{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lua-language-server
    yaml-language-server
    nil
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [
      # Theme
      catppuccin-nvim

      # Treesitter
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          go
          gomod
          gosum
          gowork
          lua
          typescript
          tsx
          javascript
          yaml
          json
          markdown
          markdown_inline
          dockerfile
        ]
      ))
      nvim-treesitter-context

      # LSP Configs (provides configs for vim.lsp.enable)
      nvim-lspconfig

      # UI / Tools
      diffview-nvim
      fzf-lua
      nvim-tree-lua
      vim-peekaboo
    ];

    extraConfig = ''
      " Load original vimrc settings
      filetype plugin indent on
      set autoread autoindent hidden lazyredraw noerrorbells noshowmode nowrap showmatch
      set shiftwidth=4 tabstop=4 expandtab smarttab
      set hlsearch incsearch ignorecase smartcase
      set number relativenumber cursorline signcolumn=yes scrolloff=5 laststatus=2
      set splitright splitbelow
      set wildmenu wildmode=list:longest,full
      set completeopt+=menu,noinsert,popup,fuzzy
      let mapleader="\<Space>"

      " FZF Mappings
      nnoremap <leader>a :FzfLua live_grep<CR>
      nnoremap <leader>b :FzfLua buffers<CR>
      nnoremap <leader>f :FzfLua files<CR>
      nnoremap <leader>l :FzfLua lines<CR>

      colorscheme catppuccin-mocha
      set background=dark

      " Filetypes
      autocmd BufRead,BufNewFile Brewfile* set ft=ruby
    '';

    initLua = ''
      vim.o.winborder = 'solid'

      -- nvim-tree (disable netrw before setup, as recommended)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require('nvim-tree').setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = { enable = true, update_root = true },
        view = { width = 35 },
        renderer = { group_empty = true },
        actions = { open_file = { quit_on_open = false } },
      })
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
      vim.keymap.set('n', '<leader>E', '<cmd>NvimTreeFindFile<CR>', { desc = 'Reveal file in tree' })

      vim.keymap.set('n', 'gl', '<cmd>FzfLua diagnostics_workspace<CR>')
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition)

      vim.opt.updatetime = 250
      vim.api.nvim_create_autocmd('CursorHold', {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.opt.foldtext = ""
      vim.opt.fillchars:append({ fold = ' ' })
      vim.opt.foldminlines = 5
      vim.opt.foldnestmax = 2
      vim.opt.foldlevel = 1
      vim.opt.foldlevelstart = 1

      -- LSP Setup
      vim.lsp.enable({ 'lua_ls', 'yamlls', 'nil_ls', 'gopls', 'ts_ls', 'ruby_lsp' })

      vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(args)
              local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
              local autocmd = vim.api.nvim_create_autocmd

              if client:supports_method('textDocument/completion') then
                  local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
                  autocmd({ 'TextChangedI' }, {
                      buffer = args.buf,
                      callback = function()
                          vim.lsp.completion.get()
                      end
                  })
                  client.server_capabilities.completionProvider.triggerCharacters = chars
                  vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
              end

              if client:supports_method('textDocument/formatting') then
                  autocmd('BufWritePre', {
                      buffer = args.buf,
                      callback = function()
                          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                      end,
                  })
              end

              if client:supports_method('textDocument/inlayHint') then
                  vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
              end
          end,
      })
    '';
  };
}
