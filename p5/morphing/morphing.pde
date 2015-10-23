//-------------------------------------------------------
// cofing

String srcFolder = "../_dat/lg";

int cellWidth = 8;
int frameDuration = 6;

float gamma = 1;

//-------------------------------------------------------
// main

File[] files = null;
int index = 0;
int frame = 0;

PImage img, prevImg, changedImg;

int mapWidth, mapHeight;

ArrayList<Integer> sides = new ArrayList<Integer>();
ArrayList<Integer> corners = new ArrayList<Integer>();

boolean[] flgNbr = { false, false, false, false, false, false, false, false };

PVector[] neighborVec = {
    new PVector( 0, -1),
    new PVector(+1, -1),
    new PVector(+1,  0),
    new PVector(+1, +1),
    new PVector( 0, +1),
    new PVector(-1, +1),
    new PVector(-1,  0),
    new PVector(-1, -1)
};


void setup() {
    
   noSmooth();

   files = listFiles(srcFolder);

   img = loadImage(files[0].getAbsolutePath());
   mapWidth = img.width;
   mapHeight = img.height;
   
   changedImg = createImage(mapWidth, mapHeight, ARGB);

   changeWindowSize(mapWidth * cellWidth, mapHeight * cellWidth);
   noStroke();
   
   index++;
}

void draw() {
    
    background( 0 );
    
    color c, pc;
    int dir;
    
    if ( frame == 0 ) {
        
        println("loading.." + index);
        img = loadImage(files[index].getAbsolutePath());
        prevImg = loadImage(files[index-1].getAbsolutePath());
   
        for (int y = 0; y < mapHeight; y++) {
            for (int x = 0; x < mapWidth; x++) {
                
                c = img.get( x, y );
                pc = prevImg.get( x, y );
                
                // detect changed pix
                if ( c != pc ) {
                    dir = getDir(x, y, c);
                    changedImg.set(x, y, color(c, dir + 1));
                
                } else {
                    
                    changedImg.set(x, y, color(0));
                 
                }
            }
        }
        
        if ( ++index == files.length ) {
            exit();
        }
 
    }
    
    // draw animation
    float t = float(frame) / frameDuration;
    t = (float) Math.pow( t, gamma );

    image(prevImg, 0, 0, mapWidth * cellWidth, mapHeight * cellWidth );
    
    for (int y = 0; y < mapHeight; y++) {
        for (int x = 0; x < mapWidth; x++) {
            
            c = changedImg.get(x, y);
            dir = int(alpha(c) - 1);
            
            if ( alpha(c) > 0 ) {
                
                resetMatrix();
                scale( cellWidth );
                translate( x, y );
                
                // normal
                fill(color( red(c), green(c), blue(c)));
                
                if (dir == 0 )         rect(0, 0, 1, t);
                else if (dir == 2)    rect(1-t, 0, t, 1);
                else if (dir == 4)    rect(0, 1-t, 1, t);
                else if (dir == 6)    rect(0, 0, t, 1);
                
                else if (dir == 1)    rect(1-t, 0, t, t );
                else if (dir == 3)    rect(1-t, 1-t, t, t );
                else if (dir == 5)    rect(1-t, 0, t, t );
                else if (dir == 7)    rect(0, 0, t, t );
                
                else if (dir == 9)    rect((1-t)/2, (1-t)/2, t, t);
                
            } else {
            
            }
        }
    }
    
    saveFrame("out/morphing_########.png");
    
    // next
    frame = ( frame + 1 ) % frameDuration;
}


// radial effect
//int getDir( int x, int y ) {
    
//    int dir = 9; // koritsu
    
//    // search neighbor pixels
//    for ( i = 0; i < neighborVec.length; i++ ) {
        
//        nx = x + int( neighborVec[i].x );
//        ny = y + int( neighborVec[i].y );
        
//        flgNbr[i] = prevImg.get( nx, ny ) == c;
//    }
    
//    sides.clear();
    
//    for ( i = 0; i < flgNbr.length; i+= 2 ) {
//        if ( flgNbr[i] ) {
//            sides.add( i );
//        }
//    }
    
//    if ( sides.size() > 0 ) {
        
//        int n = int( random( 0, sides.size() );
//        dir = sides.get(n);
    
//    } else {
        
//        //dir = int( random(0, 4) * 2;
        
//        // normalized uv
//        float u = x / float( mapWidth );
//        float v = y / float( mapHeight );
        
//        if ( v > u ) {
//            if ( v > -u + 1 ) {
//                dir = 0;
//            } else {
//                dir = 2;
//            }
//        } else {
//            if ( v > -u + 1 ) {
//                dir = 6;
//            } else {
//                dir = 4;
//            }
//        }
//    }
//    return dir;
//}

// neutral
int getDir(int x, int y, color targetColor) {
    
    int dir = 9; // alone
    
    // search neighbor pixels
    for (int i = 0; i < neighborVec.length; i++) {
        int nx = x + int(neighborVec[i].x);
        int ny = y + int(neighborVec[i].y);
        
        flgNbr[i] = prevImg.get(nx, ny) == targetColor;
    }
    
    sides.clear();
    
    for (int i = 0; i < flgNbr.length; i+= 2) {
        if (flgNbr[i]) {
            sides.add(i);
        }
    }
    
    if (sides.size() == 3) {
        
        if (!flgNbr[0])        dir = 4;
        else if (!flgNbr[2])   dir = 6;
        else if (!flgNbr[4])   dir = 0;
        else if (!flgNbr[6])   dir = 2;
    
    } else if (sides.size() > 0) {
        
        int n = int(random(0, sides.size()));
        dir = sides.get(n);
    
    } else {
        
        corners.clear();
        
        for (int i = 1; i < flgNbr.length; i += 2) {
            if (flgNbr[i]) {
                corners.add( i );
            }
        }
        
        if (corners.size() > 0) {
            int n = int(random( 0, corners.size()));
            dir = corners.get(n);  
        } 
    }
    
    return dir;
}