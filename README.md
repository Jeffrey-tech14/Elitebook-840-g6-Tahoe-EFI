# HP EliteBook 840 G6 (i5-8365U) on macOS Tahoe 26.7.3

**Working OpenCore EFI for macOS Tahoe 26.7.3 (25G342). Everything on this build works, including AirDrop, iMessage, FaceTime, and the internal digital microphone.**

![macOS desktop](Images/Screenshot%202026-11-26%20at%2009.18.46.png)

## Hardware

| Component        | Details                                                                        |
| ---------------- | ------------------------------------------------------------------------------ |
| CPU              | Intel Core i5-8365U, Whiskey Lake, 4 cores / 8 threads, 1.6 GHz base           |
| GPU              | Intel UHD Graphics 620, 1536 MB dynamic VRAM, 1080p touchscreen, Metal 3       |
| RAM              | 12 GB                                                                          |
| Laptop           | HP EliteBook 840 G6                                                            |
| SMBIOS           | MacBookPro16,3                                                                 |
| Audio codec      | Realtek ALC215 (`alcid=18`)                                                    |
| Audio controller | Intel 8086:9DC8, Cannon Point-LP cAVS 1.8 with Intel DSP and digital mic array |
| Ethernet         | Intel I219-LM (8086:15BD), IntelMausi 1.0.8                                    |
| Wi-Fi            | Intel AX200 (8086:2723)                                                        |
| Bluetooth        | Intel Bluetooth plus IntelBTPatcher stack                                      |
| Storage          | SK hynix SC311 SATA 256 GB                                                     |
| Camera           | USB UVC, VID 0x0408 / PID 0x5343                                               |

## What works

- Graphics and full Metal 3 acceleration
- Wi-Fi and Bluetooth
- Sleep and wake
- Keyboard and trackpad
- USB ports
- Speakers
- Internal digital microphone
- Internal camera
- iMessage and FaceTime
- AirDrop, confirmed with a real M1 MacBook Air

**Not tested:** HDMI output.

## EFI configuration

- OpenCore 1.0.8
- macOS Tahoe 26.7.3 (25G342)
- SMBIOS: `MacBookPro16,3`
- SIP: custom `csr-active-config=03080000` (`AMFI` and filesystem protections reduced for the root patch)
- Secure Boot, TPM, and VT-d are disabled in firmware; CFG Lock is not available

### iGPU properties

- `AAPL,ig-platform-id`: `00009B3E`
- `device-id`: `9B3E0000`
- `framebuffer-patch-enable`: enabled
- `framebuffer-stolenmem`: `00003001`
- `framebuffer-fbmem`: `00009000`
- `framebuffer-con0-enable`: enabled
- DPCD maximum-link-rate fix enabled

### Boot arguments

```text
keepsyms=1 -no_compat_check revpatch=sbvmm -tgldmiclilu -lilubetaall -ibtcompatbeta -amfipassbeta alcid=18 -igfxonln=1 -igfxmlr -igfxblr -btleadv -itlawdlcoexprobe -itlawdliface -itlawdlnativeup -itlawdlcoexrx -itlawdlcoextx -itlawdlcoexmulti -itlawdlcoexdata -itlawdlmitx -itlawdlelicit -itlawdlcaps -itlawdlsvcmerge -itlawdlawsync itlawdlintcoal=4 -itlawdlcoexbatx -itlawdlcoexpeerpause -itlawdlcoexbatrace itlawdltxqueue=4096
```

The `-itlawdl*` arguments configure ForbiddenItlwm's AWDL behavior for AirDrop.

## Kexts

