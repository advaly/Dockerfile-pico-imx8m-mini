FROM debian:bullseye
WORKDIR /root

RUN apt-get update
RUN apt-get install -y wget bzip2 xz-utils make gcc flex bison u-boot-tools git vim kmod libssl-dev bc

# Install cross toolchain from Linaro
RUN wget "https://releases.linaro.org/components/toolchain/binaries/6.4-2017.11/aarch64-linux-gnu/gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz"
RUN tar xvf gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz -C /opt/
RUN echo 'PATH=$PATH:/opt/gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu/bin' >> ~/.bashrc
RUN echo 'ARCH=arm64' >> ~/.bashrc
RUN echo 'CROSS_COMPILE=/opt/gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-' >> ~/.bashrc
ENV PATH $PATH:/opt/gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu/bin
ENV ARCH arm64
ENV CROSS_COMPILE /opt/gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-

# Build Linux kernel for PICO-IMX8M-MINI
RUN git clone https://github.com/TechNexion/linux-tn-imx.git --depth 1
WORKDIR /root/linux-tn-imx
RUN make tn_imx8_defconfig
RUN make -j $(nproc)
