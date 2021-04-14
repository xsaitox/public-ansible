#!/bin/bash
report_name=$1
files=""
DCS=""
for file in *.vce.csv
do
    DCS="$DCS $(basename $file .vce.csv)"
    files="$files $file"
    sed -i -e 1i"VM,PowerState,DNS Name,CPUs,Memory GB" $file
done
./csv2xlsx.py $report_name $files $DCS