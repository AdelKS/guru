# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

COMMIT="ff86c6023758590a54fca9f48f5c16d2263ba31d"

inherit distutils-r1 linux-info

DESCRIPTION="Python library for async concurrency and I/O"
HOMEPAGE="
	https://github.com/python-trio/trio
	https://pypi.org/project/trio
"
SRC_URI="https://github.com/python-trio/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/async_generator[${PYTHON_USEDEP}]
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/outcome[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/astor-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/immutables-0.6[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		>=dev-python/jedi-0.17.0[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		dev-python/yapf[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${PN}-${COMMIT}"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source \
					">=dev-python/immutables-0.6" \
					dev-python/sphinxcontrib-trio \
					dev-python/sphinx_rtd_theme \
					dev-python/towncrier

python_prepare_all() {
	# Disable tests require IPv6
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		sed -i  -e "/for family in/s/, AF_INET6//" \
			-e "/test_getaddrinfo/i@pytest.mark.skip(reason='no IPv6')" \
			trio/tests/test_socket.py || die "sed failed for test_socket.py"
	fi

	# these tests require internet access
	rm trio/tests/test_ssl.py || die
	rm trio/tests/test_highlevel_ssl_helpers.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# tests fail if package is already installed without this
	PYTHONPATH="${S}"
	cd "${S}" || die
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
