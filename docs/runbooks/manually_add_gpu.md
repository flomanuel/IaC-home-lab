# Manually add a GPU to a VM (that uses a cloud image)

## 1. Add gpu via pcie passthrough

See OpenTofu files.

## 2. add OS support for GPUs

By default, cloud images do not support GPUs.

1. Enable non-free-firmware

```bash
grep Components /etc/apt/sources.list.d/debian.sources
```

2. Install the generic kernel and the firmware

```bash
sudo apt update
sudo apt install linux-image-amd64 firmware-intel-graphics
```

3. Remove the cloud kernel

Do this before rebooting.Otherwise, it would keep booting the cloud kernel.

```bash
sudo apt purge linux-image-cloud-amd64 linux-image-6.12.107+deb13-cloud-amd64
```

apt will warn that you're removing the running kernel and ask whether to abort. Answer No. The running kernel stays in memory until the reboot, and update-grub runs automatically.

4. Reboot and verify

```bash
sudo reboot
# after reboot:
uname -r                      # should end in -amd64 without "cloud"
lspci -k -s 01:00.0           # "Kernel driver in use: i915"
ls -l /dev/dri/by-path/       # pci-0000:01:00.0-render -> ../renderD128
```
