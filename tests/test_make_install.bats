#!/usr/bin/env bats

: "${TMPDIR:=/tmp}"

INSTALL_BASE="${TMPDIR}/git-secret-test-install"

@test "install git-secret to '$TMPDIR'" {

  rm -f "${INSTALL_BASE}/usr/bin/git-secret"

  cd $SECRET_PROJECT_ROOT 

  # set DESTDIR for this command and 'run' make install
  DESTDIR="${INSTALL_BASE}" run make install

  [ -x "${INSTALL_BASE}/usr/bin/git-secret" ]
}

