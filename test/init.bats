#!/usr/bin/env bats

load test_helper

# `bindle init` ###############################################################

@test "\`init\` exits with status 0." {
  run "${_BINDLE}" init
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${status} -eq 0 ]]
}

@test "\`init\` exits with prints init information." {
  run "${_BINDLE}" init
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ ${lines[0]:-} =~ "Initialized empty Git repository in" ]]
  [[ ${lines[0]:-} =~ "${_BINDLE_TMP_PATH}" ]]
}

@test "\`init\` creates files and directories." {
  run "${_BINDLE}" init
  printf "\${status}: %s\\n" "${status}"
  printf "\${output}: '%s'\\n" "${output}"
  [[ -d "${_BINDLEPATH}"                  ]]

  [[ -d "${_BINDLEPATH}/bin"              ]]
  [[ -e "${_BINDLEPATH}/bin/.gitkeep"     ]]

  [[ -d "${_BINDLEPATH}/home"             ]]

  [[ -d "${_BINDLEPATH}/local"            ]]
  [[ -e "${_BINDLEPATH}/local/.gitkeep"   ]]

  [[ -d "${_BINDLEPATH}/scripts"                    ]]
  [[ -d "${_BINDLEPATH}/scripts/bootstrap"          ]]
  [[ -e "${_BINDLEPATH}/scripts/bootstrap/.gitkeep" ]]

  [[ -d "${_BINDLEPATH}/scripts/install"            ]]
  [[ -e "${_BINDLEPATH}/scripts/install/.gitkeep"   ]]

  [[ -d "${_BINDLEPATH}/scripts/configure"          ]]
  [[ -e "${_BINDLEPATH}/scripts/configure/.gitkeep" ]]

  [[ -d "${_BINDLEPATH}/scripts/customize"          ]]
  [[ -e "${_BINDLEPATH}/scripts/customize/.gitkeep" ]]
}
