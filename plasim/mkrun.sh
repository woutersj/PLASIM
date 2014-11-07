#!/usr/bin/env bash

if [[ $# -lt 3 || $# -gt 4 ]]; then
	echo "Usage: mkrun.sh namelistDir dataDir runDir [numInstances]"
	exit 1
fi;

if [ ! -d $3 ]; then
	mkdir $3;
else
	echo "Target run directory exists!"
	exit 1
fi;

# copy namelists
if [ $# -eq 3 ]; then
	cp "$1"/* "$3"
elif [ $# -eq 4 ]; then
	for instance in $(seq -f '%02G' 0 $(($4 - 1))); do
		for namelist in $(ls "$namelistDir"); do
			cp "$namelistDir"/"$namelist" "$2"/"$namelist"_"$instance"
		done
	done
fi;

# copy data
cp "$2"/* "$3"
