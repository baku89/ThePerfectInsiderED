class Point {
    
    int x, y;
    
    Point( int _x, int _y ) {
        x = _x;
        y = _y;
    }
    
    int index() {
        return x + y * width;
    }
}