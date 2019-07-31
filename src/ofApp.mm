#include "ofApp.h"

#import "AVFoundationVideoPlayer.h"

//--------------------------------------------------------------
void ofApp::setup(){
    // Visual config
    ofSetVerticalSync(true);
    ofEnableAlphaBlending();
    //ofSetLogLevel(OF_LOG_NOTICE);
    
    debug = false;
    titleOpacity = 0.0;
    titleImage.load("Me_and_You_title.png");
    
    // CoreMotion
    coreMotion.setupAccelerometer();
    coreMotion.setupGyroscope();
    coreMotion.setupAttitude();
    
    // Helper init
    helper = *new Helpers;
    helper.setup();
    
    // Box2D
    box2d.init();
    box2d.setGravity(0, 1);
    box2d.createGround();
    box2d.setFPS(60.0);
    
    appWidth = ofGetWidth();
    appHeight = ofGetHeight();
    
    for (int i = 0; i < 500; i++) { // Number of bodies dependant on device CPU
        auto circle = std::make_shared<ofxBox2dCircle>();
        
        circle->setPhysics(0.1, 0.2, 0.3);
        circle->bodyDef.angularDamping = 0.1;
        circle->bodyDef.allowSleep = true;
        circle->bodyDef.fixedRotation = true;
        circle->setup(box2d.getWorld(),
                      ofRandom(0,appWidth) ,
                      ofRandom(0,appHeight),
                      14 );
        
        circles.push_back(circle);
    }
    
    // Construct edges
    auto edge = make_shared<ofxBox2dEdge>();
    edge->addVertex(0, 0);
    edge->addVertex(appWidth, 0);
    edge->addVertex(appWidth, appHeight);
    edge->addVertex(0, appHeight);
    edge->addVertex(0, 0);
    edge->create(box2d.getWorld());
    edges.push_back(edge);
    
    // Global variables
    forceMultiplier = 30.0;
    
    // Video player
    videoPlayer.load("MeAndYou_export_1_v1.mp4");
    videoPlayer.setVolume(1.0);
    videoPlayer.play();
    
    AVFoundationVideoPlayer * avVideoPlayer;
    avVideoPlayer = (AVFoundationVideoPlayer *)videoPlayer.getAVFoundationVideoPlayer();
    
    // Shaders
    shader.load("shader");
    
    grainFbo.allocate(appWidth, appHeight,GL_RGBA);
    videoFbo.allocate(appWidth, appHeight,GL_RGBA);
    shaderFbo.allocate(appWidth, appHeight,GL_RGBA);
    
    shaderPlane.set(appWidth, appHeight, 100, 100);
    shaderPlane.setPosition(appWidth/2, appHeight/2, 0);
}

//--------------------------------------------------------------
void ofApp::update(){
    coreMotion.update();
    box2d.update();
    videoPlayer.update();
    
    if (videoPlayer.getIsMovieDone()) {
        videoPlayer.firstFrame();
        videoPlayer.setVolume(1.0);
        videoPlayer.play();
    }
    
    accelerometerData = coreMotion.getAccelerometerData();
    gyroscopeData = coreMotion.getGyroscopeData();
    userAcceleration = coreMotion.getUserAcceleration();
    pitchData = coreMotion.getPitch();
    rollData = coreMotion.getRoll();
    yawData = coreMotion.getYaw();
    attitudeData = ofVec3f(pitchData,rollData,yawData);
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofBackground(0);
    
    ofVec2f movementForce = helper.convertAttitude(attitudeData);
    ofVec2f accelerationForce = helper.convertAcceleration(userAcceleration);
    box2d.setGravity((movementForce * forceMultiplier) + (accelerationForce * 30));

    grainFbo.begin();
    ofClear(0,0,0,0);
    for(auto &circle : circles) {
        ofPushStyle();
        ofFill();
        ofSetColor(255, 255, 255);
        circle->draw();
        ofPopStyle();
    }
    grainFbo.end();
    
    videoFbo.begin();
    ofClear(0,0,0,0);
    
    if (videoPlayer.isFrameNew()) {
        
        ofPushMatrix();
        ofTranslate(appWidth, videoXoffset);
        ofRotateDeg(90);
        //ofTranslate((appHeight)/2, (appWidth)/2);
         
        
        videoTexture = videoPlayer.getTexturePtr();
        videoTexture->draw(0,0,appHeight,appWidth);
        ofPopMatrix();
     
    }
    videoFbo.end();
    
    shaderFbo.begin();
    ofClear(0,0,0,0);
    shader.begin();
    float resolution[] = {1025,2050}; // Hard coded weird resolution to fix scaling
    shader.setUniform2fv("resolution",resolution);
    shader.setUniformTexture("maskTex", grainFbo.getTexture(), 0 );
    shader.setUniformTexture("videoTex", videoFbo.getTexture(), 1 );
    
    ofPushMatrix();
    shaderPlane.draw();
    ofPopMatrix();
    shader.end();
    shaderFbo.end();
    
    shaderFbo.draw(0,0);
    
    //videoFbo.draw(0,0);
    
    // Draw title of film
    if (videoPlayer.getCurrentFrame() <= 100 && titleOpacity < 255) {
        titleOpacity += 5;
    } else if (videoPlayer.getCurrentFrame() > 100 && titleOpacity > 0){
        titleOpacity -= 5;
    } else if (titleOpacity < 0) {
        titleOpacity = 0;
    } else if (titleOpacity > 255) {
        titleOpacity = 255;
    }
    ofPushStyle();
    ofSetColor(255, 255, 255, titleOpacity);
    titleImage.draw((appWidth/2)-139,(appHeight-1000)/2,278,1000);
    ofPopStyle();
    
    if (debug) {
        ofPushStyle();
        ofSetColor(255, 0, 255,255);
        ofDrawLine(0, 0, 720, 1280);
        ofDrawLine(appWidth, 0, 0, appHeight);
        ofPopStyle();
        
        ofPushStyle();
        ofSetColor(0,255,0);
        ofDrawBitmapString("FPS", 10, appHeight - 150);
        ofDrawBitmapString(ofGetFrameRate(), 10, appHeight - 125);
        
        ofDrawBitmapString("Attitude Data", 10, appHeight - 100);
        ofDrawBitmapString(to_string(attitudeData.x), 10, appHeight - 75);
        ofDrawBitmapString(to_string(attitudeData.y), 10, appHeight - 50);
        ofDrawBitmapString(to_string(attitudeData.z), 10, appHeight - 25);
        ofPopStyle();
    }
    
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

    if (touch.numTouches > 0) {
        debug = true;
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    if (touch.numTouches < 1) {
        debug = false;
    }
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
