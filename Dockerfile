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

# Use qemu_virt based config, but replace toolchain with prebuilt one located in: /opt/buildroot/riscv64-buildroot-linux-uclibc_sdk-buildroot.tar.gz
COPY armleo_qemu_virt_defconfig /opt/buildroot/buildroot-2021.05/configs/armleo_qemu_virt_defconfig
RUN make armleo_qemu_virt_defconfig

# Do actual build
RUN make





