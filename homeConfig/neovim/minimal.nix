{ pkgs, ... }:
{
  syntaxHighlighting = true;
  telescope = {
    enable = true;
    extensions = [
      {
        name = "fzf";
        packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
        setup.fzf.fuzzy = true;
      }
    ];
  };
  options.wrap = false;
  globals.mapleader = " ";
  utility = {
    sleuth.enable = true; # Figures out the proper indenting for tab automatically
    smart-splits = {
      # Moving around in windows using leader+w+[hjkl]
      enable = true;
      keymaps = {
        move_cursor_down = "<leader>wj";
        move_cursor_up = "<leader>wk";
        move_cursor_left = "<leader>wh";
        move_cursor_right = "<leader>wl";
      };
    };
  };
}
