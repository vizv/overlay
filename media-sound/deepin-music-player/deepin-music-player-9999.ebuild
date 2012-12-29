# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="4"

inherit git-2

EGIT_REPO_URI="git://github.com/linuxdeepin/deepin-music-player.git"

DESCRIPTION="Deepin Music Player."
HOMEPAGE="https://github.com/linuxdeepin/deepin-music-player"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/deepin-ui-20120928
	dev-python/gst-python
	media-libs/gst-plugins-bad
	media-libs/gst-plugins-ugly
	sci-libs/scipy
	media-plugins/gst-plugins-ffmpeg
	dev-python/python-xlib
	media-libs/mutagen
	dev-python/chardet
	dev-python/dbus-python
	dev-python/pyquery"
DEPEND="${RDEPEND}"

src_prepare() {
	chmod u+x tools/*.py || die
	cd tools
	./update_po.py && ./generate_mo.py || die "failed to update Translate"
	cd ..
	rm -rf debian || die
	rm locale/*.po* 
}

src_install() {
	dodoc AUTHORS ChangeLog 

	insinto "/usr/share/"
	doins -r ${S}/locale

	insinto "/usr/share/${PN}"
	doins -r  ${S}/src ${S}/app_theme ${S}/skin ${S}/wizard
	fperms 0755 -R /usr/share/${PN}/src/

	dosym /usr/share/${PN}/src/main.py /usr/bin/${PN}

	mkdir -p ${D}/usr/share/icons/hicolor/128x128/apps
	wget https://gitcafe.com/zhtengw/SlackBuilds \
		/raw/master/deepin-music-player/deepin-music-player.png \
		-O ${D}/usr/share/icons/hicolor/128x128/apps/${PN}.png

	mkdir -p ${D}/usr/share/applications
	cat > ${D}/usr/share/applications/${PN}.desktop <<EOF
[Desktop Entry]
Name=Deepin Music Player
Name[zh_CN]=深度音乐播放器
Comment=Play your music collection
Comment[zh_CN]=为您播放本地及网络音频流
GenericName=Music Player
Exec=deepin-music-player %F
Icon=deepin-music-player
Type=Application
Categories=AudioVideo;Player;GTK;
MimeType=audio/musepack;application/musepack;application/x-ape;audio/ape;audio/x-ape;audio/x-musepack;application/x-musepack;audio/x-mp3;application/x-id3;audio/mpeg;audio/x-mpeg;audio/x-mpeg-3;audio/mpeg3;audio/mp3;audio/x-m4a;audio/mpc;audio/x-mpc;audio/mp;audio/x-mp;application/ogg;application/x-ogg;audio/vorbis;audio/x-vorbis;audio/ogg;audio/x-ogg;audio/x-flac;application/x-flac;audio/flac;
EOF
}
