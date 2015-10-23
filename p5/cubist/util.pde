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