{ lib, config, ... }:
lib.mkIf config.has_amd_gpu {
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
