final color colorAlive = color( 200 );
final color colorDead  = color( 100 );

final color colorSeed = color( 255, 0, 0 );
final color colorEmpty= color( 0 );
final color colorWall = color( 0, 255, 0 );
final color colorTemp = color( 0, 0, 255 );

class LifeLikeCA
{
    //PImage field, buff;
    
    boolean[][] field, buff;
    boolean[][] space, seed, wall, temp;
    boolean[] birth = new boolean[ 9 ],
              survive = new boolean[ 9 ];
              
    int[][] neighborsOffset = {
        {  0, -1 },
        { +1, -1 },
        { +1,  0 },
        { +1, +1 },
        {  0, +1 },
        { -1, +1 },
        { -1,  0 },
        { -1, -1 }
    };
    
    int fw, fh;
    int spaceCount;
    int gen = 0;
    
    LifeLikeCA( PImage _initCond, int[] _birthCond, int[] _surviveCond ) {
        
        fw = _initCond.width;
        fh = _initCond.height;
        
        // init field
        field = new boolean[ fw ][ fh ];
        buff  = new boolean[ fw ][ fh ];
        
        space = new boolean[ fw ][ fh ];
        seed  = new boolean[ fw ][ fh ];
        wall  = new boolean[ fw ][ fh ];
        temp  = new boolean[ fw ][ fh ];
        
        color c;
        
        for ( int y = 0; y < fh; y++ ) {
            for ( int x = 0; x < fw; x++ ) {
                
                c = _initCond.get( x, y );
                
                field[ x ][ y ] = c == colorSeed ? random(1) <= rate : false;
                // init attr
                space[x][y] = c != colorEmpty;
                
                seed[ x ][ y ] = c == colorSeed;
                wall[ x ][ y ] = c == colorWall;
                temp[ x ][ y ] = c == colorTemp;
                
                if ( x == 5 && y == 3 ) {
                    println( seed[x][y] );
                    println( red(c), green(c), blue(c) );
                }
                
            }
        }
        
        // init rules
        for ( int i = 0; i < 8; i++ ) {
            survive[i] = false;
            birth[i] = false;
        }
    
        for ( int i = 0; i < _surviveCond.length; i++ ) {
            survive[ _surviveCond[i] ] = true;
        }
        for ( int i = 0; i < _birthCond.length; i++ ) {
            birth[ _birthCond[i] ] = true;
        }
    }
    
    void clear() {
        
        for ( int y = 0; y < fh; y++ ) {
            for ( int x = 0; x < fw; x++ ) {
                field[ x ][ y ] = false;
            }
        }
    }
    
    void updateSeed( PImage seedImg ) {
        
        //int seedCount = 0;
    
        color c;
        for ( int y = 0; y < fh; y++ ) {
            for ( int x = 0; x < fw; x++ ) {
                c = seedImg.get( x, y );
                seed[ x ][ y ] = c == colorSeed;
                field[ x ][ y ] |= c == colorSeed; 
            }
        }
    }
    
    
    void draw() {
    
        int x, y;
        
        noStroke();
        
        for ( y = 0; y < fh; y++ ) {
            for ( x = 0; x < fw; x++ ) {
                fill( field[ x ][ y ] ? colorAlive : colorDead );
                rect( x, y, 1, 1 );
            }
        }
    
    }
    
    void save( String name ) {
        //field.save( name );
    }
    
    int width() {
        return fw;
    }
    
    int height() {
        return fh;
    }
    
    void update() {
        
        int x, y;
        int alives;
        
        for ( y = 0; y < fh; y++ ) {
            for (x = 0; x < fw; x++ ) {
                buff[ x ][ y ] = field[ x ][ y ];
            }
        }
    
        for ( y = 0; y < fh; y++ ) {
            for ( x = 0; x < fw; x++ ) {
                if ( space[ x ][ y ] ) {
                    if ( wall[ x ][ y ] ) {
                        wall[ x ][ y ] = !canDestroyWall( x, y );
                    } else {
                        alives = getAliveCount( x, y ); 
                        field[ x ][ y ] = buff[ x ][ y ] ? survive[ alives ] : birth[ alives ];
                    }
                }
            }
        }
        
        gen++;
    }
    
    boolean canDestroyWall( int x, int y ) {
        
        int ox, oy;
        
        for ( int i = 0; i < neighborsOffset.length; i++ ) {
            ox = x + neighborsOffset[i][0];
            oy = y + neighborsOffset[i][1];
            if ( ox < 0 || fw <= ox || oy < 0 || fh <= oy ) {
                continue;
            }
            if ( !seed[ ox ][ oy ] && buff[ ox ][ oy ] ) {
                return true;
            }
        }
        
        return false;
    }
    
    int getAliveCount( int x, int y ) {
    
        int neighbors = 0;
    
        neighbors += getStatus(  x , y-1 ) ? 1 : 0;
        neighbors += getStatus( x+1, y-1 ) ? 1 : 0;
        neighbors += getStatus( x+1,  y  ) ? 1 : 0;
        neighbors += getStatus( x+1, y+1 ) ? 1 : 0;
        neighbors += getStatus(  x , y+1 ) ? 1 : 0;
        neighbors += getStatus( x-1, y+1 ) ? 1 : 0;
        neighbors += getStatus( x-1,  y  ) ? 1 : 0;
        neighbors += getStatus( x-1, y-1 ) ? 1 : 0;
    
        return neighbors;
    }
    
    boolean getStatus( int x, int y ) {
        if ( x < 0 || fw <= x || y < 0 || fh <= y ) {
            return false;
        } else {
            return buff[ x ][ y ];
        }
    }
    
    
}