# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="GUI display configurator for wlroots compositors"
HOMEPAGE="https://cyclopsian.github.io/wdisplays https://github.com/cyclopsian/wdisplays"

if [[ "${PV}" == 9999 ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyclopsian/wdisplays.git"
else
	SRC_URI="https://github.com/cyclopsian/wdisplays/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

RDEPEND="
	dev-libs/glib
	media-libs/libepoxy
	x11-libs/gtk+:3[wayland]
	x11-libs/cairo
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
"

LICENSE="GPL-3+"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-1.0-pull20.patch" )
