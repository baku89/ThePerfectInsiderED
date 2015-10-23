// ---------------
// Particle.pde
// ---------------

// neighbor
int nlen = 8;
int[] nx = {  0, +1, +1, +1,  0, -1, -1, -1 };
int[] ny = { -1, -1,  0, +1, +1, +1,  0, -1 };

// weight
float weight;
float weightRandom = 5.8;
float[] weightBk = new float[ nlen ];

class Particle
{
    int x, y;
    boolean isSeed = false;
    boolean stuck = false;
    boolean isOut = false;
    
    Particle( int threshold ) {
        reset( threshold );
    }

    void reset( int threshold ) {
        // keep choosing random spots until an empty one is found
        do {
            x = floor( random(width) );//floor( random(width/2) ) * 2;
            y = floor( random(height) );//floor( random(height/2) ) * 2;
        
        } while (field[y * width + x] || (map.get( x, y ) & 0xff) < threshold );
    }

    void update() {
        // move around
        if (!stuck) {
            
            // read weight
            //weightSum = 0;
            /*for ( int i = 0; i < nlen; i++ ) {
            
                weightSum += pow( float( map.get( x + nx[i], y + ny[i] ) & 0xff ), 3 );
                weightBk[ i ] = weightSum;
                //print( weightSum + "\t" );
            }
            
            
            r = random( weightSum );
            
            
            //println( "|" + r );
            
            for ( int i = 0; i < nlen; i++ ) {
            
                if ( r <= weightBk[i] ) {
                    x += nx[i];
                    y += ny[i];
                    break;
                }
            }*/
            
            float maxWeight = -weightRandom * 2;
            int maxDir = 0;
            
            for ( int i = 0; i < nlen; i++ ) {
                weight = float( map.get( x + nx[i], y + ny[i] ) & 0xff ) / 255.0 + random( -weightRandom, weightRandom );
                if ( weight > maxWeight ) {
                    maxDir = i;
                    maxWeight = weight;
                }
            }
            
            x += nx[ maxDir ];
            y += ny[ maxDir ];
            
            
            /*x += round(random(-1, 1));
            y += round(random(-1, 1));*/
            
            
            
            /*if ( random(1) < 0.1 ) {
                
                if ( x > width / 2 ) 
                    x -= 1;
                else
                    x += 1;
                
                if ( y > height / 2 )
                    y -= 1;
                else
                    y += 1;
                 
            
            } else {
            
                x += round(random(-1, 1));
                y += round(random(-1, 1));
            
            }*/
            
            
            // diagonal random walk
            //r = int( random( 0, 4 ) );
            //if ( r == 0 ) {
            //    x += 1; y -= 1;
            //} else if ( r == 1 ) {
            //    x += 1; y += 1;
            //} else if ( r == 2 ) {
            //    x -= 1; y += 1;
            //} else if ( r == 3 ) {
            //    x -= 1; y -= 1;
            //}
            
            isOut = false;
            
            if ( x < 0 ) {
                x = 0;
                isOut = true;
            }
            if ( y < 0 ) {
                y = 0;
                isOut = true;
            }
            if ( x >= width ) {
                x = width - 1;
                isOut = true;
            }
            if ( y >= height ) {
                y = height - 1;
                isOut = true;
            }
            
            if ( isOut ) {
                return;
            }
            

            // test if something is next to us
            if ( !alone() ) {
                stuck = true;
                field[y * width + x] = true;        
            }
        }
    }

    // returns true if no neighboring pixels
    boolean alone() {
        
        int cx = x;
        int cy = y;

        // get positions
        int lx = cx-1;
        int rx = cx+1;
        int ty = cy-1;
        int by = cy+1;

        // if bound
        if (cx <= 0 || cx >= width || 
            lx <= 0 || lx >= width || 
            rx <= 0 || rx >= width || 
            cy <= 0 || cy >= height || 
            ty <= 0 || ty >= height || 
            by <= 0 || by >= height) return true;

        // pre multiply the ys
        cy *= width;
        by *= width;
        ty *= width;
    
        // N, W, E, S
        
        int neumann =
            ( field[cx + ty] ? 1 : 0 ) +
            ( field[lx + cy] ? 1 : 0 ) +
            ( field[rx + cy] ? 1 : 0 ) +
            ( field[cx + by] ? 1 : 0 );
            
        /*boolean corner = 
            field[lx + ty] || 
            field[lx + by] ||
            field[rx + ty] ||
            field[rx + by];*/
            
        if ( neumann == 1 ) {
            return false;
        }
       

        return true;

    }  
}