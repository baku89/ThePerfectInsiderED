void changeWindowSize(int w, int h) {

    surface.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    size(w, h);
    
}

ArrayList< String > getArgs() {
    
    ArrayList< String > arguments = new ArrayList< String >();
    
    try {
        for ( int i = 0; i < args.length; i++ ) {
            arguments.add( args[i] );
        }
    } catch ( Exception e ) {
        return arguments;
    }
    
    return arguments;
}

String getFileName( String path ) {
    
    String filename = new File( path ).getName();
    int point = filename.lastIndexOf(".");
    
    if (point != -1) {
        return filename.substring(0, point);
    } 
    
    return filename;
}

String getDirectory( String path ) {
    
    return new File( path ).getParent();
}

class Rect {

    int x, y, w, h;
    
    Rect() {
        x = y = w = h = 0;
    }
    
    Rect( int _x, int _y, int _w, int _h ) {
        x = _x;
        y = _y;
        w = _w;
        h = _h;
    }
    
    void print() {
        println( x + "\t" + y + "\t" + w + "\t" + h );
    }
    
    int right() {
        return x + w - 1;
    }
    
    int bottom() {
        return y + h - 1;
    }
    
    float aspect() {
        return float( w ) / float( h );
    }
    
    void interpolate( float t, Rect a, Rect b ) {
        
        x = int( a.x + ( b.x - a.x ) * t );
        y = int( a.y + ( b.y - a.y ) * t );
        w = int( a.w + ( b.w - a.w ) * t );
        h = int( a.h + ( b.h - a.h ) * t );
    }
    
    void draw() {
        rect( x, y, w, h );
    }
    
    void copy( Rect r ) {
        x = r.x;
        y = r.y;
        w = r.w;
        h = r.h;
    }
}

class UIRect extends Rect {
    
    UI ui;

    UIRect( UI ui, Rect r ) {
        
        super( r.x, r.y, r.w, r.h );
        this.ui = ui;
    }
    
    void draw() {
        
        ui.draw( this );
    }

}