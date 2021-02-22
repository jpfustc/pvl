#!/usr/bin/env bash

# This script integrates the python development envornment setup and command tools
# Run `source pjtools.sh -h for use cases`

# `setup dir` sets up an virtual environment in dir TODO update default virtual env dir
# `venv` activates the default venv
# `test` activates the defualt venv and runs pytest in test directory
# TODO 2nd tier git commands
# TODO lint?

# set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

#Modify virtual envorinment directory as needed
venv_dir="/home/jpfustc/projects/venv_general"

entry_dir=$(pwd)
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
project_dir=${script_dir}
parent_dir=$(dirname "${project_dir}")

usage() {
  cat <<EOF
Usage: source $(basename "${BASH_SOURCE[0]}") [setup dir] [venv] [test] [help | -h | --help]

Script description here.

Available commands:

setup dir      Install virtual environment in dir and install dependencies
venv            Activate virtual environment and setup python path
test            Run pytest with test scripts
format          Fromat code with python black module
run             run main script

###########################
Modify venv path as desired
###########################
EOF
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
  unset -f venv py_test setup format main
  unset -f msg setup_colors die
}


setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
#  exit "$code"
}

venv(){
  source ${venv_dir}/bin/activate   # Activate python virtual envorinment
  export PYTHONPATH=/home/jpfustc/projects
}

py_test(){
  [[ $(which python) != ${venv_dir}/bin/python ]] && venv    # Activate venv if not already
  cd ${project_dir}/test && pytest  # Run pytest in the test folder
  cd ${entry_dir}                 # Return to original folder
}

run_main_script(){
  [[ $(which python) != ${venv_dir}/bin/python ]] && venv    # Activate venv if not already
  python ${project_dir}/src/run.py ${logging_level}

}

setup_venv(){
  set -v
  pip3 install virtualenv
  python3 -m virtualenv -p python3.6 ${venv_dir}
  venv            # Activate venv after installation
  pip install -U pip wheel poetry setuptools
  # Remove existing poetry dependency version, then install all dependencies specified
  [[ -f ${project_dir}/poetry.lock  ]] && rm ${project_dir}/poetry.lock
  cd ${project_dir} && poetry install
  cd ${entry_dir}
}

format() {
  python -m black ${project_dir}
}

main() {
  # Parse and execute commands
  command_detected=0
  while :; do
    case "${1-}" in
    venv)
      command_detected=1
      venv;;
    test)
      command_detected=1
      py_test;;
    run)
      command_detected=1
      [[ ! -z ${2-} ]] && logging_level="-l ${2}" || logging_level=""
      shift
      run_main_script
      ;;
    setup) # Setup virtual environment int the following path
      command_detected=1
      venv_dir="${2-}"
      shift
      setup
      ;;
    format) # Run formatter
      command_detected=1
      format
      ;;
    -h | help | --help) usage;;
    -?*)
      die "Unknown option: $1" ;;
    *)
      if (( ${command_detected} == 0 ))
        then
          msg "${RED}No valid command detected${NOFORMAT}"
          usage
      fi
      break ;;
    esac
    shift
  done

  return 0
}

setup_colors
main "$@"

