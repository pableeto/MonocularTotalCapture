#!/usr/bin/bash

set -e
# input param 
# $1: sequence name
# $2: whether the video is upper body only (false by default, enable by -f)
seqName=$1
upperBody=$2

# Assume that you already have a video in $dataDir/(seqName)/(seqName).mp4 
dataDir=/data/mcgdata/total_capture_results

# convert to absolute path
MTCDir=$(readlink -f .)
dataDir=$(readlink -f $dataDir)

numFrame=$(ls $dataDir/$seqName/openpose_result/$seqName_* | wc -l)
# run Adam Fitting
cd $MTCDir/FitAdam/
if [ ! -f ./build/run_fitting ]; then
	echo "C++ project not correctly compiled. Please check your setting."
fi
export MESA_GL_VERSION_OVERRIDE=3.3
./build/run_fitting --root_dirs $dataDir --seqName $seqName --start 1 --end $((numFrame + 1)) --stage 1 --imageOF
# ./build/run_fitting --root_dirs $dataDir --seqName $seqName --start 1 --end 11 --stage 1 --imageOF
