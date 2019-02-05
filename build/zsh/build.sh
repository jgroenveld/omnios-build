#!/usr/bin/bash
#
# {{{ CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END }}}
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2019 OmniOS Community Edition (OmniOSce) Association.
# Use is subject to license terms.
#
. ../../lib/functions.sh

PROG=zsh
VER=5.7.1
VERHUMAN=$VER
PKG=shell/zsh
SUMMARY="Z shell"
DESC="The Z shell"

set_arch 64

CPPFLAGS+=" -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
CONFIGURE_OPTS+="
	--enable-cap
	--enable-dynamic
	--enable-etcdir=/etc
	--enable-function-subdirs
	--enable-ldflags=-zignore
	--enable-libs=-lnsl
	--enable-maildir-support
	--enable-multibyte
	--enable-pcre
	--with-tcsetpgrp
	--disable-gdbm
"

CONFIGURE_OPTS_WS="--enable-ldflags=\"-m64 -zignore\""

HARDLINK_TARGETS=usr/bin/zsh-$VER
SKIP_LICENCES="*"

PKGDIFF_HELPER='
    s:usr/share/zsh/[0-9.]*:usr/share/zsh/VERSION:
    s:usr/lib/amd64/zsh/[0-9.]*:usr/lib/amd64/zsh/VERSION:
'

install_zshrc() {
    mkdir -p $DESTDIR/etc
    cp $SRCDIR/files/system-zshrc $DESTDIR/etc/zshrc
    chmod 644 $DESTDIR/etc/zshrc
}

install_license() {
    iconv -f 8859-1 -t utf-8 \
        $TMPDIR/$BUILDDIR/LICENCE > $TMPDIR/$BUILDDIR/LICENSE
}

init
download_source $PROG $PROG $VER
patch_source
run_autoreconf -fi
prep_build
build
install_zshrc
install_license
run_testsuite
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:fdm=marker
