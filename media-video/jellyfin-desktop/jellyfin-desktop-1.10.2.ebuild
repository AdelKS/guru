# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="tk"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

SHADER_PV="1.1.0"
WEB_PV="1.7.0"

DESCRIPTION="MPV-based desktop and cast client for Jellyfin"
HOMEPAGE="https://github.com/jellyfin/jellyfin-desktop"
SRC_URI="
	https://github.com/jellyfin/jellyfin-desktop/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/iwalton3/default-shader-pack/archive/v${SHADER_PV}.tar.gz -> jellyfin-mpv-shim-shader-pack-${SHADER_PV}.tar.gz
	https://github.com/iwalton3/jellyfin-web/releases/download/v${WEB_PV}-4/dist.zip -> jellyfin-web-${WEB_PV}.zip
"

LICENSE="LGPL-3+ MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/python-mpv[${PYTHON_USEDEP}]
		>=dev-python/jellyfin-apiclient-python-1.7.2[${PYTHON_USEDEP}]
		dev-python/python-mpv-jsonipc[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	${DEPEND}
	dev-libs/libappindicator:3=
	$(python_gen_cond_dep '
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pystray[${PYTHON_USEDEP}]
		>=dev-python/pywebview-3.3.1[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
	')
"
BDEPEND="app-arch/unzip"

src_install() {
	distutils-r1_src_install
	python_moduleinto "jellyfin_mpv_shim/webclient_view/webclient" # jellyfin-web dist
	python_domodule -r "${WORKDIR}"/dist/*
	python_moduleinto "jellyfin_mpv_shim/default_shader_pack" # mpv shaders
	python_domodule -r "${WORKDIR}"/default-shader-pack-${SHADER_PV}/*
}
