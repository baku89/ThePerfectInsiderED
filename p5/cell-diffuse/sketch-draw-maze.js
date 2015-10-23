var N = 1 << 0,
	S = 1 << 1,
	W = 1 << 2,
	E = 1 << 3;



function flood() {
    var frontier1 = [],
        i0,
        n0 = frontier.length,
        i1;
    //    color = d3.hsl((distance += .5) % 360, 1, .5).rgb();

	var i;

    for (i = 0; i < n0; ++i) {
		i0 = frontier[i] << 2;
		img.data[i0 + 0] = 255;//color.r;
		img.data[i0 + 1] = 255;//color.g;
		img.data[i0 + 2] = 255;//color.b;
		img.data[i0 + 3] = 255;
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

/////////////////////////////////////////////////////////////////


function generateMaze( cellWidth, cellHeight ) {
	
	var cells = new Array(cellWidth * cellHeight),
		frontier = minHeap( function(a, b) { return a.weight - b.weight; } ),
		startIndex = (cellHeight - 1) * cellWidth; // left bottom
	
	cells[startIndex] = 0; // empty?
	frontier.push( {index: startIndex, direction: N, weight: Math.random()} );
	frontier.push( {index: startIndex, direction: E, weight: Math.random()} );
	
	
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
	
	console.log( cells );
	
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

var cells;



/////////////////////////////////////////////////////////////////
// create Maze

function setup() {
	
	var width = 100, height = 100;
	
	createCanvas( width * 2 + 1, height * 2 + 1 );
	
	background( 0 );
	
	
	var cells = null,
		distance = 0,
		visited = new Array(width * height),
		frontier = [(height - 1) * width],
		img = createImage( width, height );
	
	cells = generateMaze( width, height );

	stroke( 255 );
	
	var cell, px, py;
	
	for ( var y = 0; y < height; y++ ) {
		for ( var x = 0; x < width; x++ ) {
		
			cell = cells[ y * width + x ];
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
	}
}
