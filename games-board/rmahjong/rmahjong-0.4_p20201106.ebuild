# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit desktop python-single-r1 xdg

# Tarball from py3 port branch:
# https://github.com/spirali/rmahjong/tree/py3
# At least "Furiten", "Red fives" rules aren't implemented.
PKG_sha="7a37ade640bc24eb2cc9f0ad6c7ce26773be2856"

DESCRIPTION="Riichi Mahjong, the Japanese variant of the Chinese game Mahjong for 4 players"
HOMEPAGE="https://github.com/spirali/rmahjong"

# PNG icon is taken from Kmahjongg project (GPL-2), renamed to avoid pkgs conflicts
SRC_URI="
	https://github.com/spirali/${PN}/archive/${PKG_sha}.tar.gz -> ${P}.tar.gz
	https://github.com/KDE/kmahjongg/raw/master/icons/48-apps-kmahjongg.png -> kmahjongg_${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${PN}-${PKG_sha}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/pygame[X,opengl]
	$(python_gen_cond_dep '
		dev-python/pygame[${PYTHON_MULTI_USEDEP}]
		dev-python/pyopengl[${PYTHON_MULTI_USEDEP}]
	')
"

src_prepare(){
	default

	# Disable logging as application log into directory where user access is denied
	sed -i "/logging.basicConfig/d" "${S}/client/client.py" || die
	sed -i "/logging.basicConfig/d" "${S}/server/server.py" || die
	sed -i "/logging.info/d" "${S}/server/server.py" || die

	echo $'#!/bin/sh\ncd '"$(python_get_sitedir)/${PN}"' && ./start.sh' > "${S}/rmahjong"
}

src_compile() {
	# Build bots
	cd "${S}/bot/" && emake
}

src_test() {
	cd "${S}/server/" && python3 test.py -v
}

src_install() {
	python_moduleinto ${PN}
	python_domodule {client/,server/,start.sh}

	python_moduleinto bot
	python_domodule "bot/bot"

	python_optimize "${D}/$(python_get_sitedir)/${PN}/"{client,server}/*.py

	dobin "rmahjong"
	doicon -s 48 "${DISTDIR}/kmahjongg_${PN}.png"
	make_desktop_entry "${PN}" "RMahjong" "kmahjongg_${PN}" "Game;BoardGame;" || die "Failed making desktop entry!"
}
