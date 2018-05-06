#!/usr/bin/env bats

load test_helper

# `bindle list` ###############################################################

@test "\`list\` exits with status 0." {
  {
    run "${_BINDLE}" init
  }

  run "${_BINDLE}" list
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}


@test "\`list\` prints list of files." {
  {
    run "${_BINDLE}" init
  }

  run "${_BINDLE}" list
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
  📂  .bindle
  ⚙️  .one
  ⚙️  .three
  ⚙️  .two"
  _compare "'${_expected}'" "'${output}'"
  [[ "${output}" == "${_expected}" ]]
}

@test "\`list <query>\` prints list of files matching <query>." {
  {
    run "${_BINDLE}" init
  }

  run "${_BINDLE}" list "three"
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
  ⚙️  .three"
  _compare "'${_expected}'" "'${output}'"
  [[ ${status} -eq 0 ]]
  [[ "${output}" == "${_expected}" ]]
}

@test "\`list tracked\` prints list of files being tracked." {
  {
    run "${_BINDLE}" init
  }

  run "${_BINDLE}" list tracked
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected=""
  _compare "'${_expected}'" "'${output}'"
  [[ ${status} -eq 0 ]]
  [[ "${output}" == "${_expected}" ]]
}

@test "\`list untracked\` prints list of files not being tracked." {
  {
    run "${_BINDLE}" init
  }

  run "${_BINDLE}" list untracked
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  _expected="\
  📂  .bindle
  ⚙️  .one
  ⚙️  .three
  ⚙️  .two"
  _compare "'${_expected}'" "'${output}'"
  [[ ${status} -eq 0 ]]
  [[ "${output}" == "${_expected}" ]]
}
