//
//  GameScene.h
//  FratTycoon
//
//  Created by Billy Connolly on 2/12/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"
#import "FTHouseNode.h"
#import "FTPersonPopup.h"
#import "FTLevelStack.h"

@interface GameScene : CCNode <FTLevelStackDelegate>{
    FTHouseNode *houseNode;
    
    FTPersonPopup *personPopup;
    
    FTLevelStack *levelStack;
        
    CGPoint panStartLocation;
    NSTimeInterval tapTime;
    CGPoint panOffset;
    
    int selectedPerson;
    
    CCButton *backButton;
    CCButton *debugButton;
}

+ (CCScene *) scene;

@property (nonatomic, retain) FTHouseNode *houseNode;
@property BOOL panning;

- (void)deselectPerson;

@end
