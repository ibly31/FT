//
//  FTQuantityBar.h
//  FratTycoon
//
//  Created by Billy Connolly on 5/23/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"

@interface FTQuantityBar : CCNode {
    CCSprite *backgroundSprite;
    CCSprite *fillSprite;
    CCSprite *lineSprite;
    
    float quantity;
}

- (id)initWithFillSpriteNumber:(int)num;

- (void)setQuantity:(float)q;
- (float)quantity;

@end
