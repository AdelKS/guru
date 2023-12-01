# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="OBS® Studio plugin which adds many new effects."
HOMEPAGE="https://github.com/Xaymar/obs-StreamFX"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Xaymar/obs-StreamFX.git"
else
	SRC_URI="https://github.com/Xaymar/obs-StreamFX/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
RDEPEND="
	media-video/obs-studio
"

S="${WORKDIR}/obs-StreamFX-${PV}"

src_unpack() {
	default

	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	fi
}

src_configure() {

	local mycmakeargs+=(
		-DENABLE_UPDATER=FALSE
	)

	cmake_src_configure
}
