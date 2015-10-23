//---------------------------------------------
// config

String mapPath = "/Volumes/MugiRAID1/Works/2015/13_0xff/ae/volonoi_cell_large/volonoi_cell_large_2.png";
String dstDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/dla"; 

String filename = "dla_neumann_cell_large";

int particleCount = 10000;

//---------------------------------------------
// main

PImage map, gradMap;
int exportedCount = 0;

ArrayList< Particle >  particles = new ArrayList< Particle >();
boolean[] field;

Point seed;

void setup() {
    size(10, 10, P2D);
    noSmooth();
    frameRate( 1000 );
    
    map = loadImage( mapPath );
    
    changeWindowSize( map.width, map.height );
    
    File dir = new File( dstDir + "/" + filename );
    String[] list = dir.list();
    exportedCount = list.length - 1;
    println( exportedCount );
  
    
    // create an array that stores the position of our particles
    field = new boolean[width * height];
    
  
    // make particles
    for(int i=0; i < particleCount; i++) {
        particles.add( new Particle( 10 ) );
    }
    
    // make seed
    for ( int i = 0; i < 40; i++ ) {
        Particle seed = new Particle( 220 );
        seed.isSeed = true;
        seed.stuck = true;
        particles.add( seed );
        
        field[seed.x + seed.y * width] = true;
    }
}


void draw() {
    
        
    // udapte dla
    background( 0 ); 
    noFill();
    noStroke();
    
    //image( map, 0, 0 );
    
    Particle p;
    
    for(int i = 0, l = particles.size(); i < l; i++) {
        
        p = particles.get( i );
        p.update();
        
        if ( p.stuck ) {
            
            if ( p.isSeed ) {
                fill( 255, 255, 0 );
            } else {
                fill( 255, 0, 0 );
            }
        
        } else {
            fill( 0, 0, 255 );
        }
        
        rect( p.x, p.y, 1, 1 );
     }
}

void keyPressed() {
        
    String path = dstDir + "/" + filename + "/" + filename + "_" + String.format( "%04d", exportedCount++ ) + ".png";
    println( "saved: " + path );
    saveFrame( path );
}

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