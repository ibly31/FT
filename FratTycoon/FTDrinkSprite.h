//
//  FTDrinkSprite.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/24/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "CCSprite.h"

typedef enum{
    FTDrinkSpriteCan = 0,
    FTDrinkSpriteCup,
    FTDrinkSpriteBottle
}FTDrinkSpriteType;

@interface FTDrinkSprite : CCSprite{
    FTDrinkSpriteType type;
}

@property FTDrinkSpriteType type;

@end
