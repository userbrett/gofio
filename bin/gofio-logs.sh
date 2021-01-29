#!/bin/sh
#
# gofio-logs.sh
# ver 0.02
#
# Purpose:
# This script parses the log files generated from gofio-run.sh.
#
# Changelog:
# 0.01 - Initial Implementation to create a single, intermediate file.
# 0.02 - Multiple improvements, to include checking for non-zero data,
#        comments, formatting, etc.
#
# ##

cur="NULL"

ls logs/fio* |\
  while read file ; do
    if [ -s $file ] ; then
      echo -n ${file}
      echo -n ","
      grep -E 'READ|WRITE' ${file}
    fi
  done |\
    cut -d "/" -f 2,3,4,5,6 |\
      tr -d ' '|\
        sort -t '.' -k5,5 -k4,4 -k3,3 -k2,2 |\
          cut -d"," -f1,3,6 |\
             tr ',' ' ' |\
               while read line ; do
                 set $line

                 # Selected inclusion/exclusion of certain tests (e.g. 64m)
#                if [ $(echo $1 | grep 64m | wc -l) -gt 0 ]; then continue; fi # do not process --bs=64m
#                if [ $(echo $1 | grep 64m | wc -l) -eq 0 ]; then continue; fi # *only* process --bs=64m

                 # Save test case name into $test
                 test=$(echo -n $1 |\
                   cut -d "." -f 2,3,4,5,8,9 |\
                     tr -d '\n')

                 # Debugging - Spacing between groups - helps readability
#                if [ "$test" != "$cur" ]; then
#                  echo ; echo ; echo ; echo
#                fi
                 cur=$test

                 # Print data
                 echo -n $test
                 echo -n -e ","

                 havedatatest=$(echo $2 | cut -d"=" -f 2 | grep KB)
                 if [[ ! -z "$havedatatest" ]] ; then

                   # Have rate data - print in MB/s
                   if [ $(echo $2 | cut -d"=" -f 2 | grep KB | wc -l) -gt 0 ]; then
                     # Data is in KB
                     rate=$(echo $2 | cut -d"=" -f 2 | sed 's/KB\/s//')
                     let rate=$rate/1024    # expect floor() functionality
                     echo -n $rate
                   else
                     # Data is in MB
                     echo $2 | cut -d"=" -f 2 | sed 's/MB\/s//' | tr -d "\n"
                   fi

                   # Print minimum thread time (can be run multi-threaded)
                   echo -n -e ","
                   echo $3 |\
                     cut -d"=" -f 2 |\
                       sed 's/msec//'

                 else
                   # No rate data captured
                   echo 0,0
                 fi
               done


