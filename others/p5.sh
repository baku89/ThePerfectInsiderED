#!/bin/sh

function usage_exit() {
	echo "Usage: p5 sketch-path [--args sketch-args..]"
	exit 1
}


# get full path of sketch directory
if [ "$1" == "" -o "$1" == "--args" ]; then
	usage_exit
fi
sketch=$1
absPath=$(cd $(dirname $1) && pwd)/$(basename $1)

# extract arguments
shift
if [ "$1" == "--args" ]; then
	shift
else
	while [ "$1" != "" ]
	do
		shift
	done

fi

# run sketch
processing-java --sketch=${absPath} --run ${@}