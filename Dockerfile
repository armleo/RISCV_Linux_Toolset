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

# Install QEMU for risc-v
RUN apt-get -y install qemu-system-misc

# Yocto
WORKDIR /opt/
RUN apt-get -y install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm python3-subunit mesa-common-dev

RUN git clone git://git.yoctoproject.org/poky

WORKDIR /opt/poky

RUN git checkout -t origin/hardknott -b my-hardknott

# Disable sanity check, to disable root check

COPY sanity.conf /opt/poky/meta/conf/sanity.conf

# Sets the MACHINE to qemuriscv64
COPY local.conf /opt/poky/build/conf/local.conf

RUN source oe-init-build-env

RUN bitbake core-image-minimal






