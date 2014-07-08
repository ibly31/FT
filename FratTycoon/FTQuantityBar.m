//
//  FTQuantityBar.m
//  FratTycoon
//
//  Created by Billy Connolly on 5/23/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTQuantityBar.h"

@implementation FTQuantityBar

- (id)initWithFillSpriteNumber:(int)num{
    self = [super init];
    if(self){
        backgroundSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(160, 60, 92, 12)];
        [backgroundSprite setAnchorPoint: ccp(0, 0.5f)];
        
        fillSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(140, 40 + num * 2, 1, 1)];
        [fillSprite setScaleY: 10.0f];
        [fillSprite setPosition: ccp(1, 0)];
        [fillSprite setAnchorPoint: ccp(0, 0.5f)];
        
        lineSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(160, 40, 90, 10)];
        [lineSprite setPosition: ccp(1, 0)];
        [lineSprite setAnchorPoint: ccp(0, 0.5f)];
        
        [self addChild: backgroundSprite];
        [self addChild: fillSprite];
        [self addChild: lineSprite];
        
        [self setAnchorPoint: ccp(0, 0.5f)];
        
        [self setQuantity: 0.5f];
    }
    return self;
}

- (void)setQuantity:(float)q{
    quantity = clampf(q, 0.0f, 1.0f);
    [fillSprite setScaleX: quantity * 90.0f];
}

- (float)quantity{
    return quantity;
}

@end
