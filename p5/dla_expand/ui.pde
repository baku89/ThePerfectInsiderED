color uiGray = color( 204, 206, 204 ),
      uiWhite = color( 252, 254, 252 ),
      uiBlack = color( 124, 126, 124 );

PImage renderUI( ArrayList< Rect > rects, int w, int h, int scale ) {

    
    PGraphics pg = createGraphics( width * scale, height * scale );
    Rect r;
    
    
    
    pg.beginDraw();
    pg.background( 0 );
    pg.noStroke();
    
    
    for ( int i = 0; i < rects.size(); i++ ) {
    
        r = rects.get(i);
        
        renderBevel( pg, r, scale, 2 );
    }
    
    pg.endDraw();
    
    
    return pg.get();

}

void renderBevel( PGraphics pg, Rect r, int scale, int w ) {
    
    pg.fill( uiGray );
    pg.rect( r.x * scale, r.y * scale, r.w * scale, r.h * scale );
    
    pg.fill( uiBlack );
    pg.rect( ( r.x + r.w ) * scale - w, r.y * scale, w, r.h * scale );
    pg.rect( r.x * scale, ( r.y + r.h ) * scale - w, r.w * scale, w );
        
    pg.fill( uiWhite );
    for ( int i = 0; i < w; i++ ) {
        pg.rect( r.x * scale + i, r.y * scale, 1, r.h * scale - i );
        pg.rect( r.x * scale, r.y * scale + i, r.w * scale - i, 1 );
    }
        
    


}