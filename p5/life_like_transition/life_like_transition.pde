//-------------------------------------------------------
// config

final String srcDir = "../../ca/life-like-generation/_src";
final String dstDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/life-like-generation";
final String seedDir= "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/life-like-generation/_seed";

final boolean isSave = true;

final int scale = 1;


final color yellow = #FFFB44;

final int mapEmpty       = 0;
final int mapGenerated   = -2;


//------------------------------
// C UI Generate

//String name = "x11b_frame-only_sq";
//String name = "x11b_radio";
//String name = "metapixel-galaxy_corner";
//String name = "x11b_button-c";
//String name = "x11_planet|planet";
//String name = "c_twin-button";
//String name = "x11b_close";
//String name = "c_saturn";
//String name = "stars-sq3";
//String name = "b-wire_1";
//String name = "neuron-core";
//String name = "x11b_button";
//String name = "1sb_c4_wire";


final float rate = 1;
final int maxLife = 5;
final int maxTempLife = 1;  
final int iterateCount = 2;
final int aliveDur = 10;
final boolean useSeedImg = false;
final boolean needsSeparatedSeed = true;
final int maxDur = 1000;

//final int ratio = 2;

int[] birthCond   = { 2, 3 };
int[] surviveCond = { 2, 3 };


//------------------------------
// C UI Generate Galaxy

//String name = "galaxy_lg";


//final float rate = 0.5;
//final int maxLife = 10;
//final int maxTempLife = 4;
//final int iterateCount = 1;
//final int aliveDur = 8;
//final boolean useSeedImg = true;
//final boolean needsSeparatedSeed = false;
//final int maxDur = 240;

////final int ratio = 2;

//int[] birthCond   = { 3 };
//int[] surviveCond = { 2, 3 };


//------------------------------
// C extending line

//String name = "c_extending-line_1";
//String name = "c_extending-line_2";
//String name = "c_extending-line_3";
//String name = "c_extending-line_4|a";
//String name = "c_extending-line_4|b";
//String name = "c_extending-line_5";
//String name = "c_extending-line_6|a";
//String name = "c_extending-line_6|b";
//String name = "c_extending-line_7";
//String name = "c_extending-line_8|a";
//String name = "c_extending-line_8|b";
//String name = "c_extending-line_9|a";
//String name = "c_extending-line_9|b";
//String name = "c_extending-line_10|a";;
//String name = "c_extending-line_10|b";

//final float rate = 0.1;
//final int maxLife = 3;
//final int maxTempLife = 1; 
//final int iterateCount = 4;
//final int aliveDur = 10;
//final boolean useSeedImg = true;
//final boolean needsSeparatedSeed = true;
//final int maxDur = 50;

////final int ratio = 2;

//int[] birthCond   = { 2, 3 };
//int[] surviveCond = { 2, 3 };

//-------------------------------------------------------
// main


// var

String[] arguments;

int cx, cy;

LifeLikeCA ca;

int[][] map;
int[][] curtDur;

PImage initImg, uiImg;
PImage renderImg;

File[] seedFiles;
PImage seedImg;

boolean isFinished;

int ratio;


void setup() {

    load();

    // draw
    frameRate( 10 );
    noSmooth();
    background( 0 );
}

