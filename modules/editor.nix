{pkgs, ...}: {
  home.packages = with pkgs; [
    # Language Servers
    gopls
    lua-language-server
    typescript-language-server
    yaml-language-server
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
      (nvim-treesitter.withPlugins (plugins:
        with plugins; [
          go
          gomod
          gosum
          gowork
          lua
          typescript
          javascript
          yaml
          json
          markdown
          markdown_inline
          dockerfile
        ]))
      nvim-treesitter-context

      # LSP Configs (provides configs for vim.lsp.enable)
      nvim-lspconfig

      # UI / Tools
      diffview-nvim
      fzf-vim
      fzf-lua
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
      autocmd BufRead,BufNewFile */.circleci/config.{yaml,yml} set ft=circleci-yaml
      autocmd BufRead,BufNewFile Brewfile* set ft=ruby
    '';

    initLua = ''
      -- LSP Setup
      vim.lsp.enable({ 'lua_ls', 'gopls', 'ts_ls' })

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
