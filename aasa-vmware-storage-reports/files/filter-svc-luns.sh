#!/bin/bash
customer_prefix=$1
file=$2
DC=$(basename $file .svc)
grep -i $customer_prefix $file | grep -v "[[:blank:]]rc" | awk '{ print $2,$7,$8,$10 }' | tr " " "," > ${file}.csv
grep -i $customer_prefix $file | grep "[[:blank:]]rc" | awk '{ print $2,$7,$8,$10 }' | tr " " "," >> ${file}.csv
