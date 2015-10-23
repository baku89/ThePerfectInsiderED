void changeWindowSize(int w, int h) {
    surface.setSize( w + frame.getInsets().left + frame.getInsets().right, h + frame.getInsets().top + frame.getInsets().bottom );
    size(w, h);
    
}