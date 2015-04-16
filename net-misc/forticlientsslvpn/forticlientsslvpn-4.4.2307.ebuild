# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

#this ebuild was inspired by https://aur.archlinux.org/packages/forticlientsslvpn/
DESCRIPTION="Fortinet is a closed-source vpn client"
HOMEPAGE="http://www.fortinet.com/"
SRC_URI="forticlientsslvpn_linux_${PV}.tar.gz"

LICENSE="fortinet"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE=""

RESTRICT="fetch strip"

RDEPEND="${DEPEND}"

S=${WORKDIR}/forticlientsslvpn

pkg_nofetch() {
    einfo "Please download"
    einfo "  - forticlientsslvpn_linux_${PV}.tar.gz"
    einfo "And place the files in  ${DISTDIR}"
}

src_configure() {
    if use x86 ; then
        S="${S}/32bit"
    elif use amd64 ; then
        S="${S}/64bit"
    else
        die "NOT A VALID ARCHITECTURE"
    fi

    #patching
    cd "${S}/helper"
    epatch "${FILESDIR}/FixNoDeviceError.patch"
    :;
}

src_compile() { :; }

src_install() {
    dodir /opt/fortinet/${PN}/icons
    dodir /usr/bin
    dodir /usr/share/applications
    dodir /usr/share/licenses/${PN}

    cp -rp "${S}"/* ${D}/opt/fortinet/${PN}

#fowners/fperms
    chmod -R 777 ${D}/opt/fortinet/
    chmod 555 ${D}/opt/fortinet/${PN}/helper

    cp "${FILESDIR}/${PN}.png" "${D}/opt/fortinet/${PN}/icons/"
    #install desktop file with gnome stuff
    cp "${FILESDIR}/${PN}.desktop" "${D}/usr/share/applications/"

    cp "$S"/helper/License.txt ${D}/usr/share/licenses/${PN}/
#    touch ${D}/opt/fortinet/${PN}/helper/.nolicense

    cp "${FILESDIR}/${PN}.sh" "${D}/usr/bin/${PN}"
    cp "${FILESDIR}/${PN}_cli.sh" "${D}/usr/bin/${PN}_cli"
    chmod 755 "${D}/usr/bin/${PN}"
    chmod 755 "${D}/usr/bin/${PN}_cli"

#    echo "PATH=\"/opt/fortinet/${PN}\"" > "${T}/90${PN}" || die
#    doenvd "${T}/90${PN}" || die "failed to install env.d file"
}

pkg_postinst() {
        einfo "Before you can use forticlientsslvpn you have to execute /opt/fortinet/forticlientsslvpn/helper/setup.linux.sh"
        einfo "A future version should include this script :)"
}
