from __future__ import division

import golly as g
from PIL import Image
from math import floor, ceil, log
import os
import json

#---------------------------------------------
# settings

exportDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/golly-exported/otca"



# common
# duration = 147 #int( g.getgen() )

otcaDur = 35328
worldWidth = 30730

# 1/16x (1920)
duration = 64
ratio = 8
subdiv = 1
skipBound = 1
# skipFrame = int(genDur / duration)

# ad
# name = "ad_x%02d" % ratio
# bound = [4, 3, 1, 1]

# da
# name = "da_x%02d" % ratio
# bound = [5, 2, 1, 1]

# dd
# name = "dd_x%02d" % ratio
# bound = [0, 0, 1, 1]

# aa
name = "aa_x%02d" % ratio
bound = [8, 3, 1, 1]

bound[0] -= 8
bound[1] -= 8

# 1/8x
# ratio = 8
# subdiv = 2
# skipBound = 2
# skipFrame = 1000
# bound = [2, 2, 11, 11]

# 1/4x
# ratio = 4
# subdiv = 2
# skipBound = 2
# skipFrame = 1000
# bound = [2, 2, 9, 8]


# 1/2x
# ratio = 2
# subdiv = 2
# skipBound = 2
# skipFrame = 1000
# bound = [3, 3, 6, 6]


# 1/1x
# ratio = 1
# subdiv = 1
# skipBound = 1
# skipFrame = 1


# dead or alive
# bound = [0, 0, 1, 1]
# mode = "dead"

# bound = [2, 5, 1, 1]
# mode = "aliv"

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
	global bound, expand

	g.reset()
	g.run(otcaDur)

	# get current Golly states
	cellWidth = 2048
	bound[ 0 ] = bound[0] * cellWidth
	bound[ 1 ] = bound[1] * cellWidth
	bound[ 2 ] = bound[2] * cellWidth
	bound[ 3 ] = bound[3] * cellWidth

	left   = bound[ 0 ]
	top    = bound[ 1 ]
	width  = bound[ 2 ]
	height = bound[ 3 ]

	palette = getPalette()
	cells = g.getcells( [0, 0, 1, 1] )
	isMultiStates = len(cells) % 2 == 1
	cellW = 2

	# create image and destination directory
	dstDir = "%s/%s" % (exportDir, name)
	if not os.path.exists( dstDir ):
		os.makedirs( dstDir )
	# else:
	# 	g.note( "destination folder already exists" )
	# 	g.exit()

	imgWidth = int( width / ratio )
	imgHeight = int ( height / ratio )

	boundWidth = ratio / subdiv


	pb = [0, 0, boundWidth, boundWidth] # pixel bound

	i = x = y = bx = by = 0

	frameCount = 0
	step = int(otcaDur / duration)

	for i in xrange(0, duration):
		g.show("Processing... %d / %d" % (i+1, duration))
		g.run(step)
		g.update()

		img = Image.new("RGB", (imgWidth, imgHeight))

		for y in xrange(imgHeight):
			for x in xrange(imgWidth):

				for by in xrange(0, subdiv, skipBound):
					for bx in xrange(0, subdiv, skipBound):
						pb[0] = left + x * ratio + bx * boundWidth
						pb[1] = top  + y * ratio + by * boundWidth
						cells = g.getcells(pb)
						if len( cells ) > 0:
							img.putpixel((x, y), (255, 255, 255))
							break

					else:
						continue
					break

		# save
		# img.save( "%s/%s_%02dx_%s_%08d.png" % (dstDir, name, ratio, mode, i) )
		# img.save( "%s/%s_%02dx_%08d.png" % (dstDir, name, ratio, i) )
		img.save("%s/%s_%04d.png" % (dstDir, name, i))


	g.show("Done.")



#---------------------------------------------
# main

main()


