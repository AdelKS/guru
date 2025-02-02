# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Shows information about apps for C Suite"
HOMEPAGE="https://gitlab.com/cubocore/coreapps/coreuniverse"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/cubocore/coreapps/${PN}.git"
else
	SRC_URI="https://gitlab.com/cubocore/coreapps/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-v${PV}"
fi

RESTRICT="test"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	gui-libs/libcprime
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	default

	sed -i 's/CSuite/X-CSuite/' "${PN}.desktop" || die
}

src_configure() {
	eqmake5
}

src_compile() {
	emake
}

src_install() {
	einstalldocs

	emake INSTALL_ROOT="${D}" install
}
