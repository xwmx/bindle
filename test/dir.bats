#!/usr/bin/env bats

load test_helper

# `bindle dir` ################################################################

@test "\`dir\` exits with status 0." {
  {
    run "${_BINDLE}" init
  }

  run "${_BINDLE}" dir
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`dir\` prints the location of \$BINDLEPATH." {
  {
    run "${_BINDLE}" init
  }

  run "${_BINDLE}" dir
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ "${output}" == "${_BINDLEPATH}" ]]
}
