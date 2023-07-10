FROM ubuntu:latest AS builder

RUN apt update && \
  apt install -y --no-install-recommends \
    checkinstall \
    build-essential \
    gcc-multilib \
    flex \
    bison \
    lib32z1-dev && \
  dpkg --add-architecture i386
COPY . .

RUN cd /wine 2>/dev/null && \
  CFLAGS="$CFLAGS -fcommon" ./configure \
  --without-x \
  --without-alsa \
  --without-capi \
  --without-cms \
  --without-coreaudio \
  --without-cups \
  --without-curses \
  --without-dbus \
  --without-fontconfig \
  --without-freetype \
  --without-gettext \
  --without-gphoto \
  --without-glu \
  --without-gnutls \
  --without-gsm \
  --without-gstreamer \
  --without-hal \
  --without-jpeg \
  --without-ldap \
  --without-mpg123 \
  --without-netapi \
  --without-openal \
  --without-opencl \
  --without-opengl \
  --without-osmesa \
  --without-oss \
  --without-pcap \
  --without-png \
  --without-pulse \
  --without-sane \
  --without-tiff \
  --without-udev \
  --without-v4l \
  --without-xcomposite \
  --without-xcursor \
  --without-xinerama \
  --without-xinput \
  --without-xinput2 \
  --without-xml \
  --without-xrandr \
  --without-xrender \
  --without-xshape \
  --without-xshm \
  --without-xslt \
  --without-xxf86vm \
  --disable-win16 \
  --disable-largefile \
  --disable-winebrowser \
  --disable-winemenubuilder \
  --disable-winemine \
  --disable-winemsibuilder \
  --disable-wmic \
  --disable-wmplayer \
  --disable-wordpad \
  --disable-write \
  --disable-view \
  --disable-progman \
  --disable-notepad \
  --disable-urlmon \
  --enable-uxtheme \
  --disable-vbscript \
  --disable-windowscodecs \
  --disable-windowscodecsext \
  --disable-winealsa_drv \
  --disable-winecoreaudio_drv \
  --disable-wined3d \
  --disable-winegstreamer \
  --disable-quartz \
  --disable-mshtml_tlb \
  --disable-mshtml \
  --disable-msi \
  --disable-opengl32 \
  --disable-actxprxy \
  --disable-jscript \
  --disable-d3d10 \
  --disable-d3d10_1 \
  --disable-d3d10core \
  --disable-d3d11 \
  --disable-d3d8 \
  --disable-d3d9 \
  --disable-d3dcompiler_33 \
  --disable-d3dcompiler_34 \
  --disable-d3dcompiler_35 \
  --disable-d3dcompiler_36 \
  --disable-d3dcompiler_37 \
  --disable-d3dcompiler_38 \
  --disable-d3dcompiler_39 \
  --disable-d3dcompiler_40 \
  --disable-d3dcompiler_41 \
  --disable-d3dcompiler_42 \
  --disable-d3dcompiler_43 \
  --disable-d3dcompiler_46 \
  --disable-d3dcompiler_47 \
  --disable-d3dim \
  --disable-d3drm \
  --disable-d3dx10_33 \
  --disable-d3dx10_34 \
  --disable-d3dx10_35 \
  --disable-d3dx10_36 \
  --disable-d3dx10_37 \
  --disable-d3dx10_38 \
  --disable-d3dx10_39 \
  --disable-d3dx10_40 \
  --disable-d3dx10_41 \
  --disable-d3dx10_42 \
  --disable-d3dx10_43 \
  --disable-d3dx11_42 \
  --disable-d3dx11_43 \
  --disable-d3dx9_24 \
  --disable-d3dx9_25 \
  --disable-d3dx9_26 \
  --disable-d3dx9_27 \
  --disable-d3dx9_28 \
  --disable-d3dx9_29 \
  --disable-d3dx9_30 \
  --disable-d3dx9_31 \
  --disable-d3dx9_32 \
  --disable-d3dx9_33 \
  --disable-d3dx9_34 \
  --disable-d3dx9_35 \
  --disable-d3dx9_36 \
  --disable-d3dx9_37 \
  --disable-d3dx9_38 \
  --disable-d3dx9_39 \
  --disable-d3dx9_40 \
  --disable-d3dx9_41 \
  --disable-d3dx9_42 \
  --disable-d3dx9_43 \
  --disable-d3dxof \
  --enable-dsound
RUN make -j4 -C /wine && \
  mkdir -p /opt/wine /wine-build && \
  cd /wine-build 2>/dev/null && \
  checkinstall \
    --pkgname wine \
    --pkgversion 2.0.1 \
    --pkgrelease sockpatch \
    --requires lib32z1 \
    --deldesc \
    make prefix=/opt/wine -C /wine install-lib

FROM ubuntu:latest
RUN adduser d2gs
RUN --mount=type=bind,from=builder,source=/wine-build,target=/mnt \
  apt update && \
  apt install -y \
    lib32gcc-s1 \
    /mnt/wine_*.deb && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
USER d2gs
ENV PATH="/opt/wine/bin:${PATH}"
CMD wine --version
