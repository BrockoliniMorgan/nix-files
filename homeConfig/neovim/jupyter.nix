{ pkgs, ... }:
{
  extraPlugins = {
    jupytext = {
      package = pkgs.vimPlugins.jupytext-nvim;
      setup = ''require("jupytext").setup()'';
    };
  };
}
