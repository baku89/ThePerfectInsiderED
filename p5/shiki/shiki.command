#!/bin/sh

cd "/Volumes/MugiRAID1/Works/2015/13_oxff/0b"

sketch="./shiki_morph"
dir="../ca/shiki/01_lg/*"



for d in $dir ; do

	if echo $d | grep 128; then
		p5 $sketch --args $d 8
	elif echo $d | grep 256; then
		p5 $sketch --args $d 8
	elif echo $d | grep 512; then
		p5 $sketch --args $d 4
	elif echo $d | grep 1024; then
		p5 $sketch --args $d 4
	fi
done