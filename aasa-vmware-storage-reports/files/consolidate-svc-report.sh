#!/bin/bash
report_name=$1
files=""
DCS=""
for file in *.svc.csv
do
    DCS="$DCS $(basename $file .svc.csv)"
    files="$files $file"
    sed -i -e 1i"LUN Name,Group,Capacity,LUN ID" $file
done
./csv2xlsx.py $report_name $files $DCS