#!/usr/bin/env bats

load test_helper

@test "\`bindle\` with no arguments exits with status 0." {
  run "$_BINDLE"
  [ "$status" -eq 0 ]
}

@test "\`bindle\` with no arguments prints default help." {
  run "$_BINDLE"
  _expected="\
 _____  ___  _____  _____  ____   _____
/  _  \/___\/  _  \|  _  \/  _/  /   __\\
|  _  <|   ||  |  ||  |  ||  |---|   __|
\_____/\___/\__|__/|_____/\_____/\_____/"
  [[ "$(IFS=$'\n'; echo "${lines[*]:0:4}")" == "$_expected" ]]
}
