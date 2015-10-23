//-------------------------------------------------------
// config

final color colorAlive = color( 255 );
final color colorDead = color( 0 );

final String dstName = "out/####.png";
final String srcName = "../_dat/init-cond.png";
final boolean isSave = true;
final int scale = 1;

//-------------------------------------------------------
// main

LifeLikeCA ca;

void setup() {
    
    // init ca
    PImage initCond = loadImage( srcName );
    setupLifeLikeRules();
    ca = new LifeLikeCA( initCond );
    
    // setup
    noSmooth();
    changeWindowSize( initCond.width * scale, initCond.height * scale );
}

void draw() {
    
    background( 0 );
    resetMatrix();
    scale( scale );
    
    ca.draw( 0, 0 );
    ca.update();
    
    if ( isSave ) {
        saveFrame( dstName );
    }
}