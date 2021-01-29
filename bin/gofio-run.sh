#! /bin/bash
#
# gofio-run.sh
# ver 0.02
# Idea/Implementation : Jer-Ming Chia <jer-ming.chia@cyclecomputing.com>
#
# Purpose:
# This script executes 256 different test cases (per DATADIR).  The
# goal is to use 'fio' to test many permutations for performance.
#
# Changelog:
# 0.01 - With only some minor changes, packaged Jer-Ming's work.
# 0.02 - Updated to support a config file.
#
# ##


# Initialize the *upper case" variables
if [ -e ../config/config.txt ]; then
  . ../config/config.txt
fi

log=$(date +%d%m%y_%H%M%S)

for count in $ITERATIONS
do
  for dir in $DATADIRS
  do
    for bs in $BS
    do
    if [[ $bs =~ 'k' ]];then
      size=100m
    else
      size=1g
    fi
      for type in $IOTYPE
      do
        for ioengine in $IOENGINE
        do
          for directio in $DIRECTIO
          do
            for iodepth in $IODEPTH
            do
              for maxRPC in $MAXRPC
              do

    set -x
    # If appropriate, flush server caches (password-less SSH)
#   ssh root@mds1 "sync; echo 3 > /proc/sys/vm/drop_caches"
#   ssh root@oss1 "sync; echo 3 > /proc/sys/vm/drop_caches"
#   ssh root@oss2 "sync; echo 3 > /proc/sys/vm/drop_caches"
    sync; echo 3 > /proc/sys/vm/drop_caches
    lctl set_param osc.*ffff*.max_rpcs_in_flight $maxRPC
    /usr/bin/fio --name=global --directory=$BASEDIR/$dir \
	--rw=$type \
	--ioengine=$ioengine \
	--direct=$DIRECTIO \
	--iodepth=$iodepth \
	--bs=$bs \
	--size=$size \
	--name=fio.$bs.$type.$count.$RANDOM \
	--output=fio.$dir.$size.$bs.$type.$count.$ioengine.$iodepth.rpc$maxRPC.$log.log \
	--pre_read=0 --latency-log --bandwidth-log --numjobs=1 
    rm -f $BASEDIR/$dir/fio.*
    set +x

              done
            done
          done
        done
      done
    done
  done  
done

