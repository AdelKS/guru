# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils virtualx xdg

DESCRIPTION="Practical and minimal image viewer"
HOMEPAGE="https://github.com/jurplel/qView https://interversehq.com/qview"
SRC_URI="https://github.com/jurplel/qView/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/qView-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-qt/qtgui:5"
RDEPEND="${DEPEND}"

src_configure() {
	# https://github.com/jurplel/qView/issues/395
	if tc-is-clang && has_version "sys-devel/clang:$(clang-major-version)[default-libcxx]" || is-flagq -stdlib=libc++; then
		append-cxxflags -stdlib=libstdc++
		append-ldflags -stdlib=libstdc++
	fi

	eqmake5 PREFIX=/usr qView.pro
}

src_test() {
	cd tests || die
	eqmake5 && emake
	virtx ./tests
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
