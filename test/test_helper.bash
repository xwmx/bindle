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
}
