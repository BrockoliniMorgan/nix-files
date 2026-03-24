{ ... }:
{
  programs.qutebrowser = {
    enable = true;
    settings = {
      colors = {
        webpage = {
          bg = "black";
          darkmode = {
            enabled = true;
            policy.images = "smart";
          };
          preferred_color_scheme = "dark";
        };
      };
      content = {
        cookies = {
          accept = "no-3rdparty";
          store = false;
        };
        javascript.enabled = true;
      };
      fonts = {
        default_family = "Iosevka Nerd Font";
        default_size = "10.5pt";
      };
    };
  };
}
