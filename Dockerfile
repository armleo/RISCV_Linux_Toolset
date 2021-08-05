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

COPY qemu_opensbi_uboot_payload_defconfig /opt/buildroot/buildroot-2021.05/configs/qemu_opensbi_uboot_payload_defconfig

# Set configuration
RUN make qemu_opensbi_uboot_payload_defconfig

# Do actual build
RUN make

RUN apt-get install qemu-system-misc
