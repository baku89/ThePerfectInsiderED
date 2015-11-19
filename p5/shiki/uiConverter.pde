import java.util.Collections;
import java.util.Comparator;  

ArrayList< UI > uiList = new ArrayList< UI >();
String partsDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/cubist-galaxy/_parts";
String uiPartsDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/cubist/parts";


class UIComparator implements Comparator< UI > {
    
    public int compare(UI ui1, UI ui2) {
        return ui1.getMinArea() < ui2.getMinArea() ? -1 : 1;
    }
}


void loadUI() {
    
    // green
    //uiList.add( new UI( uiPartsDir+"/dot.png", 1, 1, 1, 1 ) );
    uiList.add( new UI( uiPartsDir+"/button.png", 2, 2, 2, 2 ) );
    uiList.add( new UI( uiPartsDir+"/icon.png", 6, 6, 24, 6 ) );
    uiList.add( new UI( uiPartsDir+"/menu.png", 19, 2, 1, 19 ) );
    uiList.add( new UI( uiPartsDir+"/button_b.png", 8, 8, 8, 8 ) );
    //uiList.add( new UI( uiPartsDir+"/window_a.png", 31, 54, 31, 31 ) );
    
    uiList.add( new UI( partsDir+"/p00.png", 3, 3, 3, 3 ) );
    uiList.add( new UI( partsDir+"/p04.png", 8, 9, 8, 8 ) );
    uiList.add( new UI( partsDir+"/p06.png", 8, 9, 8, 8 ) );
    uiList.add( new UI( partsDir+"/p10.png", 5, 5, 13, 5 ) );
    uiList.add( new UI( partsDir+"/p13.png", 6, 6, 6, 6 ) );
    uiList.add( new UI( partsDir+"/p15.png", 16, 15, 14, 10 ) );
    
    
    
    // blue
    //uiList.add( new UI( partsDir+"/p02.png", 1, 1, 1, 1 ) );
    //uiList.add( new UI( partsDir+"/p01.png", 2, 2, 2, 2 ) );
    //uiList.add( new UI( partsDir+"/p03.png", 6, 6, 6, 6 ) );
    //uiList.add( new UI( partsDir+"/p07.png", 1, 1, 1, 1 ) );
    //uiList.add( new UI( partsDir+"/p08.png", 8, 2, 2, 2 ) );
    //uiList.add( new UI( partsDir+"/p09.png", 8, 2, 2, 6 ) );
    //uiList.add( new UI( partsDir+"/p11.png", 5, 5, 13, 5 ) );
    //uiList.add( new UI( partsDir+"/p12.png", 6, 6, 6, 6 ) );
    //uiList.add( new UI( partsDir+"/p14.png", 16, 15, 14, 10 ) );
    
}

class UIConverter {
    
    ArrayList< UIRect > uiRects;
    
    int w, h;
    PGraphics pg;
    
    // var
    boolean[][] done;
    int[][] maxArea, maxIndex;
    
    ArrayList< Rect > rects, tempRects;
    ArrayList<Boolean> isEnough;
    
     
    UIConverter( int _w, int _h ) {
        
        w = _w;
        h = _h;
        
        pg = createGraphics( w, h );
        
        done = new boolean[w][h];
        maxArea = new int[w][h];
        maxIndex = new int[w][h];
        
        rects = new ArrayList< Rect >();
        tempRects = new ArrayList< Rect >();
        isEnough = new ArrayList< Boolean >();
    }
    
    PImage convert( PImage img ) {
        
        ArrayList< Rect > rects = searchRect( img );
        //ArrayList< UI > supported = new ArrayList< UI >();
        
        
        pg.beginDraw();
        pg.background( 0 );
        pg.noStroke();
        
        int i, j;
        Rect r;
        UI ui = uiList.get( 0 );
        int minArea = 0;
        
        for ( i = 0; i < rects.size(); i++ ) {
            
            r = rects.get( i );
            
            ui = null;
            
            for ( j = 0; j < uiList.size(); j++ ) {
                
                if ( uiList.get(j).isSupport(r) && minArea < uiList.get(j).getMinArea() ) {
                    ui = uiList.get(j);
                    minArea = uiList.get(j).getMinArea();
                }
            }
            
            if ( ui == null ) {
                ui = uiList.get(0);
            }
            
            ui.drawToGraphics( pg, r );
            
        }
        
        pg.endDraw();
        return pg.get();
    }
    
