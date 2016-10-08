#!/bin/bash

set -eu

SCRIPT_NAME=$0
DISPLAY=:0
JAR=/home/kassomat/changeomatic/target/changeomatic-jar-0.0.1-SNAPSHOT-jar-with-dependencies.jar

function is_running() {
  $(tmux has-session -t changeomatic &> /dev/null)
  test $? -eq 0 && echo yes
}

function usage() {
  echo "${SCRIPT_NAME} start|stop|status" 
}

function status() {
  if [ $(is_running) ]
  then echo "running"
  else echo "stopped"
  fi
}

function start() {
  if [ $(is_running) ]
  then
    echo "changeomatic is already running"   
  else
    echo "starting changeomatic"
    tmux new-session -d -s changeomatic "DISPLAY=${DISPLAY} java -jar ${JAR}"
  fi
}

function stop() {
  if [ $(is_running) ]
  then
    tmux kill-session -t changeomatic
  else 
    echo "changeomatic does not seem to be running"
  fi
}

function attach() {
  if [ $(is_running) ]
  then
    tmux attach -t changeomatic
  else 
    echo "changeomatic does not seem to be running"
  fi

}

case ${1:-usage} in
  start) start;;
  stop) stop;;
  status) status;;
  attach) attach;;
  *) usage; exit 1;;
esac
