# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit R-packages-guru

MY_P="${PN}_$(ver_rs 3 -)"

DESCRIPTION='Boost C++ Header Files'
HOMEPAGE="
	https://github.com/eddelbuettel/bh
	https://cran.r-project.org/package=BH
"
SRC_URI="http://cran.r-project.org/src/contrib/${MY_P}.tar.gz"
LICENSE='Boost-1.0'
KEYWORDS="~amd64"
DEPEND="~dev-libs/boost-1.75.0"
RDEPEND="${DEPEND}"

src_prepare() {
	# Do not bundle boost
	rm -rf inst/include/boost || die
	default
}
