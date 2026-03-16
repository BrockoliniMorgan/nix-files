{ pkgs, ... }:
{
  # NVF config
  viAlias = true;
  vimAlias = true;
  syntaxHighlighting = true;
  bell = "visual"; # No sounds
  telescope = {
    enable = true;
    extensions = [
      {
        name = "fzf";
        packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
        setup = {
          fzf = {
            fuzzy = true;
          };
        };
      }
    ];
  };
  git = {
    enable = true;
    git-conflict.enable = true;
    vim-fugitive.enable = true;
  };
  options = {
    wrap = false;
    autoindent = true;
  };
  globals.mapleader = " ";
  filetree.neo-tree = {
    enable = true;
    setupOpts = {
      enable_cursor_hijack = true; # The cursor is stuck at the start of the filename
      git_status_async = true;
    };
  };
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
  autocomplete = {
    # Autocomplete for text
    blink-cmp.enable = true;
  };
  diagnostics = {
    enable = true;
    config = {
      virtual_lines = true;
    };
  };
  binds = {
    hardtime-nvim.enable = true;
    whichKey = {
      enable = true;
      setupOpts = {
        notify = true;
      };
    };
  };
  autopairs.nvim-autopairs.enable = true;
  utility = {
    direnv.enable = true; # Direnv when entering directories
    icon-picker.enable = true; # Pretty icons
    images.image-nvim = {
      # Kitty can do images in the terminal!!
      enable = true;
      setupOpts = {
        backend = "kitty";
        editorOnlyRenderWhenFocused = true;
        integrations.markdown = {
          clearInInsertMode = true;
          downloadRemoteImages = true;
        };
      };
    };
    sleuth.enable = true; # Figures out the proper indenting for tab automatically
    mkdir.enable = true; # Make all directories when they don't exist down to the file/directory selected
    nix-develop.enable = true;
    smart-splits = {
      # Moving around in windows using Alt+hjkl and resizing using Alt+r hjkl
      enable = true;
      keymaps = {
        move_cursor_down = "<leader>j";
        move_cursor_up = "<leader>k";
        move_cursor_left = "<leader>h";
        move_cursor_right = "<leader>l";
        resize_down = "<leader><C-j>";
        resize_up = "<leader><C-k>";
        resize_left = "<leader><C-h>";
        resize_right = "<leader><C-l>";
      };
    };
    undotree.enable = true; # TODO: configure this with bindings. Looks cool, I have no idea how to use it
  };
  visuals = {
    cinnamon-nvim.enable = true; # TODO: configure this? Doesn't seem to be doing anything
    highlight-undo.enable = true; # Highlight changes when in normal mode
    indent-blankline.enable = true; # Indentation visual. TODO: Make these softer. Right now, they're kinda bright
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
    # enableExtraDiagnostics = true; # Who can't use more diagnostics. TODO: configure this. not sure what it does
    enableFormat = true; # Format every language enabled below
    enableTreesitter = true; # Automatically enable treesitter parser for every language enable below
    bash = {
      enable = true;
      lsp.enable = true;
    };
    clang = {
      enable = true;
      cHeader = true;
      lsp.enable = true;
    };
    css = {
      enable = true;
      lsp.enable = true;
    };
    json = {
      enable = true;
      lsp.enable = true;
    };
    markdown = {
      enable = true;
      extensions.markview-nvim.enable = true;
    };
    nix = {
      enable = true;
      format = {
        enable = true;
        type = [ "nixfmt" ];
      };
      lsp = {
        enable = true;
        servers = [ "nixd" ];
      };
    };
    python = {
      enable = true;
      format = {
        enable = true;
        type = [ "ruff" ];
      };
      lsp = {
        servers = [ "python-lsp-server" ];
        enable = true;
      };
      treesitter = {
        enable = true;
        package = pkgs.vimPlugins.nvim-treesitter-parsers.python; # For some reason the default python treesitter package is empty?
      };
    };
    svelte = {
      enable = true;
      lsp.enable = true;
    };
    ts = {
      enable = true;
      extensions.ts-error-translator.enable = true;
      lsp.enable = true;
    };
    yaml = {
      enable = true;
      lsp.enable = true;
    };
  };
}
