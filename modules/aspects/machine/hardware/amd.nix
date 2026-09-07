{
  flake.modules.nixos.amd = {
    boot.kernelModules = [ "kvm-amd" ];
    hardware.cpu.amd.updateMicrocode = true;
    hardware.amdgpu.initrd.enable = true;
  };
}
