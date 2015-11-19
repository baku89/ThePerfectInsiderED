from __future__ import division

import golly as g
from PIL import Image
from math import floor, ceil, log
import os
import json
import datetime
import locale

#---------------------------------------------
# settings

srcPath = "/Volumes/MugiRAID1/Works/2015/13_0xff/ae/shiki_3.tif"
dstDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/last-shiki"

expand = 100

repeat = 20

interval = 3


#---------------------------------------------
# settings

def log( data ):
	g.note( json.dumps(data) )


def main( step = 1, start = 0 ):

	# set dir name from current date
	d = datetime.datetime.today()

	dirName = "shiki_%02d-%02d-%02d-%02d" % (d.day, d.hour, d.minute, d.second)

	# create directory
	exportDir = "%s/%s" % (dstDir, dirName)
	if not os.path.exists( exportDir ):
		os.makedirs( exportDir )


	# get bound

	size = getImageSize( srcPath )

	bound = [
		-expand,
		-expand,
		size[0] + expand * 2,
		size[1] + expand * 2
	]

	# loop

	for f in xrange( repeat ):
		g.show( "Processing... %d / %d" % (f+1, repeat) )
		
		loadImage( srcPath )
		g.run( 1 )
		g.update()

		for i in xrange( interval ):
			g.run( 1 )
			g.update()
			frame = f * interval + i
			saveImage( bound, "%s/%s/%s_%06d.png" % (dstDir, dirName, dirName, frame) )



def saveImage( bound, path ):

	left = bound[0]
	top = bound[1]
	width = bound[2]
	height = bound[3]

	cellW = 2

	# create image
	img = Image.new( "RGB", ( width, height ) )
	cells = g.getcells( bound )
	cellLen = len( cells )

	white = ( 255, 255, 255 )

	for i in xrange( 0, cellLen, 2 ):
		x = cells[ i ]
		y = cells[ i + 1 ]
		img.putpixel( (x-left, y-top), (255, 255, 255) )

	# save
	img.save( path )



def getImageSize( path ):

	img = Image.open( path )
	return img.size


def loadImage( path ):

	img = Image.open( path )
	size = img.size

	c = None
	state = None

	for y in xrange( 0, size[1] ):
		for x in xrange( 0, size[0] ):

			c = img.getpixel( (x, y) )

			if c[0] > 128:
				g.setcell( x, y, 1 )

#---------------------------------------------
# main

main()


