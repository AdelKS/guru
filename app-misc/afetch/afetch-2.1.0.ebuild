# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit savedconfig

DESCRIPTION="Simple system info written in C"
HOMEPAGE="https://github.com/13-CF/afetch/"
SRC_URI="https://github.com/13-CF/afetch/archive/refs/tags/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="savedconfig"

src_prepare() {
	default
	restore_config src/config.h
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="${EPREFIX}"/usr install
	save_config src/config.h
}
