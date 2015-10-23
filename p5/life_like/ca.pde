boolean[] survive, birth;

//-------------------------------------------------------
// rules

// conway's game of life
//int[] birthNum = { 3 };
//int[] surviveNum = { 2, 3 };

//// replicator
//int[] birthNum = { 1, 3, 5, 7 };
//int[] surviveNum = { 1, 3, 5, 7 };

// small-replicator
//int[] birthNum = { 2, 5 };
//int[] surviveNum = { 4 };

// 34 Life
//int[] birthNum = { 3, 4 };
//int[] surviveNum = { 3, 4 };

// 2x2
//int[] birthNum = { 3, 6 };
//int[] surviveNum = { 1, 2, 5 };

// day and night
//int[] birthNum = {3, 6, 7, 8 };
//int[] surviveNum = { 3, 4, 6, 7, 8 };

// HighLife
//int[] birthNum = {3, 6};
//int[] surviveNum = { , 3};

// Morley
//int[] birthNum = {3, 6, 8};
//int[] surviveNum = {2, 4, 5};

// Diamoeba
//int[] birthNum = {3, 5, 6, 7, 8};
//int[] surviveNum = {5, 6, 7, 8};

// explosive one
//int[] birthNum = {1, 7};
//int[] surviveNum = {7, 8};

// explosive two
//int[] birthNum = {1, 4, 5};
//int[] surviveNum = {3, 4};

// gnarl
//int[] birthNum = {1};
//int[] surviveNum = {1};

//// coagulations
//int[] birthNum = {3, 7, 8};
//int[] surviveNum = {2, 3, 4, 5, 6, 7, 8};

//// mazectric
int[] birthNum = {3};
int[] surviveNum = {1, 2, 3, 4, 5};

// amoeba
//int[] birthNum = {1, 3, 5, 8};
//int[] surviveNum = {3, 5, 7};

// Serviettes
//int[] birthNum = {2, 3, 4};
//int[] surviveNum = {};

//-------------------------------------------------------
// class & methods

class LifeLikeCA
{
    PImage field, buff;
    int fw, fh;
    
    LifeLikeCA(PImage initCond) {
        
        fw = initCond.width;
        fh = initCond.height;
        
        field = initCond;
        buff = createImage(fw, fh, RGB);
        
    }
    
    void draw(int x, int y) {
    
        image(field, x, y);
    
    }
    
    void update() {
        
        int aliveNum;
        color next;
        
        buff.copy(field, 0, 0, fw, fh, 0, 0, fw, fh);
    
        for (int y = 0; y < fh; y++) {
            for (int x = 0; x < fw; x++) {
    
                aliveNum = getAliveCount(buff, x, y);
                next = colorDead;
                
                if (getStatus(buff, x, y)  == colorAlive) {
                    if (survive[ aliveNum ]) {
                        next = colorAlive;
                    }
                } else {
                    if (birth[aliveNum]) {
                        next = colorAlive;
                    }
                }
    
                field.set(x, y, next);
            }
        }
    }
}

void setupLifeLikeRules() {
  
   // init rules
    survive = new boolean[9];
    birth  = new boolean[9];

    for (int i = 0; i < 8; i++) {
        survive[i] = false;
        birth[i] = false;
    }

    for (int i = 0; i < surviveNum.length; i++) {
        survive[surviveNum[i]] = true;
    }
    for (int i = 0; i < birthNum.length; i++) {
        birth[birthNum[i]] = true;
    }
    
    for (int i = 0; i < 9; i++) {
        print(survive[i] ? "T" : "F");
    }
    println("");
    for (int i = 0; i < 9; i++) {
        print(birth[i] ? "T" : "F");
    }
    
}

int getAliveCount(PImage field, int x, int y) {

    int neighbors = 0;

    neighbors += getStatus(field,   x, y-1);
    neighbors += getStatus(field, x+1, y-1);
    neighbors += getStatus(field, x+1,   y);
    neighbors += getStatus(field, x+1, y+1);
    neighbors += getStatus(field,   x, y+1);
    neighbors += getStatus(field, x-1, y+1);
    neighbors += getStatus(field, x-1,   y);
    neighbors += getStatus(field, x-1, y-1);

    return neighbors;
}

int getStatus(PImage field, int x, int y) {

    if (x < 0 || field.width <= x || y < 0 || field.height <= y) {
        return 0;
    } else {
        return field.get(x, y) == colorDead ? 1 : 0;
    }
}