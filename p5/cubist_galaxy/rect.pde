color[] colors = {
    color(255, 0, 0),
    color(0, 255, 0),
    color(0, 0, 255),
    color(255, 255, 0)
};


void loadAndSearch( String path ) {
    
    src = loadImage( path );

    changeWindowSize( src.width, src.height );

    filled = new boolean[ width ][ height ];

    // initialize fiiled
    for ( int i = 0; i < colors.length; i++ ) {
    
        for ( int y = 0; y < height; y++ ) {
            for ( int x = 0; x < width; x++ ) {
                filled[x][y] = src.get( x, y ) != colors[i];
            }
        }
    
        // search
        searchRect( 1.5, 20 );
        searchRect( max( width, height ), 3 );
        
    }



}


void searchRect( float maxAspect, int minWidth ) {
    
    for ( int y = 0; y < height; y++ ) {
        for ( int x = 0; x < width; x++ ) {
            
            if ( !filled[x][y] ) {
                
                // start searching
                Rect r = findRect( x, y );
                
                if ( r.w >= minWidth && r.h >= minWidth && r.aspect() <= maxAspect && 1.0 / r.aspect() <= maxAspect ) {
                
                    checkSearchedRect( r );
                    rects.add( r );
                }
            }
        }
    }
    
    println( "end search: aspect=", maxAspect, "minWidth=", minWidth ); 
}

void checkSearchedRect( Rect r ) {
    
    // fill
    for ( int _y = r.y; _y <= r.bottom(); _y++ ) {
        for ( int _x = r.x; _x <= r.right(); _x++ ) {
            filled[_x][_y] = true;
        }
    }
    
}

Rect findRect( int x, int y ) {
    
    Rect r = new Rect( x, y, 1, 1 );
    Rect outer = new Rect();
    
    // expand top
    
    /*outer.copy( r );
    do {
        outer.y -= 1;
        outer.h += 2;
        
        if ( searchRectEdge( outer ) ) {
            r.copy( outer );
        } else {
            break;
        }
    } while ( true );*/

    // expand right
    outer.copy( r );
    do {
        outer.w += 1;
        
        if ( searchRectEdge( outer ) ) {
            r.copy( outer );
        } else {
            break;
        }
    } while ( true );
    
    // expand bottom
    outer.copy( r );
    do {
        outer.h += 1;
        
        if ( searchRectEdge( outer ) ) {
            r.copy( outer );
        } else {
            break;
        }
    } while ( true );
    
    /*// expand left
    outer.copy( r );
    do {
        outer.x -= 1;
        outer.w += 2;
        
        if ( searchRectEdge( outer ) ) {
            r.copy( outer );
        } else {
            break;
        }
    } while ( true );*/
    
    return r;
}

boolean searchRectEdge( Rect r ) {
    
    
    if ( r.x < 0 || r.y < 0 || r.right() >= width || r.bottom() >= height ) {
        return false;
    }
    
    // horizontal edge
    for ( int x = r.x; x <= r.right(); x++ ) {
        if ( filled[x][r.y] || filled[x][r.bottom()] ) {
            return false;
        }
    }
    
    // vertical edge
    for ( int y = r.y; y <= r.bottom(); y++ ) {
        if( filled[r.x][y] || filled[r.right()][y] ) {
            return false;
        }
    }
    
    return true;
}