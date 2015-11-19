//----------------------------------------
// config

String srcDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/filling/_src/";
String destDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/filling";
String filename = "squares_qr_for_filling";

int duration = 15;
int startRand = 3;
int minLen = 10;


//----------------------------------------
// main


int[][] dirs;

//int N = 0b1,
//    E = 0b10,
//    S = 0b100,
//    W = 0b1000,
//    X = 0b10000,  // undefined
//    V = 0b100000; // empty

PImage shape;

int IE = 0, IS = 1, IW = 2, IN = 3;
int E = 0b1,
    S = 0b10,
    W = 0b100,
    N = 0b1000;

boolean[][] filled;

int[] dx = { +1,  0, -1,  0 };
int[] dy = {  0, +1,  0, -1 };

ArrayList< Chain > chain;

ArrayList< Frontier > frontier = new ArrayList< Frontier >();

void setup() {
    
    shape = loadImage( srcDir + "/" + filename + ".png" );
    
    changeWindowSize( shape.width, shape.height );
    
    filled = new boolean[ shape.width ][ shape.height ];
    
    for ( int y = 0; y < shape.height; y++ ) {
       for ( int x = 0; x < shape.width; x++ ) {
           filled[x][y] = shape.get( x, y ) == color( 0 );
       }   
    }
    
    chain = new ArrayList< Chain >();
    
    int x = 0, y = 0, dir = 0, d = 0;
    
    while ( true ) {
    
       // find start point
       outerloop:
       for ( y = 0; y < shape.height; y++ ) {
           for ( x = 0; x < shape.width; x++ ) {
               if ( !filled[x][y] ) break outerloop;
           }
       }
       
       if ( x == shape.width || y == shape.width ) break;
        
       dir = IE;
        
       chain.add( new Chain( x, y, true ) );
       filled[x][y] = true;
       
       while( true ) {
           
           for ( int i = 0; i < 4; i++ ) {
               d = (dir + 3 + i ) % 4;
               if ( !isFilled( x + dx[d], y + dy[d] ) ) break;
           }
            
           if ( (d+2) % 4 == dir ) { // dead end
               break;
           }
            
           dir = d;
            
           x += dx[ dir ];
           y += dy[ dir ];
            
           chain.add( new Chain( x, y, false ) );
           filled[x][y] = true;
       }
    }
    
    int i = 0;
    while ( i < chain.size() ) {
        
        Frontier f = new Frontier();
        f.start = i;
        f.inTime = int( random( 1, startRand+1 ) );
        f.end = i + duration - f.inTime - 1;
        
        if ( f.end >= chain.size() ) {
            f.end = chain.size() - 1;
        }
        
        for ( int j = i+1; j < f.end; j++ ) {
            
            if ( chain.get(j).begin ) {
                f.end = j - 1;
            }
        }
        
        f.setRange();
        
        frontier.add( f );
        
        i = f.end + 1;
    }
    
    passed = new boolean[ shape.width ][ shape.height ];
    
    for (y = 0; y < shape.height; y++ ) {
        for ( x = 0; x < shape.width; x++ ) {
            passed[x][y] = false;
        }
    }
    
    noStroke();
    background( 0 );
    
}

boolean[][] passed;

void draw() {
    
    for ( int y = 0; y < shape.height; y++ ) {
        for ( int x = 0; x < shape.width; x++ ) {
            if ( passed[x][y] ) {
                fill( 0, 0, 255 );
                rect( x, y, 1, 1 );
            }
        }
    }
    
    Frontier f;
    Chain c;
    
    if ( frameCount > 1 ) {
        for ( int i = frontier.size() - 1; i >= 0; i-- ) {
            
           f = frontier.get( i );
           c = chain.get( f.index );
            
           if ( frameCount - 1 >= f.inTime ) {
               fill( 255, 0, 0 );
               rect( c.x, c.y, 1, 1 );
           }
            
           c.passed = true;
           passed[ c.x ][ c.y ] = true;
        }
    }
    
    
    for ( int i = frontier.size() - 1; i >= 0; i-- ) {
        
       f = frontier.get( i );
       c = chain.get( f.index );
        
       if ( frameCount - 1 >= f.inTime ) {
           
           if ( !f.next() ) {
               frontier.remove( i );
           }
       }
    }
    
    saveFrame( destDir + "/filling_" + filename + "/filling_" + filename + "_####.png" );
    
    if (frameCount == duration + 2 ) {
       println( "end", frameCount );
       exit();
    }
    
}

boolean isFilled( int x, int y ) {
    if ( x < 0 || y < 0 || x >= shape.width || y >= shape.height )
        return true;
    
    return filled[x][y];
}

class Frontier {
    int index, dir, inTime, start, end;
    
    void setRange() {
        
        dir = int(random(2)) * 2 - 1;
        if ( dir == 1 ) {
            index = start;
        } else {
            index = end;
        }
    }
    
    boolean next() {
        index += dir;
        return start <= index && index <= end;
    }
}


class Chain {
    
    int x, y;
    boolean begin;
    boolean passed = false;
    
    Chain( int _x, int _y, boolean _begin ) {
        x = _x;
        y = _y;
        begin = _begin;
    }
    
}