#pragma once

// OpenFrameworks iOS
#include "ofxiOS.h"
// CoreMotion
#include "ofxiOSCoreMotion.h"
// Box2D
#include "ofxBox2d.h"
// Helper functions
#include "helpers.h"

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
    float appWidth;
    float appHeight;
    
    float titleOpacity;
    
    float forceMultiplier;
    
    ofxiOSCoreMotion coreMotion;
    ofVec3f accelerometerData;
    ofVec3f gyroscopeData;
    ofVec3f attitudeData;
    ofVec3f userAcceleration;
    float pitchData;
    float rollData;
    float yawData;
    
    Helpers helper;
    
    ofxBox2d box2d;
    vector <ofPolyline> lines;
    vector <shared_ptr<ofxBox2dCircle>> circles;
    vector <shared_ptr<ofxBox2dEdge>> edges;
    
    ofxiOSVideoPlayer videoPlayer;
    ofTexture *videoTexture;
    float videoYoffset;
    float videoXoffset;
    
    ofFbo grainFbo;
    ofFbo videoFbo;
    ofFbo shaderFbo;
    ofShader shader;
    
    ofPlanePrimitive shaderPlane;
    
    bool debug;
    
    ofImage titleImage;
};


