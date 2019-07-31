//
//  particle.h
//  liquidStory_1
//
//  Created by Robbert Groenendijk on 14/05/2019.
//

#ifndef particle_h
#define particle_h

#include "ofxiOS.h"

class Particle {
public:
    Particle();
    void setup();
    void applyForce(ofVec2f _force);
    void move();
    void display();
    void checkCollision();
    void checkEdges();
    
    ofVec2f location;
    ofVec2f acceleration;
    ofVec2f speed;
    
    float size;
};

#endif /* particle_h */
