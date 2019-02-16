#!/bin/bash

runList=${1:-"unSeenRuns.list"}
runDirectory="run18.ZdcCalibration.lkramarik"
runYear="run18"
tofCut=100

# untar all the tarred .dat files
data/untarAll.sh data/$runDirectory

makeUnseenList.sh $runYear

for run in $( cat  $runList ); do
  echo '*************run '$run'*************'
  ls data/$runDirectory/$run/* > data/$runDirectory.list

  # if [ ! -f read.pid ]; then
  #   rm -f read.out
  # else
  if [ -f read.pid ]; then
    echo Previous reading failed, aborting ...
    return -1
  fi

  ./read

  pushd ../ZDC_Calibration/ZdcCalibration/ >> /dev/null
  ./run.sh $run $tofCut
  popd >> /dev/null
done

cp ../ZDC_Calibration/ZdcCalibration/moveToWww.sh ../ZDC_Calibration/$runDirectory/

pushd ../ZDC_Calibration/$runDirectory  >> /dev/null
  ./moveToWww.sh
popd >> /dev/null

echo '**************Finished****************'