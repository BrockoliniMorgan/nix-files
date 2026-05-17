{ lib, config, ... }:
lib.mkIf config.has_amd_gpu {
  nixpkgs.config.rocmSupport = true;
  services.lact.enable = true;
  hardware = {
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
