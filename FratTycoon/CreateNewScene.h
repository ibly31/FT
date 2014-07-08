//
//  CreateNewScene.h
//  FratTycoon
//
//  Created by Billy Connolly on 4/23/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"

@interface CreateNewScene : CCNode {
    CCSprite *letterOne;
    CCSprite *letterTwo;
    CCSprite *letterThr;
    
    int letOneInd;
    int letTwoInd;
    int letThrInd;
}

+ (CCScene *) scene;

- (void)upArrowOne;
- (void)upArrowTwo;
- (void)upArrowThree;

- (void)downArrowOne;
- (void)downArrowTwo;
- (void)downArrowThree;

- (void)create;

@end
