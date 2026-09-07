# muj konfig niksoes 🇵🇱🏔️❄️🥵

## Installation

1. Create the secrets directory:
   ```sh
   sudo install -d -m 700 /etc/secrets
   ```

2. Write the hashed password into it:
   ```sh
   sudo sh -c 'umask 077; mkpasswd -m yescrypt > /etc/secrets/password'
   ```

3. Generate an SSH key pair:
   ```sh
   ssh-keygen -t ed25519
   ```

4. Rebuild from this configuration:
   ```sh
   sudo nixos-rebuild switch --flake ./nixos#<host>
   ```

## Secure Boot

Secure Boot is handled by Limine, which generates its own keys under
`/var/lib/` on the first rebuild.

1. Rebuild once so the keys are generated:
   ```sh
   nh os switch
   ```

2. Confirm that `BOOTX64.EFI` is signed:
   ```sh
   sudo sbctl verify
   ```

3. Reboot into the firmware setup and clear the existing Secure Boot keys.
   This puts the machine into Setup Mode.

4. Enroll the new keys and check the result:
   ```sh
   sudo sbctl enroll-keys -m -f
   sudo sbctl status
   ```

5. Reboot into the firmware setup again and enable Secure Boot.

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

Disable BitLocker permanently:
```powershell
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\BitLocker" /v PreventDeviceEncryption /t REG_DWORD /d 1 /f
```

## Testing

Build and boot the configuration in a VM:
```sh
nixos-rebuild build-vm-with-bootloader --flake .#<host>
```
