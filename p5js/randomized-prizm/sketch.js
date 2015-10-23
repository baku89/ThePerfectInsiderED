var N = 1 << 0,
	S = 1 << 1,
	W = 1 << 2,
	E = 1 << 3;
	
var MAP_W = 1281;

var filename = "prizm-radial";
	
var exportDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/prizm";

var isSave = false;

var d = new Date();

var ox = Math.floor( MAP_W / 2 ),
	oy = Math.floor( MAP_W / 2 );
	
// var ox = 0,
// 	oy = 1;

filename += "_" + ("00"+d.getDate()).substr(-2) + "-" + ("00"+d.getHours()).substr(-2) + "-"
	+ ("00"+d.getMinutes()).substr(-2) + "-" + ("00"+d.getSeconds()).substr(-2);
/////////////////////////////////////////////////////////////////


function generateMaze( cellWidth, cellHeight ) {
	
	var cells = new Array(cellWidth * cellHeight),
		frontier = minHeap( function(a, b) { return a.weight - b.weight; } ),
		startIndex = getIndex( width/2, height/2 );//(cellHeight - 1) * cellWidth; // left bottom
	
	cells[startIndex] = 0; // empty?
	frontier.push( {index: startIndex, direction: N, weight: Math.random()} );
	frontier.push( {index: startIndex, direction: E, weight: Math.random()} );
	frontier.push( {index: startIndex, direction: S, weight: Math.random()} );
	frontier.push( {index: startIndex, direction: W, weight: Math.random()} );
	
	
	while ( (edge = frontier.pop()) != null ) {
		
		var edge,
		    i0 = edge.index, 				// i0
		    d0 = edge.direction, 			// d0
		    i1 = i0 + (d0 === N ? -cellWidth : d0 === S ? cellWidth : d0 === W ? -1 : +1), // neighbor cell position
		    x0 = i0 % cellWidth,			// x0
		    y0 = i0 / cellWidth | 0,		// y0
		    x1,
		    y1,
		    d1,
		    open = cells[i1] === undefined; // opposite not yet part of the maze
	
		if (d0 === N) {
			x1 = x0;
			y1 = y0 - 1;
			d1 = S;
		} else if (d0 === S) {
			x1 = x0;
			y1 = y0 + 1;
			d1 = N;
		} else if (d0 === W) {
			x1 = x0 - 1;
			y1 = y0;
			d1 = E;
		} else {
			x1 = x0 + 1;
			y1 = y0;
			d1 = W;
		}
		
		if (open) {
			cells[i0] |= d0;
			cells[i1] |= d1;
			
			if (y1 > 0 && cells[i1 - cellWidth] === undefined) {
				frontier.push({index: i1, direction: N, weight: Math.random()});
			}
			
			if (y1 < cellHeight - 1 && cells[i1 + cellWidth] === undefined) {
				frontier.push({index: i1, direction: S, weight: Math.random()});
			}
			if (x1 > 0 && cells[i1 - 1] === undefined) {
				frontier.push({index: i1, direction: W, weight: Math.random()});
			}
			if (x1 < cellWidth - 1 && cells[i1 + 1] === undefined) {
				frontier.push({index: i1, direction: E, weight: Math.random()});
			}
		}
	}
	
	return cells;
	
}

function minHeap(compare) {
	
	var heap = {},
		array = [],
		size = 0;
		
	heap.array = array;
	
	heap.empty = function() {
		return !size;
	};
	
	heap.push = function(value) {
		up(array[size] = value, size++);
    	return size;
	};
	
	heap.pop = function() {
		if (size <= 0) return;
		var removed = array[0], value;
		if (--size > 0) value = array[size], down(array[0] = value, 0);
		return removed;
	};
	
	function up(value, i) {
		
		while ( i > 0 ) {
			var j = ((i + 1) >> 1) - 1,
			parent = array[j];
			if (compare(value, parent) >= 0) break;
			array[i] = parent;
			array[i = j] = value;
		}
	}
	
	function down(value, i) {
		while (true) {
			var r = (i + 1) << 1,
				l = r - 1,
				j = i,
		    child = array[j];
			if (l < size && compare(array[l], child) < 0) child = array[j = l];
			if (r < size && compare(array[r], child) < 0) child = array[j = r];
			if (j === i) break;
			array[i] = child;
			array[i = j] = value;
		}
	}
	
	return heap;
}

