from __future__ import division

import golly as g
from PIL import Image
from math import floor, ceil, log
import os
import json

#---------------------------------------------
# settings

exportDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/golly-exported"

name = "otca"

duration = None#8 #int( g.getgen() )

isReset = True

expand = 0
bound = [0, 0, 2048, 2048]

otcaInterval = 35328
otcaStep = 64

step = otcaInterval / otcaStep

#---------------------------------------------
# settings

def log( data ):
	g.note( json.dumps(data) )

def getPalette():
	colors = g.getcolors()

	palette = {}

	for i in xrange( 0, len(colors), 4 ):
		state = colors[ i ]
		rVal = colors[ i + 1 ]
		gVal = colors[ i + 2 ]
		bVal = colors[ i + 3 ]
		palette[ state ] = ( rVal, gVal, bVal )

	return palette

def main( step = 1, start = 0 ):
	global bound, expand, duration

	# get selection and set to boundary
	bound = g.getselrect()

	if duration == None:
		duration = int( g.getgen() )

	if isReset:
		g.reset()

	if len( bound ) == 0:
		g.note( "No selection." )
		g.exit()

	# get current Golly states
	if bound == None:
		bound[ 0 ] -= expand
		bound[ 1 ] -= expand
		bound[ 2 ] += expand * 2
		bound[ 3 ] += expand * 2

	left   = bound[ 0 ]
	top    = bound[ 1 ]
	width  = bound[ 2 ]
	height = bound[ 3 ]

	palette = getPalette()
	cells = g.getcells( bound )
	isMultiStates = len(cells) % 2 == 1
	cellW = 3 if isMultiStates else 2

	# create image and destination directory
	dstDir = "%s/%s" % (exportDir, name)
	if not os.path.exists( dstDir ):
		os.makedirs( dstDir )
	# else:
	# 	g.note( "destination folder already exists" )
	# 	g.exit()

	# log( cells )

	for i in xrange( duration ):
		g.show( "Processing... %d / %d" % (i+1, duration) )
		g.run( 1 )
		g.update()
		cells = g.getcells( bound )

		# create image
		img = Image.new( "RGB", ( width, height ) )
		cellLen = int( floor( len(cells)/cellW ) * cellW )

		for i in xrange( 0, cellLen, cellW ):
			x = cells[ i ]
			y = cells[ i + 1 ]
			state = cells[ i + 2 ] if isMultiStates else 1
			img.putpixel( (x-left, y-top), palette[state] )

		# save
		gen = int( g.getgen() )
		img.save( "%s/%s_%08d.png" % (dstDir, name, gen) )

#---------------------------------------------
# main

main()