    ArrayList< Rect > searchRect( PImage img ) {
        
        //rects.clear();
        //isEnough.clear();
        //tempRects.clear();
        
        //int iterateNum = 1;
        
        //int x, y, x1, y1;
        //int curtArea;
        //int curtIndex;
        //int smallerIndex;
        
        //boolean isMax = true;
        
        //Rect r;
        
        //for ( y = 0; y < h; y++ ) {
        //    for ( x = 0; x < w; x++ ) {
        //        done[ x ][ y ] = img.get( x, y ) == color( 0 );
                
        //    }
        //}
        
        //for ( int i = 0; i < iterateNum; i++ ) {
            
        //    tempRects.clear();
        //    isEnough.clear();
            
        //    // clear
        //    for ( y = 0; y < h; y++ ) {
        //        for ( x = 0; x < w; x++ ) {
        //            maxArea[x][y] = 0;
        //            maxIndex[x][y] = -1;
        //        }
        //    }
            
        //    // search
        //    for ( y = 0; y < h; y++ ) {
        //        for ( x = 0; x < w; x++ ) {
                    
        //            if ( !done[x][y]  ) {
                        
        //                r = findRect(x, y);
        //                curtArea = r.w * r.h;
        //                curtIndex = tempRects.size();
                        
        //                // search
        //                isMax = true;
        //                for ( y1 = r.y; y1 <= r.bottom() && isMax; y1++ ) {
        //                    for ( x1 = r.x; x1 <= r.right(); x1++ ) {
                                
        //                        if ( maxArea[x1][y1] < curtArea ) {
                                    
        //                            smallerIndex = maxIndex[x1][y1];
        //                            maxIndex[x1][y1] = curtIndex;
        //                            maxArea[x1][y1] = curtArea;
        //                            //println("A");
        //                            if ( smallerIndex != -1 ) {
        //                                isEnough.set( smallerIndex, false );
        //                            }
                                    
        //                        } else {
        //                            isMax = false;
        //                            break;
        //                        }
        //                    }
        //                }
                        
        //                if ( !isMax ) {
        //                    println("not");
        //                }
                        
        //                tempRects.add( r );
        //                isEnough.add( isMax );
        //            }
        //        }
        //    }
            
            //// add rects
            //for ( int j = 0; j < tempRects.size(); j++ ) {
                
            //    if ( isEnough.get(j) ) {
                    
            //        r = tempRects.get(j);
            //        rects.add( r );
                    
            //        for ( y1 = r.y; y1 <= r.bottom(); y1++ ) {
            //           for ( x1 = r.x; x1 <= r.right(); x1++ ) {
            //               done[x1][y1] = true;
            //           }
            //       }
            //    }
            //}
        //} 
        
        
        int x, y, x1, y1;
        
        rects.clear();
        
        for ( y = 0; y < h; y++ ) {
           for ( x = 0; x < w; x++ ) {
               done[ x ][ y ] = img.get( x, y ) == color( 0 );
                
           }
        }
        
        //addRect( 16 );
        addRect( 8 );
        addRect( 4 );
        addRect( 2 );
        addRect( 1 );
        
        
        
        return rects;
    }
    
    void addRect( int minWidth ) {
        
        int x, y, x1, y1;
        
        for ( y = 0; y < h; y++ ) {
           for ( x = 0; x < w; x++ ) {
                
               if ( !done[x][y] ) {
                    
                   // start searching
                   Rect r = findRect( x, y );
                   
                   if ( r.w < minWidth || r.y < minWidth ) {
                       continue;
                   }
                    
                   for ( y1 = r.y; y1 <= r.bottom(); y1++ ) {
                       for ( x1 = r.x; x1 <= r.right(); x1++ ) {
                           done[x1][y1] = true;
                       }
                   }
                   rects.add( r );
               }
           }
        }
    }
    
    
    
    Rect findRect( int x, int y ) {
        
        Rect r = new Rect( x, y, 1, 1 );
        Rect outer = new Rect();
    
        // expand right
        outer.copy( r );
        do {
            outer.w += 1;
            
            if ( isEmptyRectEdge( outer ) ) {
                r.copy( outer );
            } else {
                break;
            }
        } while ( true );
        
        // expand bottom
        outer.copy( r );
        do {
            outer.h += 1;
            
            if ( isEmptyRectEdge( outer ) ) {
                r.copy( outer );
            } else {
                break;
            }
        } while ( true );
        
        return r;
    }
    
    boolean isEmptyRectEdge( Rect r ) {
    
        if ( r.x < 0 || r.y < 0 || r.right() >= w || r.bottom() >= h ) {
            return false;
        }
        
        // horizontal edge
        for ( int x = r.x; x <= r.right(); x++ ) {
            if ( done[x][r.y] || done[x][r.bottom()] ) {
                return false;
            }
        }
        
        // vertical edge
        for ( int y = r.y; y <= r.bottom(); y++ ) {
            if( done[r.x][y] || done[r.right()][y] ) {
                return false;
            }
        }
        
        return true;
    }
    
}
   