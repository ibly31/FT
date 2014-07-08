//
//  FTMinigameBPCup.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/17/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTMinigameBPCup.h"

@implementation FTMinigameBPCup
@synthesize beerSprite;

- (id)init{
    self = [super initWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 360, 20, 20)];
    if(self){
        self.beerSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(21, 360, 20, 20)];
        [beerSprite setPosition: ccp(10, 10)];
        [self addChild: beerSprite];
        
    }
    return self;
}

@end
