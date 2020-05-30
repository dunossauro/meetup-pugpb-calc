#! /bin/bash
#===================================================================================
#
# Usage:
# ./tcr.sh -> test && commit || revert
# ./tcr.sh squash "my message" -> get all comits with "TCR" message squash and commit with your message
#
# Variables:
#     code_path: production code path, not test path
#   test_runner: choosed python test runner unittest, pytest, tox
#    revert_all: =1 revert all repository; =0 revert only $code_path
#===================================================================================
code_path=app/
test_runner=unittest
revert_all=1


test(){
  $1 2>&1 | tail -n 1 | grep $2
}

unittest(){
  test "python -m unittest discover tests/" 'OK'
}

pytest(){
  test "python -m pytest tests/" "passed"
}

tox(){
  test "tox" ":)"
}

commit(){
  git add .  # to add new files
  git commit -m "tcr commit"
}

revert(){
  if [[ $revert_all -eq 1 ]]; then
      echo "Reverting all repository"
      git checkout HEAD -f
      git clean -fd  # Remove new files
  else
    # Remove only $code_path, not tests
    echo "Reverting only code"
    git checkout HEAD -- $code_path
    git clean -fd -- $code_path
  fi
}

tcr(){
  case $test_runner in
    unittest) unittest && commit || revert;;
    pytest) pytest && commit || revert;;
    tox) tox && commit || revert;;
  esac
}

squash(){
  if [[ -z "$1" ]]; then
    echo -e "Please insert commit message"
    return
  fi
  COMMIT_HASH=$(git log --format=oneline | grep -v "tcr commit" | cut -d " " -f 1 | head -n 1)
  git reset --soft $COMMIT_HASH
  git commit -m "$*"
}

case $1 in
  squash) squash $2;;
  *) tcr;;
esac
