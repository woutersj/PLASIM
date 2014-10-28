#!/usr/bin/env bash

if [[ $# -lt 2 || $# -gt 3 ]]; then
	echo "Usage: mkrun.sh namelistDir runDir [numInstances]"
	exit 1
fi;

if [ ! -d $2 ]; then
	mkdir $2;
else
	echo "Target run directory exists!"
fi;

if [ $# -eq 2 ]; then
	cp "$1"/* "$2"
elif [ $# -eq 3 ]; then
	for instance in $(seq -f '%02G' 0 $(($3 - 1))); do
		for namelist in $(ls namelists); do
			cp namelists/"$namelist" "$2"/"$namelist"_"$instance"
		done
	done
fi;

cp dat/T21/* $2
