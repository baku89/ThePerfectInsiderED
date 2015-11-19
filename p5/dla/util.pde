import java.io.FilenameFilter;

void changeWindowSize(int w, int h) {

    surface.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    size(w, h);
    
}

File[] listImageFiles(String path) {
    
    File file = new File(resolveRelativePath(path));
    
    if (file.isDirectory()) {
        
        FilenameFilter filter = new FilenameFilter() {
            public boolean accept(File dir, String name) {
                String ext = "";
                int dotIndex = name.lastIndexOf('.');
                if ((dotIndex > 0) && (dotIndex < name.length() - 1 )) {
                    ext = name.substring(dotIndex + 1).toLowerCase();
                }
                return (ext.equals("png"));
            }
        };
        return file.listFiles(filter);
        
    } else {
        // If it's not a directory
        return new File[0];
    }
}

String resolveRelativePath(String path) {
    File file = new File(sketchPath("") + path);
    
    try {
        return file.getCanonicalPath();
    } catch (Exception e) {
        return null;
    }
}