void load() {

    // clean dst folder
    File dstFolder = new File( dstDir + "/" + name );
    deleteFile( dstFolder );

    if ( useSeedImg ) {
        File seedFolder = new File( seedDir + "/" + name );
        seedFiles = seedFolder.listFiles();
    }

    if ( needsSeparatedSeed ) {
        String initPath = srcDir + "/" + name + "_seed.png";
        String uiPath   = srcDir + "/" + name + ".png";
        initImg = loadImage( initPath );
        uiImg    = loadImage( uiPath );
    } else {
        String initPath = srcDir + "/" + name + ".png";
        initImg = loadImage( initPath );
        uiImg = createImage( initImg.width, initImg.height, ARGB );
    }

    // init ca
    
    renderImg = createImage( uiImg.width, uiImg.height, ARGB );

    ca = new LifeLikeCA( initImg, birthCond, surviveCond );
    
    ratio = renderImg.width / ca.width();
    
    println( ratio );

    if ( useSeedImg ) {
        ca.clear();
    }

    // init generated map
    map = new int[ ca.width() ][ ca.height() ];
    curtDur = new int[ ca.width() ][ ca.height() ];
    for ( int y = 0; y < ca.height(); y++ ) {
        for ( int x = 0; x < ca.width(); x++ ) {
            map[ x ][ y ] = mapEmpty;
        }
    }

    changeWindowSize( renderImg.width * scale, renderImg.height * scale );
}

void next() {
    
    if ( useSeedImg && frameCount - 1 < seedFiles.length ) {
        seedImg = loadImage( seedFiles[ frameCount - 1 ].getAbsolutePath() );
        ca.updateSeed( seedImg );
        
        for ( int y = 0; y < ca.height(); y++ ) {
            for ( int x = 0; x < ca.width(); x++ ) {
                if ( seedImg.get(x, y) == colorSeed && map[x][y] == mapEmpty ) {
                    map[x][y] = 1;
                }
            }
        }
    }
    
    ca.update();
    
    isFinished = true;
    
    for ( int y = 0; y < ca.height(); y++ ) {

        for ( int x = 0; x < ca.width(); x++ ) {
            
            if ( map[ x ][ y ] == mapGenerated ) {
                continue;
            }
            
            if ( xor( map[x][y] % 2 == 1, ca.field[x][y] ) ) {
                
                // if field changed
                map[x][y]++;
                curtDur[x][y] = 0;
                
            } else if ( map[x][y] != mapEmpty ) {
                
                // if not changed, increment 
                curtDur[x][y]++;
            }
            
            // detect if the cell have to become "generated"
            if ( map[x][y] != mapEmpty ) {
                
               if ( !ca.temp[x][y] ) {
                   if ( curtDur[x][y] == aliveDur || map[x][y] == maxLife * 2 ) {
                       map[x][y] = mapGenerated;
                   }
               } else {
                   if ( curtDur[x][y] == aliveDur || map[x][y] == maxTempLife * 2 ) {
                       map[x][y] = mapGenerated;
                   }
               }
            }
            
            if ( ca.space[x][y] && (map[x][y] == mapEmpty || map[x][y] % 2 == 1) ) {
                isFinished = false;
            }
        }
    }

    
}

void draw() {
    
    println( "frame: " +  (frameCount - 1) );

    for ( int i = 0; i < iterateCount; i++ ) {
        next();
    }

    noStroke();
    background( 0 );
    resetMatrix();
    scale( scale );

    color c;

    for ( int y = 0; y < ca.height(); y++ ) {
        for ( int x = 0; x < ca.width(); x++ ) {
            
            for ( int sy = 0; sy < ratio; sy++ ) {
                for ( int sx = 0; sx < ratio; sx++ ) {
                    
                    if ( map[x][y] == mapEmpty ) {
                      c = 0x0;
                    } else if ( map[x][y] % 2 == 0 ) { // dead & pseudo dead
                      c = uiImg.get( x*ratio + sx, y*ratio + sy );
                    } else {
                      c = yellow;
                    }
                    
                    renderImg.set( x*ratio + sx, y*ratio + sy, c );
                }
            }
        }
    }
    
    //tint( 0, 0, 100 );
    //image( initImg, 0, 0 );  
    
    //tint( 255 );

    image( renderImg, 0, 0 );

    if ( isSave ) {
        renderImg.save( dstDir + "/" + name + "/" + name + "_" + String.format("%04d", frameCount - 1) + ".png" );
    }

    if ( isFinished || frameCount == maxDur ) {
       println( "duration:" + frameCount );
       exit();
    }
}