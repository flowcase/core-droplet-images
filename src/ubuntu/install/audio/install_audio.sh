#!/usr/bin/env bash
### every exit != 0 fails the script
set -ex

VERSION="1.0.0"
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')
echo "Install Audio Requirements"
if [[ "${DISTRO}" == @(centos|oracle7) ]] ; then
  yum install -y curl git
  yum install -y epel-release
  yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
  yum install -y ffmpeg pulseaudio-utils
  sed -i '/Bluetooth/,+7d' /etc/pulse/default.pa
elif [ "${DISTRO}" == "oracle8" ]; then
  dnf install -y curl git
  dnf config-manager --set-enabled ol8_codeready_builder
  dnf localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
  dnf install -y ffmpeg pulseaudio-utils
elif [ "${DISTRO}" == "oracle9" ]; then
  dnf install -y curl git
  dnf config-manager --set-enabled ol9_codeready_builder
  dnf localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm
  dnf install -y --allowerasing ffmpeg pulseaudio-utils pulseaudio
elif [[ "${DISTRO}" == @(rockylinux9|almalinux9) ]]; then 
  dnf localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm
  dnf install -y --allowerasing ffmpeg pulseaudio-utils pulseaudio
elif [[ "${DISTRO}" == @(rockylinux8|almalinux8) ]]; then
  dnf localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
  dnf install -y --allowerasing ffmpeg pulseaudio-utils pulseaudio
elif [ "${DISTRO}" == "fedora37" ]; then
  dnf install -y curl git
  dnf localinstall -y --nogpgcheck https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-37.noarch.rpm
  dnf install -y --allowerasing ffmpeg pulseaudio pulseaudio-utils
elif [ "${DISTRO}" == "fedora38" ]; then
  dnf install -y curl git
  dnf localinstall -y --nogpgcheck https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-38.noarch.rpm
  dnf install -y --allowerasing ffmpeg pulseaudio pulseaudio-utils
elif [ "${DISTRO}" == "fedora39" ]; then
  dnf install -y curl git
  dnf localinstall -y --nogpgcheck https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-39.noarch.rpm
  dnf install -y --allowerasing ffmpeg pulseaudio pulseaudio-utils
elif [ "${DISTRO}" == "fedora40" ]; then
  dnf install -y curl git
  dnf localinstall -y --nogpgcheck https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-40.noarch.rpm
  dnf install -y --allowerasing ffmpeg pulseaudio pulseaudio-utils
elif [ "${DISTRO}" == "opensuse" ]; then
  zypper install -ny curl git
  zypper install -yn ffmpeg pulseaudio-utils
elif [ "${DISTRO}" == "alpine" ]; then
  if grep -q v3.19 /etc/os-release || grep -q v3.20 /etc/os-release; then
    apk add --no-cache \
      ffmpeg \
      ffplay \
      git \
      pulseaudio \
      pulseaudio-utils
  else
    apk add --no-cache \
      ffmpeg \
      git \
      pulseaudio \
      pulseaudio-utils 
  fi
else
  apt-get update
  apt-get install -y \
    curl \
    ffmpeg \
    git \
    pulseaudio \
    pulseaudio-utils
fi

mkdir -p /var/run/pulse

cd $STARTUPDIR
mkdir jsmpeg
wget -q https://github.com/flowcase/flowcase_audio_out/releases/download/v$VERSION/flowcase_audio_out_linux_$ARCH.tar.gz -O /tmp/flowcase_audio_out_linux.tar.gz
tar -xvf /tmp/flowcase_audio_out_linux.tar.gz -C $STARTUPDIR/jsmpeg
chmod +x $STARTUPDIR/jsmpeg/flowcase_audio_out_linux
rm /tmp/flowcase_audio_out_linux.tar.gz