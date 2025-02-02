# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple drag-and-drop source/sink for X and Wayland"
HOMEPAGE="https://github.com/mwh/dragon"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/mwh/dragon.git"
	inherit git-r3
else
	SRC_URI="https://github.com/mwh/dragon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND=">=x11-libs/gtk+-3"
RDEPEND="${DEPEND}"

src_install() {
	emake PREFIX="${D}/usr/bin" install
	dodoc README
}
