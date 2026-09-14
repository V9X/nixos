# muj konfig niksoes 🇵🇱🏔️❄️🥵

## Installation

1. Label the partitions:
   ```sh
   sfdisk --part-label /dev/nvme0n1 1 boot
   sfdisk --part-label /dev/nvme0n1 N primary
   ```

2. Set up the LUKS container:
   ```sh
   cryptsetup luksFormat --type luks2 /dev/disk/by-partlabel/primary
   cryptsetup open /dev/disk/by-partlabel/primary primary
   ```

3. Set up Btrfs inside LUKS:
   ```sh
   mkfs.btrfs -L nixos /dev/mapper/primary
   mount -o compress=zstd:1 /dev/mapper/primary /mnt
   btrfs subvolume create /mnt/home
   btrfs subvolume create /mnt/nix
   ```

4. Mount the boot partition:
   ```sh
   mount -m /dev/disk/by-partlabel/boot /mnt/boot
   ```

5. Hash the user password:
   ```sh
   install -d -m 700 /mnt/etc/secrets
   sh -c 'umask 077; mkpasswd -m yescrypt > /mnt/etc/secrets/password'
   ```

6. Install NixOS:
   ```sh
   nixos-install --flake github:v9x/nixos#<host> --no-channel-copy --no-root-passwd
   ```

## Secure Boot and TPM unlock

Secure Boot is handled by Limine, which generates its own keys on the first rebuild.

1. Rebuild once so the keys are generated:
   ```sh
   nh os switch
   ```

2. Confirm that `BOOTX64.EFI` is signed:
   ```sh
   sudo sbctl verify
   ```

3. Reboot into the firmware setup and clear the Secure Boot keys to enter Setup Mode.

4. Enroll the new keys and check the result:
   ```sh
   sudo sbctl enroll-keys -m -f
   sudo sbctl status
   ```

5. Reboot into the firmware setup again and enable Secure Boot.

6. Enroll the LUKS key into the TPM:
   ```sh
   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 --tpm2-with-pin=yes /dev/disk/by-partlabel/primary
   ```

7. Back up the LUKS header:
   ```sh
   sudo cryptsetup luksHeaderBackup /dev/disk/by-partlabel/primary --header-backup-file ./luks-header.img
   ```

## Windows

Disable hibernation and fast startup:
```powershell
powercfg /h off
```

Clean a dirty NTFS volume:
```powershell
chkdsk C: /f
```

Make Windows treat the hardware clock as UTC:
```powershell
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f
```

### BitLocker

Decrypt an encrypted drive:
```powershell
manage-bde -off C:
```

Prevent automatic device encryption:
```powershell
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\BitLocker" /v PreventDeviceEncryption /t REG_DWORD /d 1 /f
```

## Misc

Build and boot the configuration in a VM:
```sh
nixos-rebuild build-vm-with-bootloader --flake .#<host>
```

Rebuild from the remote flake:
```sh
sudo nixos-rebuild switch --flake github:v9x/nixos#<host>
```

Generate an SSH key pair:
```sh
ssh-keygen -t ed25519
```
