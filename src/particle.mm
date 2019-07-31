//
//  particle.mm
//  liquidStory_1
//
//  Created by Robbert Groenendijk on 14/05/2019.
//

#include "particle.h"

Particle::Particle() {
    
}
void Particle::setup() {
    size = 3;
    location = ofVec2f(ofRandom(0,ofGetWidth()),ofRandom(0,ofGetHeight()));
    acceleration = ofVec2f(0,0);
    speed = ofVec2f(0,0);
}
void Particle::applyForce(ofVec2f _force) {
    acceleration += _force;
}
void Particle::move() {
    speed += acceleration;
    speed.limit(5);
    location += speed;
    
    acceleration *= 0;
}
void Particle::display() {
    ofPushStyle();
    ofSetColor(255, 0, 0);
    ofDrawCircle(location.x, location.y, size);
    ofPopStyle();
}
void Particle::checkCollision() {
    
}
void Particle::checkEdges() {

}
