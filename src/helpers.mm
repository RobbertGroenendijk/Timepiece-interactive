//
//  helpers.mm
//  liquidStory_1
//
//  Created by Robbert Groenendijk on 14/05/2019.
//

#include "helpers.h"

Helpers::Helpers() {
    
}
void Helpers::setup() {
    
}
ofVec2f Helpers::convertAttitude(ofVec3f _attitudeData) {
    float yawData = _attitudeData.x;
    float rollData = _attitudeData.y;
    float pitchData = _attitudeData.z; // Not in use
    
    float yMovement = ofMap(yawData,-PI,PI,-5,5);
    float xMovement = ofMap(rollData,-PI,PI,-5,5);
    
    ofVec2f movementVector = ofVec2f(xMovement,yMovement);
    
    return movementVector;
}
ofVec2f Helpers::convertAcceleration(ofVec3f _accelerationData) {
    float xAcc = _accelerationData.x;
    float yAcc = _accelerationData.y;
    float zAcc = _accelerationData.z; // Not in use
    
    float xAccForce = ofMap(xAcc,-1,1,-5,5);
    float yAccForce = ofMap(yAcc,-5,5,25,-25);
    
    ofVec2f AccelerationForceVector = ofVec2f(xAccForce,yAccForce);
    
    return AccelerationForceVector;
}
