#!/usr/bin/env bash

state=IDLE

RED="\033[0;31m"
GRN="\033[0;32m"
YLW="\033[0;33m"
BLU="\033[0;34m"
STP="\e[0m"
DATE="%H:%M:%S.%3N"

function logger {
  olog=$1
  err=0
  while read ln
  do
    case $state in
      IDLE)
        mssg="$(date +${DATE}): $ln"

        if [[ "$ln" == "==contents of stdout.log" ]] ; then
          state=IGNORE
        fi

        if [[ "$ln" =~ ^[0-9][0-9]\:[0-9][0-9]\:[0-9][0-9]\:\ \@E\:.*$ ]] ; then
          err=1
          mssg="$(date +${DATE}): ${RED}log4eda:ERR:${STP} $ln"
          echo -e "$mssg"
        fi

        if [[ "$ln" =~ ^WARNING\ \-\ The\ source\ file\ .*\ doesn\'t\ exist\.$ ]] ; then
          err=1
          mssg="$(date +${DATE}): ${RED}log4eda:ERR:${STP} $ln"
          echo -e "$mssg"
        fi

        if [[ "$ln" =~ ^.*Job\:\ \"hdl_info_gen\"\ terminated\ with\ error ]] ; then
          err=1
          mssg="$(date +${DATE}): ${RED}log4eda:ERR:${STP} $ln"
          echo -e "$mssg"
          state=SYNTAX
        fi
        ;;
      SYNTAX)
        if [[ "$ln" =~ ^See\ log\ file\:\ \".*\"$ ]] ; then
          the_file=$(echo $ln | sed 's/.*\ //g' | sed 's/\"//g')
          this_egrep=$(egrep "\@E\:" ${the_file})
          old=$IFS
          IFS=$'\n'
          for i in $this_egrep ; do
            mssg="$(date +${DATE}): ${RED}log4eda:ERR:${STP} $i"
            echo -e "$mssg"
            echo -e "$mssg" >> $olog
          done
          IFS=$old
          mssg="$(date +${DATE}): INFO: Scanned syntax.log"
          echo -e "$mssg"
        else
          mssg="$(date +${DATE}): ${RED}log4eda Failure:${STP} Could not find syntax.log \
file in line: $ln"
          echo -e "$mssg"
        fi
        state=IDLE
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
    echo -e "$(date +${DATE}): ${RED}** ERROR ** :${STP} the log4eda diamond logger \
has issued an error message"
  fi

  return $err
}
