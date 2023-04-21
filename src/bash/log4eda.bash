#!/usr/bin/env bash
export log4eda=/usr/bin/log4eda_
source ${log4eda}/log4eda_util.bash
declare -A params
parse_params params "${#}" "${@}"
# echo "log4eda: Command Line Parameters Count:"
# echo "  '${#}'"
# echo "log4eda: Command Line Parameters:"
# echo "  '${@}'"
# echo "log4eda: Command Line Parameters Dictionary:"
# echo_dictionary params

param_empty_check params
param_required_check params output_log
param_required_check params tool

olog=${params[output_log]}
edatool=${params[tool]}

echo "$(date +"%H:%M:%S.%3N"): INFO: log4eda is writing to this file: $olog"

if [[ -f $olog ]] ; then
  rm -rf $olog || (echo "ERROR: cannot remove log file: $olog, please check \
command line parameters" && exit 1)
fi

touch $olog || (echo "ERROR: cannot write to log file: $olog, please check \
command line parameters" && exit 1)

loggers=${log4eda}/loggers

case $edatool in
  diamond)
    source ${loggers}/diamond.bash
    logger $olog
    result=$?
    ;;
  *)
    echo "tool not supported"
    exit 1
    ;;
esac

if [[ "$result" != "0" ]] ; then
  exit 1 ;
fi