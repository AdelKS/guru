# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"
MY_P="${MY_PN}-${PV}"
BASE_URI="https://github.com/cdr/${MY_PN}/releases/download/v${PV}/${MY_P}-linux"

inherit systemd

DESCRIPTION="VS Code in the browser (binary version with unbundled node and ripgrep)"
HOMEPAGE="https://coder.com/"
SRC_URI="
	amd64? ( ${BASE_URI}-amd64.tar.gz )
	arm64? ( ${BASE_URI}-arm64.tar.gz )
"

RESTRICT="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE="gnome-keyring"

# In case we ever make a non-"-binary" pkg
DEPEND="
	!www-apps/code-server
"
RDEPEND="
	${DEPEND}
	>=net-libs/nodejs-12.16.1:0/12[ssl]
	sys-apps/ripgrep
	gnome-keyring? (
		app-crypt/libsecret
	)
"

S="${WORKDIR}/${MY_P}-linux-${ARCH}"

PATCHES=(
	"${FILESDIR}/${PN}-node.patch"
)

DOCS=( README.md ThirdPartyNotices.txt )

src_prepare() {
	default

	# We remove as much precompiled code as we can,
	# node modules not written in JS cannot be removed
	# thus "-bin".

	# use system node
	rm ./node ./lib/node \
		|| die "failed to remove bundled nodejs"

	# remove bundled ripgrep binary
	rm ./lib/vscode/node_modules/vscode-ripgrep/bin/rg \
		|| die "failed to remove bundled ripgrep"

	# not needed
	rm ./code-server || die
	rm ./postinstall.sh || die

	# already in /usr/portage/licenses/MIT
	rm ./LICENSE.txt || die

	if ! use gnome-keyring; then
		rm -r ./lib/vscode/node_modules/keytar \
			|| die "failed to remove bundled keytar"
	fi
}

src_install() {
	einstalldocs

	insinto "/usr/lib/${MY_PN}"
	doins -r .
	fperms +x "/usr/lib/${MY_PN}/bin/${MY_PN}"
	dosym "../../usr/lib/${MY_PN}/bin/${MY_PN}" "${EPREFIX}/usr/bin/${MY_PN}"

	dosym "../../../../../../../../usr/bin/rg" "${EPREFIX}/usr/lib/${MY_PN}/lib/vscode/node_modules/vscode-ripgrep/bin/rg"

	systemd_dounit "${FILESDIR}/${MY_PN}.service"
}

pkg_postinst() {
	elog "When using code-server systemd service run it as a user"
	elog "For example: 'systemctl --user enable --now code-server'"
}
