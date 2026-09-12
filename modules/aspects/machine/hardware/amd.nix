{
  flake.modules.nixos.amd = {
    boot.kernelModules = [ "kvm-amd" ];
    hardware.cpu.amd.updateMicrocode = true;
    hardware.graphics.enable = true;
    hardware.amdgpu.initrd.enable = true;
  };
}
