#!/usr/bin/env bats

: "${TMPDIR:=/tmp}"

INSTALL_BASE="${TMPDIR}/git-secret-test-install"

@test "install git-secret to '$INSTALL_BASE'" {

  rm -f "${INSTALL_BASE}/usr/bin/git-secret"

  cd $SECRET_PROJECT_ROOT && DESTDIR="${INSTALL_BASE}" make install

  [ -x "${INSTALL_BASE}/usr/bin/git-secret" ]

  rm -rf "${INSTALL_BASE}"
}

