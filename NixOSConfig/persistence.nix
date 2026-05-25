{ username, ... }:
{
  environment.persistence."/persistent" = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth/"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump/"
      "/etc/NetworkManager/system-connections/"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.${username} = {
      directories = [
        "Projects"
        "Documents"
        ".local/share/direnv"
        ".local/share/Steam"
        ".config/vivaldi"
        ".ssh"
      ];
    };
  };
}
