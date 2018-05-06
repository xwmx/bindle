#!/usr/bin/env bats

load test_helper

@test "\`bindle\` with no arguments exits with status 0." {
  run "${_BINDLE}"
  [ "${status}" -eq 0 ]
}

@test "\`bindle\` with no arguments prints default help." {
  run "${_BINDLE}"
  _expected="\
 _____  ___  _____  _____  ____   _____
/  _  \/___\/  _  \|  _  \/  _/  /   __\\
|  _  <|   ||  |  ||  |  ||  |---|   __|
\_____/\___/\__|__/|_____/\_____/\_____/"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:4}")" == "${_expected}" ]]
}

@test "\`\$_HOME_PATH\` is configured for testing." {
  run grep "6 \${_HOME_PATH}: /tmp/bindle_test" <<< $("${_BINDLE}" --debug)
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`\$BINDLEPATH\` is configured for testing." {
  run grep "7 \${BINDLEPATH}: /tmp/bindle_test" <<< $("${_BINDLE}" --debug)
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}
