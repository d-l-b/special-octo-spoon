FROM ubuntu:latest AS builder

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	build-essential \
  gcc-multilib flex bison lib32z1-dev && \
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
	--disable-largefile
RUN make -C /wine && \
	mkdir -p /opt/wine && \
	make prefix=/opt/wine -C wine install

FROM ubuntu:latest
RUN adduser d2gs
RUN mkdir -p /opt/wine
WORKDIR /opt/wine
COPY --from=builder /opt/wine/. ./
USER d2gs
ENV PATH="/opt/wine/bin:${PATH}"
CMD wine --version