/////////////////////////////////////////////////////////////////

var canvas;

var cells;

var width = MAP_W,
	height = MAP_W;

var distance = 0,
	visited = new Array( width * height ),
	frontier = [ getIndex( ox, oy ) ];

function getIndex( x, y ) {
	return Math.floor(y) * width +  Math.floor(x);
}

function getPos( index ) {
	return {
		x: index % width,
		y: Math.floor( index / width )
	}
}

function flood() {
    var frontier1 = [],
        i0,
        n0 = frontier.length,
        i1;
    	//    color = d3.hsl((distance += .5) % 360, 1, .5).rgb();

	var i;

	// all frontier
    var pos;
    for (i = 0; i < n0; ++i) {
    	pos = getPos( frontier[i] );
    	point( pos.x, pos.y );
		
		//i0 = frontier[i] << 2;
		//img.data[i0 + 0] = 255;//color.r;
		//img.data[i0 + 1] = 255;//color.g;
		//img.data[i0 + 2] = 255;//color.b;
		//img.data[i0 + 3] = 255;
    }

    for (i = 0; i < n0; ++i) {
		i0 = frontier[i];
		if (cells[i0] & E && !visited[i1 = i0 + 1]) visited[i1] = true, frontier1.push(i1);
		if (cells[i0] & W && !visited[i1 = i0 - 1]) visited[i1] = true, frontier1.push(i1);
		if (cells[i0] & S && !visited[i1 = i0 + width]) visited[i1] = true, frontier1.push(i1);
		if (cells[i0] & N && !visited[i1 = i0 - width]) visited[i1] = true, frontier1.push(i1);
    }

    frontier = frontier1;
    return !frontier1.length;
}
	
function setup() {
	
	width = MAP_W;
	height = MAP_W;
	

	cells = generateMaze( width, height );
	
	// make grid
		
	openNeumann();
	openDiagonal();
	
	// createCanvas( width * 2 + 1, height * 2 + 1 );
	canvas = createCanvas( width, height );
	background( 0 );
	
	width = MAP_W;
	height = MAP_W;
	
	drawFrame();
	
	/*stroke( 255 );
	
	var cell, px, py;
	
	for ( var y = 0; y < height; y++ ) {
		for ( var x = 0; x < width; x++ ) {
		
			cell = cells[ getIndex(x,y) ];
			px = 1 + x*2;
			py = 1 + y*2;
			
			// cell
			point( px, py );
			
			// N
			if ( cell & N )	point( px, py-1 );
			if ( cell & E )	point( px+1, py );
			if ( cell & S )	point( px, py+1 );
			if ( cell & W )	point( px-1, py );
		
		
		}
	}*/
}

function openNeumann() {
	
	// var ox = Math.floor( width / 2 ),
	// 	oy = Math.floor( height / 2 ), // center
	var	x, y;
	var i;
	
	// North
	x = ox, y = oy;
	while( y >= 0 ) {
		i = getIndex(x, y);
		cells[ i ] |= N;
		cells[ i ] |= S;
		y--;
	}
	// South
	x = ox, y = oy;
	while( y < height ) {
		i = getIndex(x, y);
		cells[ i ] |= N;
		cells[ i ] |= S;
		y++;
	}
	// West
	x = ox, y = oy;
	while( x >= 0 ) {
		i = getIndex(x, y);
		cells[ i ] |= W;
		cells[ i ] |= E;
		x--;
	}
	// East
	x = ox, y = oy;
	while( x < width ) {
		i = getIndex(x, y);
		cells[ i ] |= W;
		cells[ i ] |= E;
		x++;
	}
}

