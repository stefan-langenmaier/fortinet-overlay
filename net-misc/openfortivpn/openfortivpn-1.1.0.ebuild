# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

inherit eutils linux-info autotools

DESCRIPTION="openfortivpn is a compatible client with Fortinet VPNs for PPP+SSL VPN tunnel services"
HOMEPAGE="https://github.com/adrienverge/openfortivpn"

SRC_URI="https://github.com/adrienverge/openfortivpn/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL3"

SLOT="0"

KEYWORDS="~x86 ~amd86"

IUSE=""

DEPEND="net-dialup/ppp"

RDEPEND="${DEPEND}"

#S=${WORKDIR}/${P}

pkg_setup() {
	CONFIG_CHECK="PPP PPP_ASYNC"

	linux-info_pkg_setup
}

src_prepare() {
	eaclocal && eautoconf && eautomake # --add-missing
}

src_configure() {
	econf
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