| Kext                   | Version                 |
| ---------------------- | ----------------------- |
| Lilu                   | 1.7.2                   |
| VirtualSMC             | 1.3.8                   |
| SMCProcessor           | 1.3.8                   |
| SMCBatteryManager      | 1.3.8                   |
| SMCSuperIO             | 1.3.8                   |
| SMCLightSensor         | 1.3.8                   |
| WhateverGreen          | 1.7.1                   |
| AppleALC               | 1.9.8                   |
| CPUFriend              | 1.2.7                   |
| ECEnabler              | 1.0.4                   |
| RestrictEvents         | 1.1.6                   |
| RTCMemoryFixup         | 1.0.7                   |
| AMFIPass               | 1.4.1                   |
| USBToolBox             | 1.2.0                   |
| UTBMap                 | custom USB map          |
| VoodooPS2Controller    | 2.3.7                   |
| VoodooI2C              | 2.9.1                   |
| VoodooI2CHID           | 2.9.1                   |
| VoodooI2CSynaptics     | 2.9.1                   |
| VoodooGPIO             | included with VoodooI2C |
| VoodooInput            | included with VoodooI2C |
| IntelMausi             | 1.0.8                   |
| ForbiddenItlwm         | 0.5.4                   |
| IntelBluetoothFirmware | 2.5.3                   |
| IntelBTPatcher         | 2.5.3                   |
| BlueToolFixup          | 2.7.2                   |
| BTLEAdvFixup           | 0.9.1                   |
| TGLDmicJK              | 0.6.5 patched           |
| RealtekUVCFix          | 0.1.0 patched           |

## Installation notes

1. Back up the machine and prepare a separate EFI partition.
2. Copy this repository's `BOOT` and `OC` folders to the EFI partition.
3. Generate your own SMBIOS data with an OpenCore configurator or GenSMBIOS; the checked-in config does not contain a real serial or MLB.
4. Confirm that `SystemProductName` is `MacBookPro16,3`.
5. Install macOS Tahoe using the Dortania OpenCore Install Guide for a Whiskey Lake laptop.
6. Boot with the documented boot arguments.
7. Enable the necessary SIP/root-patch setup only if you understand the security tradeoffs.

## Speakers

Tahoe removed the legacy AppleHDA implementation used by older root installations. The speaker setup uses:

- AppleALC 1.9.8
- Layout ID `18` (`alcid=18`)
- An OpenCore Legacy Patcher root patch applied through MyKextInstaller

This is the only root patching needed for the build.

## Internal microphone

The internal mic is behind the Intel audio DSP rather than directly behind the ALC codec. TGLDmicEx boots the DSP firmware and injects mic samples into AppleHDA through a Lilu hook.

The patched build fixes three issues found on this machine:

1. **Mic detection:** the upstream kext matched the engine name `DevShortNameIMic`, while this layout exposes a different engine name. The patch identifies the engine with the `InternalMic` selector instead.
2. **DSP power state:** BAR4 can return HDA registers where DSP registers are expected, leaving the core-power register frozen at `0x001c003c`. The patch sets `PPCTL.GPROCEN` (bit 30) before touching the DSP, allowing the cores to power up and firmware to boot.
3. **DMA allocation after uptime:** macOS could eventually fail to find 544 KB of contiguous memory below 4 GB, causing `FAIL DMA alloc` and preventing a DSP reboot. The patch reserves and reuses its DMA buffers instead of reallocating them.

After these fixes, the mic has remained stable for several hours of normal use and through sleep/wake. Enable it with:

```text
-tgldmiclilu
```

The mic fixes are not upstream yet. The repository for the mic changes is archived upstream.

## Camera

RealtekUVCFix 0.1.0 patched by reapplying the page-in fix stopped a roughly 30-minute-after-boot camera failure. It has remained stable over long sessions, although extended-session testing is ongoing.

## AirDrop and Continuity

ForbiddenItlwm 0.5.4 provides native-style Wi-Fi, AirDrop, and Continuity support in this build. AirDrop was verified between this laptop and an M1 MacBook Air.

## Resources

- [Dortania OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/)
- [OpenCore Legacy Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher)
- [ForbiddenItlwm](https://github.com/OpenIntelWireless/Forbidden-Intel)
- [TGLDmicEx](https://github.com/qqaoshi888/TGLDmicEx)
- [labrouss/TGLDmic](https://github.com/labrouss/TGLDmic)
- [RealtekUVCFix](https://github.com/trungkiengrxer/RealtekUVCFix)
- [MyKextInstaller](https://github.com/laobamac/MyKextInstaller)

## Images

![EFI or macOS hardware screenshot](Images/Screenshot%202026-11-21%20at%2010.48.50.png)

## Credits

- qqaoshi888/TGLDmicEx and labrouss/TGLDmic
- trungkiengrxer for RealtekUVCFix
- the ForbiddenItlwm project
- Dortania
- OpenCore Legacy Patcher
