//
//  FTDrinkSprite.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/24/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTDrinkSprite.h"

@implementation FTDrinkSprite

- (id)init{
    self = [super initWithImageNamed: @"PeopleSheet.png"];
    if(self){
        [self setType: FTDrinkSpriteCan];
    }
    return self;
}

- (FTDrinkSpriteType)type{
    return type;
}

- (void)setType:(FTDrinkSpriteType)t{
    type = t;
    [self setTextureRect: CGRectMake(125 + type * 10, 0, 7, 7)];
}

@end
