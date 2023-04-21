#!/usr/bin/env bash

state=IDLE

RED="\033[0;31m"
GRN="\033[0;32m"
YLW="\033[0;33m"
BLU="\033[0;34m"
STP="\e[0m"

function logger {
  olog=$1
  err=0
  while read ln
  do
    case $state in
      IDLE)
        mssg="$(date +"%H:%M:%S"): $ln"

        if [[ "$ln" == "==contents of stdout.log" ]] ; then
          state=IGNORE
        fi

        if [[ "$ln" =~ ^[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\:\ \@E\:.*$ ]] ; then
          err=1
          mssg="$(date +"%H:%M:%S.%3N"): ${RED}log4eda:ERR:${STP} $ln"
          echo -e "$mssg"
        fi

        if [[ "$ln" =~ ^WARNING\ \-\ The\ source\ file\ .*\ doesn\'t\ exist\.$ ]] ; then
          err=1
          mssg="$(date +"%H:%M:%S.%3N"): ${RED}log4eda:ERR:${STP} $ln"
          echo -e "$mssg"
        fi
        ;;
      IGNORE)
        mssg=""
        ;;
      *)
        echo "ERROR IN DIAMOND LOGGER: state = $state"
        exit 1
        ;;
    esac

    if [[ "$mssg" != "" ]] ; then
      echo -e "$mssg" >> $olog
    fi
  done <&0

  if [[ "$err" != "0" ]] ; then
    echo -e "$(date +"%H:%M:%S.%3N"): ${RED}** ERROR ** :${STP} the log4eda diamond logger \
has issued an error message"
  fi

  return $err
}