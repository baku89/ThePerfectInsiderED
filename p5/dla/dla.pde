//---------------------------------------------
// config

String weightMapPath = "../_dat/dla-weight-map.png";
String destDir = "out"; 

String filename = "dla_neumann_cell_large";

int particleCount = 10000;

//---------------------------------------------
// main

PImage weightMap;
int exportedCount = 0;

ArrayList< Particle >  particles = new ArrayList< Particle >();
boolean[] field;

Point seed;

void setup() {
    size(10, 10, P2D);
    noSmooth();
    
    weightMap = loadImage(weightMapPath);
    
    changeWindowSize( weightMap.width, weightMap.height );
    
    File[] existsImages = listImageFiles(destDir);
    exportedCount = existsImages.length - 1;
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
        
    String path = destDir + "/" + filename + "/" + filename + "_" + String.format( "%04d", exportedCount++ ) + ".png";
    println( "saved: " + path );
    saveFrame( path );
}