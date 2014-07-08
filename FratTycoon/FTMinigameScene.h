//
//  FTMinigameScene.h
//  FratTycoon
//
//  Created by Billy Connolly on 2/17/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FTMinigameScene : CCNode {
    CCSprite *bpTable;
    CCSprite *bpBall1;
    CCSprite *bpBall2;
    
    CCSprite *shotStartIndicator;
    CCSprite *shotConnector;
    CCSprite *shotLocIndicator;
    
    int topCupsOut[6];
    int bottomCupsOut[6];
    NSMutableArray *topCups;
    NSMutableArray *bottomCups;
    
    BOOL touchBackButton;
    CCSprite *backButton;

    BOOL throwing;
    CGPoint throwStartLoc;
    
    BOOL ballInFlight;
    CGPoint ballVelocity;
    float ballZ;
    float ballVelZ;
    
    BOOL movingCup;
}

+ (CCScene *) scene;

- (void)goBack;

@end
