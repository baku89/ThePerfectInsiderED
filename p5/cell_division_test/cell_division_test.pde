
int w = 100 + 24;

void setup() {
    size( 640, 640 );
    PGraphics cell = divideCell( width, height, 10 );

    image( cell, 0, 0 );
}