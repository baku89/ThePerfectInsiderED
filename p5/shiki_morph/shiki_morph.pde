//-------------------------------------------------------
// Settings

String[] defaultArgs = {
   "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/shiki-other/01_lg/lg_die_hard",
   "16"
};

//-------------------------------------------------------
// Processing

String srcFolder;
String dstFolder = "/Volumes/MugiRAID1/Works/2015/13_0xff/ca/shiki/02_anim";
int cellSize;

String name;
File[] files = null;

int index;

Morph morph;
UIConverter uiConverter;

PImage result;

void setup() {
    
   //frameRate( 60 );
   frameRate( 10 );
   noSmooth();
    
   String[] arguments = getArgs( defaultArgs );
    
   srcFolder = arguments[ 0 ];
   cellSize = Integer.parseInt( arguments[ 1 ] );
    
   files = listFiles( srcFolder );
   PImage img = loadImage( files[0].getAbsolutePath() );
    
   morph = new Morph( img.width, img.height, cellSize );
   uiConverter = new UIConverter( morph.getWidth(), morph.getHeight() );
    
   name = ( new File( srcFolder ) ).getName().replace( "_lg",  "" );
   
   changeWindowSize( morph.getWidth(), morph.getHeight() );
    
   loadUI();
   
}

void draw() {
    
   if ( morph.availableNewFrame() ) {
        
       PImage img = loadImage( files[ index++ ].getAbsolutePath() );
       morph.addFrame( img );
   }
    
   morph.update();
    
   result = uiConverter.convert( morph.getImage() );
    
   image( result, 0, 0 );
    
   String frameSuffix = String.format( "%04d", (frameCount-1) );
   result.save( dstFolder + "/" + name + "_anim" + "/" + name + "_anim_" + frameCount + ".png" );
    
    
   if ( index == files.length ) {
       exit();
   }
}