function openDiagonal() {
	
	console.log("Diagonal");
	
	// var ox = Math.floor( width / 2 ),
	// 	oy = Math.floor( height / 2 ), // center
	var	x, y;
	var i;
	
	// SE
	x = ox, y = oy;
	while( x < width ) {
		// x or y
		if ( Math.random() < .5) { // go x
			cells[ getIndex(x,y) ] |= E;
			cells[ getIndex(x+1,y) ] |= S;
			cells[ getIndex(x+1,y) ] |= W;
			cells[ getIndex(x+1,y+1) ] |= N;	
		} else {
			cells[ getIndex(x,y) ] |= S;
			cells[ getIndex(x,y+1) ] |= N;
			cells[ getIndex(x,y+1) ] |= E;
			cells[ getIndex(x+1,y+1) ] |= W;
		}
		x++, y++;
	}
	
	// NW
	x = ox, y = oy;
	while( x > 0 ) {
		// x or y
		if ( Math.random() < .5) { // go x
			cells[ getIndex(x,y) ] |= W;
			cells[ getIndex(x-1,y) ] |= N;
			cells[ getIndex(x-1,y) ] |= E;
			cells[ getIndex(x-1,y-1) ] |= S;	
		} else {
			cells[ getIndex(x,y) ] |= N;
			cells[ getIndex(x,y-1) ] |= S;
			cells[ getIndex(x,y-1) ] |= W;
			cells[ getIndex(x-1,y-1) ] |= E;
		}
		x--, y--;
	}
	
	// NE
	x = ox, y = oy;
	while( x < width ) {
		// x or y
		if ( Math.random() < .5) { // go x
			cells[ getIndex(x,y) ] |= E;
			cells[ getIndex(x+1,y) ] |= N;
			cells[ getIndex(x+1,y) ] |= W;
			cells[ getIndex(x+1,y-1) ] |= S;	
		} else {
			cells[ getIndex(x,y) ] |= N;
			cells[ getIndex(x,y-1) ] |= S;
			cells[ getIndex(x,y-1) ] |= E;
			cells[ getIndex(x+1,y-1) ] |= W;
		}
		x++, y--;
	}
	
	// SW
	x = ox, y = oy;
	while( x > 0 ) {
		// x or y
		if ( Math.random() < .5) { // go x
			cells[ getIndex(x,y) ] |= W;
			cells[ getIndex(x-1,y) ] |= S;
			cells[ getIndex(x-1,y) ] |= E;
			cells[ getIndex(x-1,y+1) ] |= N;	
		} else {
			cells[ getIndex(x,y) ] |= S;
			cells[ getIndex(x,y+1) ] |= N;
			cells[ getIndex(x,y+1) ] |= W;
			cells[ getIndex(x-1,y+1) ] |= E;
		}
		x--, y++;
	}
	


}

var frame = 0;

function drawFrame() {
	
	stroke( 255, frame % 255, Math.floor( frame / 255 ) );
	
	if ( flood() ) {
		return;
	}
	
	var frameStr = ( "000000" + frame ).substr( -6 );
	var path = exportDir + "/" + filename + "/" + filename + "_" + frameStr + ".png";
	
	data = {
		image: canvas.canvas.toDataURL(),
		path: path
	};
	
	if ( isSave ) {
	
		$.post( "http://localhost:8080/save-sequence.php", data, function(data) {
			
			setTimeout( drawFrame, 5 );
			
		} );
	
	} else {
	
		setTimeout( drawFrame, 5 );
		
	}
	
	frame++;
}

/*
var r = 0;


function draw() {

	r = (r+1) % 255;
	
	stroke( r, 255, 0 );

	flood();
}*/