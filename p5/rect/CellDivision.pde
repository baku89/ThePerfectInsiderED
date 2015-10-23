

float gaussianRange = 4;
float detail = 0.05;
int minGen = 3;


PGraphics divideCell( int w, int h, int minWidth ) {

    ArrayList< Cell > cells = new ArrayList< Cell >();
    ArrayList< Cell > divided = new ArrayList< Cell >();

    float tx, ty;
    boolean proceed;
    int px, py;
    Cell c;
    Cell[] nc = new Cell[ 4 ];
    PGraphics g = createGraphics( w, h );

    cells.add( new Cell( 0, 0, w, h ) );

    while ( cells.size() > 0 ) {

        println( "start" + cells.get(0).generation );

        for ( int i = cells.size() - 1; i >= 0; i-- ) {

            c = cells.get( i );

            //c.print();
            //println(" -> ");

            // divide vertical
            tx = ( c.w / 2 - minWidth ) / gaussianRange;
            px = int( c.w / 2 + randomGaussian() * tx );
            
            ty = ( c.h / 2 - minWidth ) / gaussianRange;
            py = int( c.h / 2 + randomGaussian() * ty );

            // 0 1
            // 2 3
            nc[0] = new Cell( c.x, c.y, px, py );
            nc[1] = new Cell( c.x + px, c.y, c.w - px, py );
            nc[2] = new Cell( c.x, c.y + py, px, c.h - py );
            nc[3] = new Cell( c.x + px, c.y + py, c.w - px, c.h - py );
            
            for ( int j = 0; j < nc.length; j++ ) {
                
                nc[j].generation = c.generation + 1;
                
                if ( nc[j].generation < minGen ) {
                    
                    proceed = true;
                
                } else {
                
                    proceed = random(1) > detail;
                
                }
            
                if ( nc[j].w >= minWidth * 2 && nc[j].h >= minWidth * 2 && proceed ) {
                    cells.add( nc[j] );
                } else {
                    divided.add( nc[j] );
                }
            }
            
            cells.remove( i );
        }

        g.beginDraw();
        g.background( 0 );
        g.noStroke();

        for ( int i = 0; i < cells.size(); i++ ) {

            c = cells.get( i );
            g.fill( c.fill );
            g.rect( c.x, c.y, c.w, c.h );
        }

        g.endDraw();

        image( g, 0, 0 );
    }

    // draw

    g.beginDraw();
    g.background( 0 );
    g.noStroke();

    for ( int i = 0; i < divided.size(); i++ ) {

        c = divided.get( i );
        g.fill( c.fill );
        g.rect( c.x, c.y, c.w, c.h );
    }

    g.endDraw();

    return g;
}


class Cell {

    int x, y, w, h;
    color fill;
    int generation;

    Cell( int _x, int _y, int _w, int _h ) {

        this.x = _x;
        this.y = _y;
        this.w = _w;
        this.h = _h;
        this.fill = color( random(255), random(255), random(255) );
        this.generation = 0;
    }

    void print() {

        println( this.x + "\t" + this.y + "\t" + this.w + "\t" + this.h );
    }
}