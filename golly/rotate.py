from __future__ import division

import golly as g
from PIL import Image
from math import floor, ceil, log
import os
import json

#---------------------------------------------
# settings


#---------------------------------------------
# settings

def log( data ):
	g.note( json.dumps(data) )

def main():

	# get selection and set to boundary
	bound = g.getselrect()
	if len( bound ) == 0:
		g.note( "No selection." )
		g.exit()

	# get current Golly states
	left   = bound[ 0 ]
	top    = bound[ 1 ]
	width  = bound[ 2 ]
	height = bound[ 3 ]

	for y in xrange( 0, height ):
		for x in xrange( 0, width ):

			state = g.getcell( left + x, top + y )
			g.setcell( height - y - 600, x - 600, state )

#---------------------------------------------
# main

main()


