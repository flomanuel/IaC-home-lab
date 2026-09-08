# One-time: Windows 11 template (manual)

Windows has no cloud image, so the template is built by hand once and cloned
by OpenTofu (`modules/windows_vm`).

1. Upload the Windows 11 ISO and the latest
   [virtio-win ISO](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio-win/)
   to the `local` storage.
2. Create a VM (suggested VMID **9100** — high, out of the way):
   - BIOS: OVMF (UEFI) + EFI disk, TPM 2.0 (both on `vm_pool`)
   - Machine: q35
   - Disk: SCSI on `vm_pool`, VirtIO SCSI single controller, e.g. 64 GB
   - Network: VirtIO on `vmbr1`, any VLAN tag (the clone overrides it)
   - Attach both ISOs (two CD drives)
3. Install Windows; load the VirtIO SCSI driver from the virtio ISO when no
   disk is found. After install, run `virtio-win-gt-x64.msi` (drivers) and
   install the **QEMU guest agent** from the same ISO.
4. Windows Update, then whatever baseline you want baked in.
5. Optional but recommended: generalize with
   `C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown`
   so clones get unique SIDs/hostnames.
6. Remove both CD drives, then right-click the VM → **Convert to template**.

Record the template VMID — it's the `template_vm_id` in the tofu definitions.
