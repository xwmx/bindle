#!/usr/bin/env bats

load test_helper

_HELP_HEADER="\
 _____  ___  _____  _____  ____   _____
/  _  \/___\/  _  \|  _  \/  _/  /   __\\
|  _  <|   ||  |  ||  |  ||  |---|   __|
\_____/\___/\__|__/|_____/\_____/\_____/"
export _HELP_HEADER

@test "\`help\` with no arguments exits with status 0." {
  run "$_BINDLE" help
  [ "$status" -eq 0 ]
}

@test "\`help\` with no arguments prints default help." {
  run "$_BINDLE" help
  printf "expected:\n'%s'\n" "${_HELP_HEADER}"
  printf "actual:\n'%s'\n" "$(IFS=$'\n'; echo "${lines[*]:0:4}")"
  [[ $(IFS=$'\n'; echo "${lines[*]:0:4}") == "$_HELP_HEADER" ]]
}

@test "\`bindle -h\` prints default help." {
  run "$_BINDLE" -h
  [[ $(IFS=$'\n'; echo "${lines[*]:0:4}") == "$_HELP_HEADER" ]]
}

@test "\`bindle --help\` prints default help." {
  run "$_BINDLE" --help
  [[ $(IFS=$'\n'; echo "${lines[*]:0:4}") == "$_HELP_HEADER" ]]
}

@test "\`bindle help help\` prints \`help\` subcommand usage." {
  run "$_BINDLE" help help
  _expected="$(
    cat <<HEREDOC
Usage:
  bindle help [<command>]

Description:
  Display help information for bindle or a specified command.
HEREDOC
  )"
  printf "expected:\n'%s'\n" "${output}"
  printf "actual:\n'%s'\n" "${_expected}"
  [[ "$output" == "$_expected" ]]
}
