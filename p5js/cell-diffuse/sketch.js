var N = 1 << 0,
	S = 1 << 1,
	W = 1 << 2,
	E = 1 << 3;
	
var MAP_W = 101;

var filename = "cell-diffuse";
	
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
		startIndex = getIndex( width/2, height/2 ); // left bottom
	
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

	var i;

	// all frontier
    var pos;
    for (i = 0; i < n0; ++i) {
    	pos = getPos( frontier[i] );
    	point( pos.x, pos.y );
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
	
	var cx = Math.floor( width/2 ),
		cy = Math.floor( height/2 );
	
	cells[ getIndex( cx, cy ) ] = N | E | S | W;
	
	for ( var i = 0; i < 4; i++ ) {
		
		cells[ getIndex( cx, cy-i ) ] |= N | S;
		cells[ getIndex( cx+i, cy ) ] |= E | W;
		cells[ getIndex( cx, cy+i ) ] |= N | S;
		cells[ getIndex( cx-i, cy ) ] |= E | W;
		
		// remove
		if ( i > 0 ) {
			removePath( cx, cy-i, E );
			removePath( cx, cy-i, W );
			
			// removePath( cx+i, cy, N );
			// removePath( cx+i, cy, S );
			
			removePath( cx, cy+i, E );
			removePath( cx, cy+i, W );
			
			// removePath( cx-i, cy, N );
			// removePath( cx-i, cy, S );
		}
		
	}
	
	function removePath( x, y, dir ) {
		var other;
		
		if ( dir == N ) other = E | S | W;
		else if ( dir == E ) other = N | S | W;
		else if ( dir == S ) otehr = N | E | W;
		else if ( dir == W ) other = N | E | S; 
		
		cells[ getIndex( x, y ) ] &= other;
	}
	
	canvas = createCanvas( width, height );
	background( 0 );
	
	width = MAP_W;
	height = MAP_W;
	
	drawFrame();
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
	
		setTimeout( drawFrame, 500 );
		
	}
	
	frame++;
}