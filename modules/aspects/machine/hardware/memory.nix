{
  flake.modules.nixos.memory = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 25;
    };

    boot.tmp.useTmpfs = true;

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
    };
  };
}
