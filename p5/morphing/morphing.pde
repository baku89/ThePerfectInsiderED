//-------------------------------------------------------
// Settings

String gollyFolder = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/crop";
String dstFolder = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/anim";

//String name = "city_base_using";


int cellW = 8;
int frameDur = 6;


// last-shiki
//int cellW = 3; // 1024 512
//int cellW = 8; // 256 128
//int frameDur = 3;

float gamma = 1;

//-------------------------------------------------------
// Processing

File[] files = null;
int index = 0;
int frame = 0;
float t = 0;

int i, x, y, nx, ny;
PImage img, prevImg, changedImg;
color c, pc, dir;

int mapW, mapH;

ArrayList<Integer> sides = new ArrayList<Integer>();
ArrayList<Integer> corners = new ArrayList<Integer>();

boolean[] flgNbr = { false, false, false, false, false, false, false, false };

PVector[] neighborVec = {
    new PVector(  0, -1 ),
    new PVector( +1, -1 ),
    new PVector( +1,  0 ),
    new PVector( +1, +1 ),
    new PVector(  0, +1 ),
    new PVector( -1, +1 ),
    new PVector( -1,  0 ),
    new PVector( -1, -1 )
};


void setup() {
    
    frameRate( 24 );
    noSmooth();

   String folder = gollyFolder + "/" + name + "_crop";
   files = listFiles( folder );

   img = loadImage( files[0].getAbsolutePath() );
   mapW = img.width;
   mapH = img.height;
   
   changedImg = createImage( mapW, mapH, ARGB );

   surface.setSize( mapW * cellW, mapH * cellW );
   noStroke();
   
   index++;
}

void draw() {
    
    background( 0 );
    
    if ( frame == 0 ) {
    
        println( "loading.." + index );
        img = loadImage( files[index].getAbsolutePath() );
        prevImg = loadImage( files[index-1].getAbsolutePath() );
   
        for ( y = 0; y < mapH; y++ ) {
            for ( x = 0; x < mapW; x++ ) {
                
                c = img.get( x, y );
                pc = prevImg.get( x, y );
                
                // detect changed pix
                if ( c != pc ) {
                    
                    dir = getDir( x, y );
                    
                    changedImg.set( x, y, color( c, dir + 1 ) );
                
                } else {
                    
                    changedImg.set( x, y, 0x00000000 );
                 
                }
            }
        }
        
        if ( ++index == files.length ) {
            exit();
        }
 
    }
    
    // draw animation
    t = float(frame) / frameDur;
    
    t = (float) Math.pow( t, gamma );

    //tint( 128 );
    
    image( prevImg, 0, 0, mapW * cellW, mapH * cellW );
    
    for ( y = 0; y < mapH; y++ ) {
        for ( x = 0; x < mapW; x++ ) {
            
            c = changedImg.get(x, y);
            dir = int( alpha(c) ) - 1;
            
            if ( alpha(c) > 0 ) {
                
                resetMatrix();
                scale( cellW );
                translate( x, y );
                
                // normal
                fill( color( red(c), green(c), blue(c) ) );
                
                
                // lifegame start
                /*if ( red(c) > 220 ) { // born
                
                    fill( 255, 0, 0 );
                
                } else { // die
                    
                    fill( 0, 255, 0);
                    rect( 0, 0, 1, 1 );
                    fill( 0, 0, 0);
                }  */
                
                
                if ( dir == 0 )         rect( 0, 0, 1, t );
                else if ( dir == 2 )    rect( 1-t, 0, t, 1 );
                else if ( dir == 4 )    rect( 0, 1-t, 1, t );
                else if ( dir == 6 )    rect( 0, 0, t, 1 );
                
                else if ( dir == 1 )    rect( 1-t, 0, t, t );
                else if ( dir == 3 )    rect( 1-t, 1-t, t, t );
                else if ( dir == 5 )    rect( 1-t, 0, t, t );
                else if ( dir == 7 )    rect( 0, 0, t, t );
                
                else if ( dir == 9 )    rect( (1-t)/2, (1-t)/2, t, t );
                
            } else {
            
            }
        }
    }
    
    saveFrame( dstFolder + "/" + name + "_anim/" + name + "_anim_########.png" );
    
    
    // next
    frame = ( frame + 1 ) % frameDur;
}



int getDir( int x, int y ) {
    
    int dir = 9; // koritsu
    
    // search neighbor pixels
    for ( i = 0; i < neighborVec.length; i++ ) {
        
        nx = x + int( neighborVec[i].x );
        ny = y + int( neighborVec[i].y );
        
        flgNbr[i] = prevImg.get( nx, ny ) == c;
    }
    
    sides.clear();
    
    for ( i = 0; i < flgNbr.length; i+= 2 ) {
        if ( flgNbr[i] ) {
            sides.add( i );
        }
    }
    
    if ( sides.size() > 0 ) {
        
        int n = int( random( 0, sides.size() ) );
        dir = sides.get(n);
    
    } else {
        
        //dir = int( random(0, 4) ) * 2;
        
        // normalized uv
        
        float u = x / float( mapW );
        float v = y / float( mapH );
        
        if ( v > u ) {
            if ( v > -u + 1 ) {
                dir = 0;
            } else {
                dir = 2;
            }
        } else {
            if ( v > -u + 1 ) {
                dir = 6;
            } else {
                dir = 4;
            }
        }
    }
    
    return dir;
}

/*
int getDir( int x, int y ) {
    
    //return int( random( 0, 3 ) );
    
    
    
    
    int dir = 9; // koritsu
    
    // search neighbor pixels
    for ( i = 0; i < neighborVec.length; i++ ) {
        
        nx = x + int( neighborVec[i].x );
        ny = y + int( neighborVec[i].y );
        
        flgNbr[i] = prevImg.get( nx, ny ) == c;
    }
    
    sides.clear();
    
    for ( i = 0; i < flgNbr.length; i+= 2 ) {
        if ( flgNbr[i] ) {
            sides.add( i );
        }
    }
    
    if ( sides.size() == 3 ) {
        
        if ( !flgNbr[0] )        dir = 4;
        else if ( !flgNbr[2] )   dir = 6;
        else if ( !flgNbr[4] )   dir = 0;
        else if ( !flgNbr[6] )   dir = 2;
    
    } else if ( sides.size() > 0 ) {
        
        int n = int( random( 0, sides.size() ) );
        dir = sides.get(n);
    
    } else {
        
        corners.clear();
        
        for ( i = 1; i < flgNbr.length; i += 2 ) {
            if ( flgNbr[i] ) {
                corners.add( i );
            }
        }
        
        if ( corners.size() > 0 ) {
            
            int n = int( random( 0, corners.size() ) );
            dir = corners.get(n);  
        } 
    }
    
    return dir;
}*/


//-------------------------------------------------------
// Utils


//taken from http://processing.org/learning/topics/directorylist.html
File[] listFiles(String dir) {
 File file = new File(dir);
 if (file.isDirectory()) {
   File[] files = file.listFiles();
   return files;
 } else {
   // If it's not a directory
   return null;
 }
}