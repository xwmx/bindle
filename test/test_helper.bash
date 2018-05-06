###############################################################################
# test_helper.bash
#
# Test helper for Bats: Bash Automated Testing System.
#
# https://github.com/sstephenson/bats
###############################################################################

setup() {
  # `$_BINDLE`
  #
  # The location of the `bindle` script being tested.
  export _BINDLE="${BATS_TEST_DIRNAME}/../bindle"

  export _BINDLE_TMP_PATH
  _BINDLE_TMP_PATH="$(mktemp -d /tmp/bindle_test.XXXXXX)" || exit 1

  echo "1" > "${_BINDLE_TMP_PATH}/.one"
  echo "2" > "${_BINDLE_TMP_PATH}/.two"
  echo "3" > "${_BINDLE_TMP_PATH}/.three"

  export _HOME_PATH="${_BINDLE_TMP_PATH}"
  export _BINDLEPATH="${_HOME_PATH}/.bindle"
}

teardown() {
  if [[ -n "${_BINDLE_TMP_PATH}" ]] &&
     [[ -e "${_BINDLE_TMP_PATH}" ]] &&
     [[ "${_BINDLE_TMP_PATH}" =~ ^/tmp/bindle_test ]]
  then
    rm -r "${_BINDLE_TMP_PATH}"
  fi
}

###############################################################################
# Helpers
###############################################################################

# _compare()
#
# Usage:
#   _compare <expected> <actual>
#
# Description:
#   Compare the content of a variable against an expected value. When used
#   within a `@test` block the output is only displayed when the test fails.
_compare() {
  local _expected="${1:-}"
  local _actual="${2:-}"
  printf "expected:\\n%s\\n" "${_expected}"
  printf "actual:\\n%s\\n" "${_actual}"
}
