#!/usr/bin/env bats
load _test_base # for run_wrapper

: "${TMPDIR:=/tmp}"

INSTALL_BASE="${TMPDIR}/git-secret-test-install"

@test "run 'make install to tmpdir'" {
  rm -f "${INSTALL_BASE}/usr/bin/git-secret"

  cd $SECRET_PROJECT_ROOT 

  # set DESTDIR for this command and 'run' make install
  DESTDIR="${INSTALL_BASE}" run_wrapper make install

  [ -x "${INSTALL_BASE}/usr/bin/git-secret" ]

  rm -rf "${INSTALL_BASE}"
}

