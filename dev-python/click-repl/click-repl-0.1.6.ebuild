# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Subcommand REPL for click apps"
HOMEPAGE="
	https://github.com/click-contrib/click-repl
	https://pypi.org/project/click-repl
"
SRC_URI="https://github.com/click-contrib/click-repl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
DEPEND="
	dev-python/click
	dev-python/prompt_toolkit
	dev-python/six
"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest
