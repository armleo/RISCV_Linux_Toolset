# syntax=docker/dockerfile:1

# Bionic is required by Buildroot
FROM ubuntu:21.04

# To force automatic decisions for apt-get
ENV DEBIAN_FRONTEND=noninteractive




# Buildroot deps
RUN dpkg --add-architecture i386
RUN apt-get -q update

RUN apt-get purge -q -y snapd lxcfs lxd ubuntu-core-launcher snap-confine
RUN apt-get -q -y install build-essential libncurses5-dev git bzr cvs mercurial subversion libc6:i386 unzip bc sed binutils gcc g++ bash patch bzip2 gzip perl tar cpio unzip rsync file wget
RUN apt-get -q -y autoremove
RUN apt-get -q -y clean
RUN apt-get -q -y install locales
RUN update-locale LC_ALL=C

RUN apt-get -q -y install qemu

# TODO: Download buildroot
RUN mkdir /opt/buildroot
WORKDIR /opt/buildroot
RUN wget -q -c http://buildroot.org/downloads/buildroot-2021.05.tar.gz
RUN tar axf buildroot-2021.05.tar.gz
WORKDIR /opt/buildroot/buildroot-2021.05

# Let's build toolchain
# Following architecture configuration are used: RV64G
# Select the appropriate Target options for your target CPU architecture
# • In the Toolchain menu, keep the default of Buildroot toolchain for Toolchain type, and configure your toolchain as desired
# • In the System configuration menu, select None as the Init system and none as /bin/sh
# • In the Target packages menu, disable BusyBox
# • In the Filesystem images menu, disable tar the root filesystem

COPY armleo_toolchain_defconfig /opt/buildroot/buildroot-2021.05/configs/armleo_toolchain_defconfig
RUN make armleo_toolchain_defconfig
RUN make sdk
RUN mv /opt/buildroot/buildroot-2021.05/output/images/riscv64-buildroot-linux-uclibc_sdk-buildroot.tar.gz /opt/buildroot/riscv64-buildroot-linux-uclibc_sdk-buildroot.tar.gz


# Use qemu_virt based config, but replace toolchain with prebuilt one located in: /opt/buildroot/riscv64-buildroot-linux-uclibc_sdk-buildroot.tar.gz
COPY armleo_qemu_virt_defconfig /opt/buildroot/buildroot-2021.05/configs/armleo_qemu_virt_defconfig
RUN make armleo_qemu_virt_defconfig

# Do actual build
RUN make





