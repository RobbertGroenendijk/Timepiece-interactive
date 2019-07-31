//
//  helpers.h
//  liquidStory_1
//
//  Created by Robbert Groenendijk on 14/05/2019.
//

#ifndef helpers_h
#define helpers_h

#include "ofxiOS.h"

class Helpers {
public:
    Helpers();
    void setup();
    ofVec2f convertAttitude(ofVec3f _attitudeData);
    ofVec2f convertAcceleration(ofVec3f _accelerationData);
};

#endif /* helpers_h */
