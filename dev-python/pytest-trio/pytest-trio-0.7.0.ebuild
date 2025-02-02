# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=bdepend
DOCS_BUILDER="sphinx"
DOCS_DIR="${S}/docs/source"
DOCS_DEPEND="
	>=dev-python/attrs-17.4.0
	>=dev-python/sphinx-1.6.1
	dev-python/sphinx_rtd_theme
	dev-python/sphinxcontrib-trio
"

inherit distutils-r1 docs

DESCRIPTION="This is a pytest plugin to help you test projects that use Trio"
HOMEPAGE="
	https://github.com/python-trio/pytest-trio
	https://pypi.org/project/pytest-trio
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#too many errors
RESTRICT="test"

RDEPEND="
	>=dev-python/async_generator-1.9[${PYTHON_USEDEP}]
	dev-python/outcome[${PYTHON_USEDEP}]
	>=dev-python/trio-0.15[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-python/hypothesis-3.64[${PYTHON_USEDEP}]
		<dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	# has to be run in source dir
	#even upstream doesn't know how to run their tests
	#https://github.com/python-trio/pytest-trio/issues/84
	#"Our CI is still passing AFAIK"
	PYTHONPATH="${S}"
	cd "${S}" || die
	pytest -vv --pyargs pytest_trio || die "Tests fail with ${EPYTHON}"
}
