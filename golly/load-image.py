from __future__ import division

import golly as g
from PIL import Image
from math import floor, ceil, log
import os
import json

#---------------------------------------------
# settings

srcPath = "/Volumes/MugiRAID1/Works/2015/13_0xff/ae/a_frame.png"


#---------------------------------------------
# settings

def log( data ):
	g.note( json.dumps(data) )


def main( step = 1, start = 0 ):
	
	img = Image.open( srcPath )
	size = img.size

	for y in xrange( 0, size[1] ):
		for x in xrange( 0, size[0] ):

			c = img.getpixel( (x, y) )

			state = 1 if c[0] > 128 else 0
			g.setcell( x, y, state )



#---------------------------------------------
# main

main()


# 0.7019105 * ( 114.953 * tan( 53.13/ 180 * pi / 2) )