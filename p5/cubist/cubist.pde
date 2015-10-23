import java.util.Collections;
import ffff.*;

//---------------------------------------------
// config

String srcDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/cubist/src";
String dstDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/cubist/out";

String filename = "cell_a_4";

int duration = 24;

int inRand = 2;

int moveWidth = 600;
float moveAmpOpposite = 0.7;

float moveRand = 0.5; 

//---------------------------------------------
// main

PImage src;

boolean[][] filled; 

ArrayList< Rect > rects = new ArrayList< Rect >();
ArrayList< UIRect > uiRects = new ArrayList< UIRect >();

int[] inFrames;
Rect[] fromRects, toRects;


void setup() {

    noSmooth();
    
    ArrayList< String > arguments = getArgs();
    
    if ( arguments.size() > 0 ) {
        
        filename = arguments.get( 0 );
    }
    

    src = loadImage( srcDir + "/" + filename + ".png" );

    changeWindowSize( src.width, src.height );

    filled = new boolean[ width ][ height ];

    // initialize fiiled
    for ( int y = 0; y < height; y++ ) {
        for ( int x = 0; x < width; x++ ) {
            filled[x][y] = src.get( x, y ) == color( 0 );
        }
    }

    // search
    searchRect( 1.5, 20 );
    searchRect( max( width, height ), 3 );

    loadUI();
    uiRects = generateUIRects( rects );
    
    // shuffle
    Collections.shuffle( uiRects );
    
    // calc in frame and determine move rect
    inFrames = new int[ uiRects.size() ];
    fromRects = new Rect[ uiRects.size() ];
    toRects = new Rect[ uiRects.size() ];
    
    UIRect ur;
    
    for ( int i = 0; i < uiRects.size(); i++ ) {
        
        ur = uiRects.get( i );
        
        int dir = int( random( 4 ) );
        int mfw = int( 600 * (1 + random( moveRand ) ) );   // move width ( fromt )
        int mow = int( mfw * moveAmpOpposite );		  // move width ( opposite )
        
        toRects[i] = new Rect( ur.x, ur.y, ur.w, ur.h );
        inFrames[i] = int( random( inRand ) );
        
        if ( dir == 0 ) { // N
            
            fromRects[i] = new Rect( ur.x, ur.y - mfw, ur.w, ur.h + mfw - mow );
            
        } else if ( dir == 1 ) { // E
        
            fromRects[i] = new Rect( ur.x + mow, ur.y, ur.w + mfw - mow, ur.h );
            
        } else if ( dir == 2 ) { // S
        
            fromRects[i] = new Rect( ur.x, ur.y + mow, ur.w, ur.h + mfw - mow );
            
        } else if ( dir == 3 ) { // W
        
            fromRects[i] = new Rect( ur.x - mfw, ur.y, ur.w + mfw - mow, ur.h );
            
        }   
    }
}


void draw() {
    
    // save Color map
    if ( frameCount == 1 ) {
        background( 0 );
        noStroke();
        
        for ( int i = 0; i < uiRects.size(); i++ ) {
            fill( random(255), random(255), random(255) );
            rect( uiRects.get( i ).x, uiRects.get( i ).y, uiRects.get( i ).w, uiRects.get( i ).h );
        }
        
        saveFrame( dstDir + "/" + filename + "/" + filename + "_map.png" );
    }
    
    background( 0 );
    noStroke();
    
    UIRect ur;
    float t;

    for ( int i = 0; i < uiRects.size(); i++ ) {
        
        ur = uiRects.get( i );
        
        if ( inFrames[i] < frameCount ) {
            
            // update
            t = min( float( frameCount - inFrames[i] - 1) / duration, 1.0 );
            t = 1 - t;
            
            t = pow( t, 3 );
            t = 1 - t;
            
            ur.interpolate( t, fromRects[i], toRects[i] );
            ur.draw();
        }
        
        //break;
    }
    
    saveFrame( dstDir + "/" + filename + "/" + filename + "_####.png" );
    
    if ( frameCount > duration + 2 ) {
        exit();
    }
}