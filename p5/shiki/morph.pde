int DIR_STATIC = -1;

class Morph {

    int cellSize;
    int w, h;
    int interval = 3;
    float gamma = 0.7; // 1: linear

    PImage curtImg, prevImg;
    PGraphics pg;
    
    int[][] dirs;

    // var
    int counter = 0;
    boolean[] flgNbr = new boolean[ 8 ];
    ArrayList< Integer > sides = new ArrayList< Integer >();

    float t;
    int i, x, y, dir, nx, ny;
    color c, pc;

    // const
    PVector[] neighborVec = {
        new PVector(  0, -1 ), 
        new PVector( +1, -1 ), 
        new PVector( +1, 0 ), 
        new PVector( +1, +1 ), 
        new PVector(  0, +1 ), 
        new PVector( -1, +1 ), 
        new PVector( -1, 0 ), 
        new PVector( -1, -1 )
    };

    Morph( int _w, int _h, int _cellSize ) {
        w = _w;
        h = _h;
        cellSize = _cellSize;

        curtImg = createImage( w, h, RGB );
        prevImg = createImage( w, h, RGB );
        dirs = new int[ w ][ h ];
        
        pg = createGraphics( getWidth(), getHeight() );
    }

    int getWidth() {
        return w * cellSize;
    }

    int getHeight() {
        return h * cellSize;
    }
    
    PImage getImage() {
        return pg.get();
    }

    boolean availableNewFrame() {
        return counter == 0;
    }

    void addFrame( PImage img ) {

        prevImg.copy( curtImg, 0, 0, w, h, 0, 0, w, h );
        curtImg.copy( img, 0, 0, w, h, 0, 0, w, h );

        // diff frame

        for ( y = 0; y < h; y++ ) {
            for ( x = 0; x < w; x++ ) {

                c = curtImg.get( x, y );
                pc = prevImg.get( x, y );

                // detect changed pix
                if ( c != pc ) {
                    
                    dirs[ x ][ y ] = getDir( x, y );
                    
                } else {

                    dirs[ x ][ y ] = DIR_STATIC;
                }
            }
        }
    }

    void update() {

        t = float( counter ) / interval;
        t = (float) Math.pow( t, gamma );

        // animation
        pg.beginDraw();
        pg.resetMatrix();
        pg.noStroke();
        pg.noSmooth();

        pg.background( 0 );
        pg.image( prevImg, 0, 0, getWidth(), getHeight() );

        for ( y = 0; y < h; y++ ) {
           for ( x = 0; x < w; x++ ) {

               dir = dirs[ x ][ y ];

               if ( dir != DIR_STATIC ) {

                   pg.resetMatrix();
                   pg.scale( cellSize );
                   pg.translate( x, y );

                   // normal
                   pg.fill( curtImg.get( x, y ) );

                   if ( dir == 0 )         pg.rect( 0, 0, 1, t );
                   else if ( dir == 2 )    pg.rect( 1-t, 0, t, 1 );
                   else if ( dir == 4 )    pg.rect( 0, 1-t, 1, t );
                   else if ( dir == 6 )    pg.rect( 0, 0, t, 1 );

                   else if ( dir == 1 )    pg.rect( 1-t, 0, t, t );
                   else if ( dir == 3 )    pg.rect( 1-t, 1-t, t, t );
                   else if ( dir == 5 )    pg.rect( 1-t, 0, t, t );
                   else if ( dir == 7 )    pg.rect( 0, 0, t, t );

                   else if ( dir == 9 )    pg.rect( (1-t)/2, (1-t)/2, t, t );
               }
           }
        }
        pg.endDraw();


        // increment counter
        counter = ( counter + 1 ) % interval;
    }

    void draw( int x, int y ) {

        image( pg, x, y );
    }


    int getDir( int x, int y ) {


        int dir = 9; // koritsu

        // search neighbor pixels
        for ( i = 0; i < neighborVec.length; i++ ) {

            nx = x + int( neighborVec[i].x );
            ny = y + int( neighborVec[i].y );

            flgNbr[i] = prevImg.get( nx, ny ) == c;
        }

        sides.clear();

        for ( i = 0; i < flgNbr.length; i+= 2 ) {
            if ( flgNbr[i] ) {
                sides.add( i );
            }
        }

        if ( sides.size() > 0 ) {

            int n = int( random( 0, sides.size() ) );
            dir = sides.get(n);
        } else {

            dir = int( random(0, 4) ) * 2;


            // radial uv
            /*
            float u = x / float( mapW );
             float v = y / float( mapH );
             
             if ( v > u ) {
             if ( v > -u + 1 ) {
             dir = 0;
             } else {
             dir = 2;
             }
             } else {
             if ( v > -u + 1 ) {
             dir = 6;
             } else {
             dir = 4;
             }
             }*/
        }

        return dir;
    }
}