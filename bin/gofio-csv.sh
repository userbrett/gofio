#! /bin/bash
#
# gofio-csv.sh
# ver 0.02
#
# Purpose:
# This script executes 256 different test cases (per DATADIR).  The
# goal is to use 'fio' to test many permutations for performance.
#
# Changelog:
# 0.01 - Initial Implementation to parse the intermediate file into CSV files.
# 0.02 - Updated to support a config file.
#        Updated to create CSV files that can directly generate charts once imported.
#
# ##

#
# Initialize the *upper case" variables
if [ -e ../config/config.txt ]; then
  . ../config/config.txt
fi

## Not accounted for, as they are tracked in the log file name:
##
# ioengine in $IOENGINE
# directio in $DIRECTIO


## Create a single CSV file
for bs in $BS
do

  for type in $IOTYPE
  do

    for maxRPC in $MAXRPC
    do
      echo -n ",$maxRPC" >> ../results/results.csv
    done ; echo >> ../results/results.csv

    for dir in $DATADIRS
    do

      for iodepth in $IODEPTH
      do

        ## Print Data Field
        echo -n $dir\.$bs\.$type\.$iodepth >> ../results/results.csv

        ## Print Data
        for maxRPC in $MAXRPC
        do
          mbps=$( grep $dir\.*\.$bs\.$type\.$iodepth\.rpc$maxRPC ../results/results.raw | cut -d"," -f2 )
          echo -n ",$mbps" >> ../results/results.csv
        done ; echo >> ../results/results.csv

      done
      echo >> ../results/results.csv
    done
  done
done



## Create unique files for each IO test troup

## Print Column Heading
for bs in $BS
do

  for type in $IOTYPE
  do

    for maxRPC in $MAXRPC
    do
      echo -n ",$maxRPC" >> ../results/$bs.$type.csv
    done ; echo >> ../results/$bs.$type.csv

  done
done


## Add Data
for dir in $DATADIRS
do

  for bs in $BS
  do

    for type in $IOTYPE
    do

      for iodepth in $IODEPTH
      do

        ## Print Data Field
        echo -n $dir\.$bs\.$type\.$iodepth >> ../results/$bs.$type.csv

        ## Print Data
        for maxRPC in $MAXRPC
        do
          mbps=$( grep $dir\.*\.$bs\.$type\.$iodepth\.rpc$maxRPC ../results/results.raw | cut -d"," -f2 )
          echo -n ",$mbps" >> ../results/$bs.$type.csv
        done ; echo >> ../results/$bs.$type.csv

      done
      echo >> ../results/$bs.$type.csv
    done
  done  
done

