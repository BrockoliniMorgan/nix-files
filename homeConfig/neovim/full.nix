{ ... }:
{
  # NVF config
  viAlias = false;
  bell = "visual"; # No sounds
  git.enable = true;
  options.autoindent = true;
  lsp = {
    # Language server protocol support
    enable = true; # Automatically set lsp.enable = true for all enabled languages
    formatOnSave = true; # Format on save!
    inlayHints.enable = true;
    lspkind.enable = true;
    null-ls.enable = true;
  };
  theme = {
    # Gruvbox dark theme
    enable = true;
    name = "gruvbox";
    style = "dark";
  };
  # Autocomplete for text
  autocomplete.blink-cmp.enable = true;
  diagnostics = {
    enable = true;
    config.virtual_lines = true;
  };
  binds = {
    hardtime-nvim.enable = true;
    whichKey = {
      enable = true;
      setupOpts.notify = true;
    };
  };
  autopairs.nvim-autopairs.enable = true;
  utility = {
    icon-picker.enable = true; # Pretty icons
    smart-splits = {
      # Resizing windows using leader+w+[HJKL]
      keymaps = {
        # TODO: Reconfigure this - it's kinda annoying
        resize_down = "<leader>wJ";
        resize_up = "<leader>wK";
        resize_left = "<leader>wH";
        resize_right = "<leader>wL";
      };
    };
    undotree.enable = true;
  };
  visuals = {
    highlight-undo.enable = true; # Highlight changes when in normal mode
    indent-blankline.enable = true; # Indentation visual
    nvim-cursorline = {
      # Underline the current word everywhere
      enable = true;
      setupOpts.cursorword = {
        enable = true;
        hl.underline = true;
      };
    };
  };
  languages = {
    enableDAP = true; # Automatically have Debug Adapters on
    enableFormat = true; # Format every language enabled below
    enableTreesitter = true; # Automatically enable treesitter parser for every language enable below
    bash.enable = true;
    css.enable = true;
    json.enable = true;
    markdown.enable = true;
    svelte.enable = true;
    yaml.enable = true;
    tex.enable = true;
    clang = {
      enable = true;
      cHeader = true;
    };
    nix = {
      enable = true;
      format.type = [ "nixfmt" ];
      lsp.servers = [ "nixd" ];
    };
    python = {
      enable = true;
      format.type = [ "ruff" ];
      lsp.servers = [ "python-lsp-server" ];
    };
    typescript = {
      enable = true;
      extensions.ts-error-translator.enable = true;
    };
  };
  keymaps = [
    {
      key = "<leader>ut";
      mode = "n";
      action = "vim.cmd.UndotreeToggle";
      lua = true;
      unique = true;
    }
    {
      key = "<leader>uf";
      mode = "n";
      action = ''
        function()
          vim.cmd.UndotreeShow()
          vim.cmd.UndotreeFocus()
        end'';
      lua = true;
      unique = true;
    }
  ];
}
