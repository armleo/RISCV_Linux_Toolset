## RISC-V Linux Build toolset
This is Dockerfile that is used to build DockerHub image `armleo/riscv_linux_toolset` for VSD workshop.

# Running under qemu
Enter docker using following command:
```bash
docker run --rm -it armleo/riscv_linux_toolset:latest
```

Then enter following:
```bash
qemu-system-riscv64 -M virt -bios output/images/fw_payload.elf -kernel output/images/Image -drive file=output/images/rootfs.ext2,format=raw,id=hd0 -device virtio-blk-device,drive=hd0 -netdev user,id=net0 -device virtio-net-device,netdev=net0 -append "root=/dev/vda rw console=ttyS0" -nographic
```

To leave:
1. press Ctrl-A
2. release both
3. press x