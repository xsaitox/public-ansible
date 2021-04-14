#!/bin/sh
REPORTS_DIR="/nmondir"
export PATH=$PATH:/usr/local/bin:/usr/local/sbin
NMON="$(which nmon)"

run_cleanup_report()
{
  find $REPORTS_DIR -name "*daily*.csv" -mtime +30 -type f -exec gzip {} \;
  find $REPORTS_DIR -name "*daily*.gz" -mtime +90 -type f -exec rm -f {} \;
  find $REPORTS_DIR -name "*monthly*.csv" -mtime +30 -type f -exec gzip {} \;
  find $REPORTS_DIR -name "*monthly*.gz" -mtime +365 -type f -exec rm -f {} \;
}

run_daily_report()
{
  local DAILY_REPORT_FILE="$(hostname -s)_daily_$(date +%d-%m-%Y).csv"
  #
  # Recolectar cada 5 min durante 1 dia entero
  [ -f $REPORTS_DIR/$DAILY_REPORT_FILE ] && DAILY_REPORT_FILE="$(hostname -s)_daily_$(date +%d-%m-%Y-%H%M%S).csv"
  $NMON -F $REPORTS_DIR/$DAILY_REPORT_FILE -t -s 300 -c 288 
}

run_monthly_report()
{
  local MONTHLY_REPORT_FILE="$(hostname -s)_monthly_$(date +%d-%m-%Y).csv"
  local days=$(cal | grep -v "^$" | tail -1 | tr ' ' '\n' | grep -v "^$" | sort -n | tail -1)
  local num=$((($days-1)*24))
  #
  # Recolectar cada hora durante 1 mes entero
  [ -f $REPORTS_DIR/$MONTHLY_REPORT_FILE ] && MONTHLY_REPORT_FILE="$(hostname -s)_monthly_$(date +%d-%m-%Y-%H%M%S).csv"
  $NMON -F $REPORTS_DIR/$MONTHLY_REPORT_FILE -t -s 3600 -c $num
}

check_daily_report()
{
  local DAILY_REPORT_FILE="$(hostname -s)_daily_$(date +%d-%m-%Y).csv"
  local fecha=$(date +%d-%m-%Y)
  local nmonpid=$(ps -ef | grep "nmon.*daily.*$fecha" | grep -v "grep" | awk '{ print $2 }')
  if [ -z "$nmonpid" ]
  then
    local hour=$(date +%H | sed -e "s/^0//g")
    local pending=$((288-($hour*12)))
    #   
    # Recolectar cada 5 min durante lo que resta del dia
    [ -f $REPORTS_DIR/$DAILY_REPORT_FILE ] && DAILY_REPORT_FILE="$(hostname -s)_daily_$(date +%d-%m-%Y-%H%M%S).csv"
    $NMON -F $REPORTS_DIR/$DAILY_REPORT_FILE -t -s 300 -c $pending
  fi  
}

check_monthly_report()
{
  local MONTHLY_REPORT_FILE="$(hostname -s)_monthly_$(date +%d-%m-%Y).csv"
  local fecha=$(date +%d-%m-%Y)
  local nmonpid=$(ps -ef | grep "nmon.*monthly.*" | grep -v "grep" | awk '{ print $2 }')
  local days=$(cal | grep -vE "^($|[[:blank:]]+$)" | tail -1 | tr ' ' '\n' | grep -v "^$" | sort -n | tail -1)
  local num=$((($days)*24))
  if [ -z "$nmonpid" ]
  then
    local hour=$(((($(date +%d | sed -e "s/^00*//g")-1)*24)+$(date +%H | sed -e "s/^0//g")))
    local pending=$(($num-$hour))
    #
    # Recolectar cada hora durante lo que resta del mes
    [ -f $REPORTS_DIR/$MONTHLY_REPORT_FILE ] && MONTHLY_REPORT_FILE="$(hostname -s)_monthly_$(date +%d-%m-%Y-%H%M%S).csv"
    $NMON -F $REPORTS_DIR/$MONTHLY_REPORT_FILE -t -s 3600 -c $pending
  fi
}

RUN=0
CHECK=0
DAILY=0
MONTHLY=0
while getopts "rcdmC" OPTS
do
  case "$OPTS" in
    r)
      RUN=1
      ;;
    c)
      CHECK=1
      ;;
    d)
      DAILY=1
      ;;
    m)
      MONTHLY=1
      ;;
    C)
      run_cleanup_report
      ;;
  esac
done
if [ $RUN -eq 1 ]
then
  if [ $DAILY -eq 1 ]
  then
    run_daily_report
  elif [ $MONTHLY -eq 1 ]
  then
    run_monthly_report
  fi
elif [ $CHECK -eq 1 ]
then
  if [ $DAILY -eq 1 ]
  then
    check_daily_report
  elif [ $MONTHLY -eq 1 ]
  then
    check_monthly_report
  fi
fi
