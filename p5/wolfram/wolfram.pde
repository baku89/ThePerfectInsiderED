// https://processing.org/examples/wolfram.html


CA ca;   // An instance object to describe the Wolfram basic Cellular Automata

boolean isFinished = false;


void setup() {
    size( 640, 640 );
    
    int[] ruleset = { 1, 0, 0, 1, 1, 0, 0, 1 };    // An initial rule system
    ca = new CA( ruleset );                 // Initialize CA
    background( 0 );
}

void draw() {
    
    if ( !isFinished ) {
		ca.render();    // Draw the CA
		ca.generate();  // Generate the next level
    }
  
    isFinished = ca.finished();
}

void mousePressed() {
    
    ca.restart();
}