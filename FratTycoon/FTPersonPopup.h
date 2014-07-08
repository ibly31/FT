//
//  FTPersonPopup.h
//  FratTycoon
//
//  Created by Billy Connolly on 5/9/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"
#import "FTQuantityBar.h"

@class GameScene;

@interface FTPersonPopup : CCNode {
    GameScene *gameScene;
    
    CCSprite *background;
    CCSprite *personPreviewSprite;
    CCLabelTTF *nameLabel;
    
    FTQuantityBar *hotnessQuantity;
    FTQuantityBar *intelligenceQuantity;
    FTQuantityBar *happinessQuantity;
    FTQuantityBar *sicknessQuantity;
        
    CGPoint dragStartLocation;
    NSTimeInterval tapTime;
    CGPoint dragOffset;
    
    BOOL showing;
}

@property BOOL showing;

- (id)initWithGameScene:(GameScene *)gs;

- (void)setDataWithDictionary:(NSDictionary *)personDict;

@end
