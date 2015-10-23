//-------------------------------------------------------
// config

final String dstName = "out/####.png";
final String srcName = "../_data/init-cond.png";

final color colorAlive = color( 255 );
final color colorDead = color( 0 );

final boolean isSave = true;

final int scale = 3;

//-------------------------------------------------------
// main

LifeLikeCA ca;

void setup() {
    
    // init ca
    //PImage initCond = loadImage( srcName );
    PImage initCond = createImage(256, 256, RGB);
    
    int w = 6;
    int c = 127;
    for ( int y = -w/2; y <= w/2; y++) {
        for ( int x = -w/2; x <= w/2; x++) {
            if (random(1) < 0.5) {
                initCond.set(x+c, y+c, colorAlive);
            }
        }
    }
    
    setupLifeLikeRules();
    ca = new LifeLikeCA( initCond );
    
    // setup
    //frameRate(1);
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