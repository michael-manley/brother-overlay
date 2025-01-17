# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm

DESCRIPTION="Brother printer driver for HL-L3270CDW"

HOMEPAGE="http://support.brother.com"

SRC_URI="https://download.brother.com/welcome/dlf103945/hll3270cdwpdrv-1.0.2-0.i386.rpm"

LICENSE="brother-eula"

SLOT="0"

KEYWORDS="amd64"

IUSE=""

RESTRICT="mirror strip"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() {
	rpm_unpack ${A}
}

src_install() {
	has_multilib_profile && ABI=x86

	dosbin "${WORKDIR}/usr/bin/brprintconf_hll3270cdw"

	cp -r usr "${D}" || die
	cp -r opt "${D}" || die

	mkdir -p "${D}/usr/libexec/cups/filter" || die
	( cd "${D}/usr/libexec/cups/filter/" && ln -s ../../../../opt/brother/Printers/hll3270cdw/lpd/filter_hll3270cdw brother_lpdwrapper_hll3270cdw ) || die
	( cd "${D}/usr/libexec/cups/filter/" && sed -i 's/my $PRINTER = $0/my $PRINTER = Cwd::realpath ($0)/' ../../../../opt/brother/Printers/hll3270cdw/lpd/filter_hll3270cdw ) || die
	
	mkdir -p "${D}/usr/share/cups/model" || die
	( cd "${D}/usr/share/cups/model" && ln -s ../../../../opt/brother/Printers/hll3270cdw/cupswrapper/brother_hll3270cdw_printer_en.ppd ) || die
}
