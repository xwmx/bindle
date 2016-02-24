#!/usr/bin/env bats

load test_helper

@test "\`bindle version\` returns with 0 status." {
  run "${_BINDLE}" --version
  [[ "${status}" -eq 0 ]]
}

@test "\`bindle version\` prints a version number." {
  run "${_BINDLE}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '\d\+\.\d\+\.\d\+'
}

@test "\`bindle --version\` returns with 0 status." {
  run "${_BINDLE}" --version
  [[ "${status}" -eq 0 ]]
}

@test "\`bindle --version\` prints a version number." {
  run "${_BINDLE}" --version
  printf "'%s'" "${output}"
  echo "${output}" | grep -q '\d\+\.\d\+\.\d\+'
}
