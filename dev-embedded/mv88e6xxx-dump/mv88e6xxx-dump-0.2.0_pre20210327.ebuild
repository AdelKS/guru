# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools libtool

MY_COMMIT="25fa4d07d7a5551fee6d8d7ad128cdffd50532c8"

DESCRIPTION="Dump information about Marvell mv88e6xxx Ethernet switches"
HOMEPAGE="https://github.com/lunn/mv88e6xxx_dump"
SRC_URI="https://github.com/lunn/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"

DEPEND="net-libs/libmnl:="

S="${WORKDIR}/mv88e6xxx_dump-${MY_COMMIT}"

src_prepare() {
	default
	eautoreconf
}
