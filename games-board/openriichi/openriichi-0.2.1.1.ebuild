# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop meson vala xdg

Engine_sha="e495846970a1b38d00c81a3f74568030f976ed31"
MY_PN="OpenRiichi"

DESCRIPTION="OpenRiichi is an open source Japanese Mahjong client"
HOMEPAGE="https://github.com/FluffyStuff/${MY_PN}"
SRC_URI="
	https://github.com/FluffyStuff/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/FluffyStuff/Engine/archive/${Engine_sha}.tar.gz -> ${P}-Engine.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	dev-libs/libgee:0.8
	media-libs/glew:0
	media-libs/libsdl2[haptic,joystick,opengl,sound,threads,video]
	media-libs/sdl2-image[jpeg,png,tiff,webp]
	media-libs/sdl2-mixer
	x11-libs/gtk+:3
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	mv -T "${WORKDIR}/Engine-${Engine_sha}" "${S}/Engine" || die

	vala_src_prepare
}

src_install() {
	meson_src_install

	newicon -s 64 "bin/Data/Icon.png" "${MY_PN}.png"
	make_desktop_entry "${MY_PN}" "${MY_PN}" "${MY_PN}" "Game;BoardGame" || die "Failed making desktop entry!"
}
