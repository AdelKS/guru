# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="virtual machine designed for extremely compact low-level audiovisual programs"
HOMEPAGE="http://viznut.fi/ibniz/"
SRC_URI="http://viznut.fi/ibniz/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/libsdl[X]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e "s/gcc/$(tc-getCC)/" \
		-e "s/FLAGS=/FLAGS=${CFLAGS} /" \
		-e "s/-s //" \
		-i Makefile
}

src_install() {
	dobin ibniz
}
