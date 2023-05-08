#!/usr/bin/env bash
source ${GNASH}
declare -A params
gnash_parse_params params "${#}" "${@}"
# echo "log4eda: Command Line Parameters Count:"
# echo "  '${#}'"
# echo "log4eda: Command Line Parameters:"
# echo "  '${@}'"
# echo "log4eda: Command Line Parameters Dictionary:"
# echo_dictionary params

gnash_dict_empty_check params
gnash_dict_required_check params output_log
gnash_dict_required_check params tool

olog=${params[output_log]}
edatool=${params[tool]}

echo "$(date +"%H:%M:%S.%3N"): INFO: log4eda is writing to this file: $olog"

if [[ -f $olog ]] ; then
  rm -rf $olog || (echo "ERROR: cannot remove log file: $olog, please check \
command line parameters" && exit 1)
fi

touch $olog || (echo "ERROR: cannot write to log file: $olog, please check \
command line parameters" && exit 1)

case $edatool in
  diamond)
    source ${LOG4EDA}/logger_diamond.bash
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
