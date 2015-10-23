void changeWindowSize(int w, int h) {

    surface.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    size(w, h);
}


PImage subdivideToUI() {

    // find frontier
    
    ArrayList< Point > search = new ArrayList< Point >();
    ArrayList< Rect > rects = new ArrayList< Rect >();
    
    PImage img = createImage( width, height, RGB );
    img.copy( map, 0, 0, width, height, 0, 0, width, height );
    
    for ( int y = 0; y < height; y++ ) {
        for ( int x = 0; x < width; x++ ) {
            
            if ( img.get( x, y ) == colorSeed ) {
                
                if( img.get( x, y-1 ) == colorRoot ) search.add( new Point( x, y-1 ) );
                if( img.get( x+1, y ) == colorRoot ) search.add( new Point( x+1, y ) );
                if( img.get( x, y+1 ) == colorRoot ) search.add( new Point( x, y+1 ) );
                if( img.get( x-1, y ) == colorRoot ) search.add( new Point( x-1, y ) );
                
                Rect r = new Rect( x, y, 1, 1 );
                rects.add( r );
                deleteRoot( img, r );
                
            }
        }
    }
    
    do {
        
        // search rect
        Point p;
        int x, y;
        int x0, y0, x1, y1;
        
        boolean hasVertical, hasHorizontal;
        
        for ( int i = search.size() - 1; i >= 0; i-- ) {
            
        
            p = search.get( i );
            x = p.x;
            y = p.y;
            
            hasHorizontal = img.get( x-1, y ) == colorRoot || img.get( x+1, y ) == colorRoot;
            hasVertical   = img.get( x, y-1 ) == colorRoot || img.get( x, y+1 ) == colorRoot;
            
            if ( hasHorizontal && hasVertical ) {
            
                if ( random(1) > 0.5 ) {
                    hasHorizontal = false;
                } else {
                    hasVertical = false;
                }
            }
            
            // search
            if ( hasHorizontal ) {
            
                x0 = searchDir( search, img, p, -1, 0 ).x;
                x1 = searchDir( search, img, p, +1, 0 ).x;
                y0 = y;
                y1 = y;
            
            } else {
            
                x0 = x;
                x1 = x;
                y0 = searchDir( search, img, p, 0, -1 ).y;
                y1 = searchDir( search, img, p, 0, +1 ).y;
                
            }
            
            Rect r = new Rect( x0, y0, x1-x0+1, y1-y0+1 );
            rects.add( r );
            deleteRoot( img, r );
            search.remove( i );
            
            for ( int ry = r.y; ry < r.y + r.h; ry++ ) {
                for ( int rx = r.x; rx < r.x + r.w; rx++ ) {
                    if( img.get( rx, ry-1 ) == colorRoot ) search.add( new Point( rx, ry-1 ) );
                    if( img.get( rx+1, ry ) == colorRoot ) search.add( new Point( rx+1, ry ) );
                    if( img.get( rx, ry+1 ) == colorRoot ) search.add( new Point( rx, ry+1 ) );
                    if( img.get( rx-1, ry ) == colorRoot ) search.add( new Point( rx-1, ry ) );
                }
            }
        }
    
    } while( search.size() > 0 );
    
    
    // draw
    return renderUI( rects, width, height, 8 );
    
}



Point searchDir( ArrayList< Point > search, PImage img, Point origin, int dx, int dy ) {

    int x = origin.x,
        y = origin.y;
    
    while ( img.get( x+dx, y+dy ) == colorRoot ) {
        
        x += dx;
        y += dy;
    }
    
    return new Point( x, y );
}


void deleteRoot( PImage img, Rect r ) {

    for ( int y = r.y; y < r.y + r.h; y++ ) {
        for ( int x = r.x; x < r.x + r.w; x++ ) {
            img.set( x, y, color( 0 ) );
        }
    }
}



class Rect {

    int x, y, w, h;
    
    Rect( int _x, int _y, int _w, int _h ) {
        x = _x;
        y = _y;
        w = _w;
        h = _h;
    }
    
    void print() {
        println( x + "\t" + y + "\t" + w + "\t" + h );
    }

}