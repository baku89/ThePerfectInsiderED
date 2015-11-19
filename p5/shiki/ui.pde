class UI {
    
   PImage uiTopLeft, uiTopRight, uiBottomLeft, uiBottomRight, uiTop, uiRight, uiBottom, uiLeft, uiCenter;
   int top, right, bottom, left;
    
   String name;
    
   UI() { }
    
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
   
   int getMinArea() {
       return (left + right) * (top + bottom);
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


class UIRect extends Rect {
    
   UI ui;

   UIRect( UI ui, Rect r ) {
        
       super( r.x, r.y, r.w, r.h );
       this.ui = ui;
   }
    
   void draw() {
        
       ui.draw( this );
   }

}