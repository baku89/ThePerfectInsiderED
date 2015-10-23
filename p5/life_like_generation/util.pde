

int getStatus( PImage field, int x, int y ) {

    if ( x < 0 || field.width <= x || y < 0 || field.height <= y ) {
        return 0;
    } else {

        return field.get( x, y ) != colorDead ? 1 : 0;
    }
}

void changeWindowSize(int w, int h) {

    surface.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    size(w, h);
    
}

String[] getArgs( String[] defaults ) {
    
    String[] arguments = new String[ defaults.length ];
    
    try {
        for ( int i = 0; i < args.length; i++ ) {
            arguments[i] = args[i];
        }
    } catch ( Exception e ) {
    }
    
    for ( int i = 0; i < defaults.length; i++ ) {
        if ( arguments[i] == null ) {
            arguments[i] = defaults[i];
        }
    }
    
    return arguments;
}

void deleteFile( File f ) {

    if ( !f.exists() ) {
        return;
    }
    
    if ( f.isFile() ) {
    
        f.delete();
    
    } else if ( f.isDirectory() ) {
        
        File[] files = f.listFiles();
        
        for ( int i = 0; i < files.length; i++ ) {
            deleteFile( files[i] );
        }
        
        f.delete();
    }
}

boolean xor( boolean a, boolean b ) {
    return (a && !b) || (!a && b);
}