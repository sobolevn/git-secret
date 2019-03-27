#!/usr/bin/env bats


INSTALL_BASE="/tmp/git-secret-test-install"

@test "install git-secret to '$INSTALL_BASE'" {

  rm -f "${INSTALL_BASE}/usr/bin/git-secret"

  cd $SECRET_PROJECT_ROOT && DESTDIR="${INSTALL_BASE}" make install

  [ -x "${INSTALL_BASE}/usr/bin/git-secret" ]
}

