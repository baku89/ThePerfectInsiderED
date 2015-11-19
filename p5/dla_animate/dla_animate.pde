import processing.video.*;

//---------------------------------------------
// config

String mapDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/dla-net";
String dstDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/root";

String filename = "root";

boolean isSave = true;

//---------------------------------------------
// main

PImage map, field, buff;

ArrayList< Point > frontier = new ArrayList< Point >();

color colorSeed = color( 255, 255, 0 );
color colorRoot = color( 255, 0, 0 );
color colorFrontier = color( 0, 255, 255 );
color colorReproduced = color( 0, 0, 255 );

int nlen = 4;
int[] nx = {  0, +1,  0, -1 };
int[] ny = { -1,  0, +1,  0 };

// 8 
//int nlen = 8;
//int[] nx = {  0, +1, +1, +1,  0, -1, -1, -1 };
//int[] ny = { -1, -1,  0, +1, +1, +1,  0, -1 };

void setup() {
    noSmooth();
    frameRate( 24 );
    
    map = loadImage( mapDir + "/" + filename + ".png" );
    
    changeWindowSize( map.width, map.height );
    
    
    field = createImage( width, height, RGB );
    buff  = createImage( width, height, RGB );
    
    PImage uiImg = subdivideToUI();
    uiImg.save( dstDir + "/" + filename + "_ui.png" );
    
    // search seed
    color c;
    int x, y;
    
    for ( y = 0; y < height; y++ ) {
        for ( x = 0; x < width; x++ ) {
        
           c = map.get( x, y );
           
           if ( c == colorSeed ) {
               field.set( x, y, colorFrontier );
           }
           if ( c == colorRoot ) {
               field.set( x, y, colorRoot ); 
           }
        }
    }
    
    //exit();
}

void draw() {
    
    if ( frameCount == 1 && isSave ) {
        image( field, 0, 0 );
        saveFrame( dstDir + "/" + filename + "/" + filename + "_0000" );
    }
    
    
    // update
    int x, y, frontierCount = 0;
    color c;
    
    buff.copy( field, 0, 0, width, height, 0, 0, width, height );
    
    for ( y = 0; y < height; y++ ) {
        for ( x = 0; x < width; x++ ) {
            
            c = buff.get( x, y );
            
            if ( c == colorFrontier ) {
            
                for ( int i = 0; i < nlen; i++ ) {
                
                    if( field.get( x + nx[i], y + ny[i] ) == colorRoot ) {
                        field.set( x + nx[i], y + ny[i], colorFrontier );
                        frontierCount++;
                    }
                }
                
                field.set( x, y, colorReproduced );
            }
        }
    }
    
    background( 0 );
    
    
    // draw current image and save
    image( field, 0, 0 );
    
    // and save
    if ( isSave ) {
        
        saveFrame( dstDir + "/" + filename + "/" + filename + "_####" );
    }
    
    if ( frontierCount == 0 ) {
        exit();
    }   
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
    
    int neighbor( int _x, int _y ) {
        
        int nx = x + _x,
            ny = x + _y;
            
        if ( nx < 0 || nx >= width || ny < 0 || ny >= height ) {
            return -1;
        }
        
        return ny * width + nx;
    }
}