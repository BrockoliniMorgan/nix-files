{ ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  # enable formatters and linters
  programs.actionlint.enable = true;
  # programs.dos2unix.enable = true; # Useful if doing patches
  programs.keep-sorted.enable = true;
  programs.shellcheck.enable = true;
  programs.shfmt.enable = true;
  programs.nixfmt.enable = true;
}
