
String partsDir = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/cubist/parts";

ArrayList< UI > uiList = new ArrayList< UI >();
    
    
void loadUI() {

    // smaller --> bigger
    uiList.add( new UI( partsDir+"/dot.png", 1, 1, 1, 1 ) );
    uiList.add( new UI( partsDir+"/button.png", 2, 2, 2, 2 ) );
    uiList.add( new UI( partsDir+"/icon.png", 6, 6, 24, 6 ) );
    uiList.add( new UI( partsDir+"/menu.png", 19, 2, 1, 19 ) );
    uiList.add( new UI( partsDir+"/button_b.png", 8, 8, 8, 8 ) );
    uiList.add( new UI( partsDir+"/window_a.png", 31, 54, 31, 31 ) );
    
    
}

ArrayList< UIRect > generateUIRects( ArrayList< Rect > rects ) {
    
    Rect r;
    UI ui= new UI();
    ArrayList< UIRect > uiRects = new ArrayList< UIRect >();
    
    for ( int i = 0; i < rects.size(); i++ ) {
        
        r = rects.get( i );
        
        
        for ( int j = 0; j < uiList.size(); j++ ) {
            
            
            if ( !uiList.get( j ).isSupport( r ) ) {
                break;
            }
            ui = uiList.get( j );
        }
        
        uiRects.add( new UIRect( ui, r ) );
    }
    
    return uiRects;
}


class UI {
    
    PImage uiTopLeft, uiTopRight, uiBottomLeft, uiBottomRight, uiTop, uiRight, uiBottom, uiLeft, uiCenter;
    int top, right, bottom, left;
    
    String name;
    
    UI() {
    }
    
    UI( String path, int top, int right, int bottom, int left ) {
        
        this.top = top;
        this.right = right;
        this.bottom = bottom;
        this.left = left;
        
        PImage img = loadImage( path );
        int w = img.width, h = img.height;
        
        uiTopLeft     = decomposeToUIPart( img, 0, 0, left, top );
        uiTopRight    = decomposeToUIPart( img, w - right, 0, right, top );
        uiBottomLeft  = decomposeToUIPart( img, 0, h - bottom, left, bottom );
        uiBottomRight = decomposeToUIPart( img, w - right, h - bottom, right, bottom );
        
        uiTop    = decomposeToUIPart( img, left, 0, w - left - right, top );
        uiBottom = decomposeToUIPart( img, left, h - bottom, w - left - right, bottom );
        uiLeft   = decomposeToUIPart( img, 0, top, left, h - top - bottom );
        uiRight  = decomposeToUIPart( img, w - right, top, right, h - top - bottom );
        
        uiCenter = decomposeToUIPart( img, left, top, w - left - right, h - top - bottom );
        
        
        
    }
    
    boolean isSupport( Rect r ) {
        
        return r.w >= left + right + 1 && r.h >= top + bottom + 1;
    }
    
    void drawToGraphics( PGraphics pg, Rect r ) {
        
        int et = r.y + top,
            er = r.x + r.w - right,
            eb = r.y + r.h - bottom,
            el = r.x + left,
            ew = r.w - left - right,
            eh = r.h - top - bottom;
        
        pg.image( uiTopLeft, r.x, r.y );
        pg.image( uiTopRight, er, r.y );
        pg.image( uiBottomLeft, r.x, eb );
        pg.image( uiBottomRight, er, eb );
        
        pg.image( uiTop, el, r.y, ew, top );
        pg.image( uiBottom, el, eb, ew, bottom );
        pg.image( uiLeft, r.x, et, left, eh );
        pg.image( uiRight, er, et, right, eh );
        
        pg.image( uiCenter, el, et, ew, eh );
    }
    
    void draw( Rect r ) {
        
        int et = r.y + top,
            er = r.x + r.w - right,
            eb = r.y + r.h - bottom,
            el = r.x + left,
            ew = r.w - left - right,
            eh = r.h - top - bottom;
        
        image( uiTopLeft, r.x, r.y );
        image( uiTopRight, er, r.y );
        image( uiBottomLeft, r.x, eb );
        image( uiBottomRight, er, eb );
        
        image( uiTop, el, r.y, ew, top );
        image( uiBottom, el, eb, ew, bottom );
        image( uiLeft, r.x, et, left, eh );
        image( uiRight, er, et, right, eh );
        
        image( uiCenter, el, et, ew, eh );
        
    }
}

PImage decomposeToUIPart( PImage img, int x, int y, int w, int h ) {
    PImage part = createImage( w, h, RGB );
    
    part.copy( img, x, y, w, h, 0, 0, w, h );
    
    return part;
}


/*

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
}*/