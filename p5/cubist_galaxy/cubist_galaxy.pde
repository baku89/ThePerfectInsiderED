import java.util.Collections;

//---------------------------------------------
// config

String srcDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/cubist-galaxy/src";
String dstDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/cubist-galaxy/out";

String filename = "cell_h";

int duration = 6;

int inRand = 0;

int border = 1;

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
    frameRate(300);
    
    ArrayList< String > arguments = getArgs();
    
    if ( arguments.size() > 0 ) {
        filename = arguments.get( 0 );
    }
    
    loadAndSearch( srcDir + "/" + filename + ".png" );
    //loadAndSearch( srcDir + "/" + filename + "_2.png" );
    //loadAndSearch( srcDir + "/" + filename + "_3.png" );
    //loadAndSearch( srcDir + "/" + filename + "_4.png" );

    loadUI();
    uiRects = generateUIRects( rects );
    
    // shuffle
    Collections.shuffle( uiRects );
    
    // calc in frame and determine move rect
    fromRects = new Rect[ uiRects.size() ];
    toRects = new Rect[ uiRects.size() ];
    inFrames = new int[ uiRects.size() ];
    UIRect ur;
    
    Rect tr;
    
    for ( int i = 0; i < uiRects.size(); i++ ) {
        
        ur = uiRects.get( i );
        
        int cx = ur.x + int(ur.w / 2);
        int cy = ur.y + int(ur.h / 2);
        
        tr = new Rect(ur.x, ur.y, ur.w, ur.h);
        tr.w -= border * 2;
        tr.h -= border * 2;
        tr.x += border;
        tr.h += border;
        toRects[i] = tr;
        fromRects[i] = new Rect(cx, cy, 0, 0);  
        inFrames[i] = int(random(inRand));
    }
}


void draw() {
    
    background( 0 );
    noStroke();
    
    UIRect ur;
    float t;

    for ( int i = 0; i < uiRects.size(); i++ ) {
        
        ur = uiRects.get( i );
        
        if (inFrames[i] < frameCount) {
            // update
            t = min( float(frameCount-inFrames[i]-1) / duration, 1.0 );
            t = 1 - t;
            
            t = pow( t, 1 );
            t = 1 - t;
            
            ur.interpolate( t, fromRects[i], toRects[i] );
            ur.draw();
        }
        
        //break;
    }
    
    saveFrame( dstDir + "/" + filename + "/" + filename + "_####.png" );
    
    if ( frameCount > duration + inRand + 2 ) {
        exit();
    }
}