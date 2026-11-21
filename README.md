# muj konfig niksoes (server edition) 🇵🇱🏔️❄️🥵

## Installation

1. Label the partitions:
   ```sh
   sfdisk --part-label /dev/<disk> 1 boot
   sfdisk --part-label /dev/<disk> 2 primary
   ```

2. Set up Btrfs:
   ```sh
   mkfs.btrfs -L nixos /dev/disk/by-partlabel/primary
   mount -o compress=zstd:1 /dev/disk/by-partlabel/primary /mnt
   btrfs subvolume create /mnt/home
   btrfs subvolume create /mnt/nix
   ```

3. Mount the boot partition:
   ```sh
   mount -m /dev/disk/by-partlabel/boot /mnt/boot
   ```

4. Install NixOS:
   ```sh
   nixos-install --flake github:v9x/nixos/server#<host> --no-channel-copy --no-root-passwd
   ```

## Orange Pi 5 Plus

1. Remove the microSD card, connect the board's USB-C data port to another machine and power it on while holding the MaskROM button.

2. Flash U-Boot to the SPI flash:
   ```sh
   nix build .#nixosConfigurations.opi.config.system.build.uboot
   curl -Lo /tmp/loader.bin https://dl.radxa.com/rock5/sw/images/loader/rk3588_spl_loader_v1.15.113.bin
   sudo -s
   nix shell nixpkgs#rkdeveloptool
   rkdeveloptool db /tmp/loader.bin
   rkdeveloptool cs 9
   rkdeveloptool wl 0 result/u-boot-rockchip-spi.bin
   rkdeveloptool rd
   ```