#!/usr/bin/env bash

if [[ $# -lt 3 || $# -gt 4 ]]; then
	echo "Usage: mkrun.sh namelistDir resolution runDir [numInstances]"
	exit 1
fi;

NLDIR=$1
RESOLUTION=$2
RUNDIR=$3

if [ ! -d $RUNDIR ]; then
	mkdir $RUNDIR;
else
	echo "Target run directory exists!"
fi;

if [ ! -d dat/$RESOLUTION ]; then
	echo "dat directory for specified resolution does not exist!"
fi;

if [ $# -eq 3 ]; then
	cp "$NLDIR" "$RUNDIR"
elif [ $# -eq 4 ]; then
	NUMINSTANCES=$4
	for instance in $(seq -f '%02G' 0 $(($NUMINSTANCES - 1))); do
		for namelist in $(ls $NLDIR); do
			cp "$NLDIR"/"$namelist" "$RUNDIR"/"$namelist"_"$instance"
		done
	done
fi;

cp dat/$RESOLUTION/* $RUNDIR
cp src/plasim.x $RUNDIR
