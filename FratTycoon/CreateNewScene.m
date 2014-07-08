//
//  CreateNewScene.m
//  FratTycoon
//
//  Created by Billy Connolly on 4/23/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "CreateNewScene.h"
#import "GameScene.h"

@implementation CreateNewScene

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	CreateNewScene *layer = [CreateNewScene node];
	[scene addChild: layer];
	return scene;
}

- (id)init{
    self = [super init];
    if(self){
        CCNodeColor *background = [CCNodeColor nodeWithColor: [CCColor colorWithCcColor4b: ccc4(155, 155, 155, 255)]];
        [self addChild: background];
        
        letterOne = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(0, 192, 96, 96)];
        letterTwo = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(96, 192, 96, 96)];
        letterThr = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(192, 192, 96, 96)];
        
        [letterOne setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2 - 96, [[CCDirector sharedDirector] viewSize].height / 2 + 133)];
        [letterTwo setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2 + 133)];
        [letterThr setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2 + 96, [[CCDirector sharedDirector] viewSize].height / 2 + 133)];
        
        [self addChild: letterOne];
        [self addChild: letterTwo];
        [self addChild: letterThr];
        
        CCSprite *upArrowSpriteOne = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(384, 384, 96, 96)];
        CCSprite *upArrowSpriteTwo = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(384, 384, 96, 96)];
        CCSprite *upArrowSpriteThr = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(384, 384, 96, 96)];

        CCSprite *downArrowSpriteOne = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(384, 384, 96, 96)];
        CCSprite *downArrowSpriteTwo = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(384, 384, 96, 96)];
        CCSprite *downArrowSpriteThr = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"SquareLetters.png"] rect:CGRectMake(384, 384, 96, 96)];
        
        [downArrowSpriteOne setFlipY: YES];
        [downArrowSpriteTwo setFlipY: YES];
        [downArrowSpriteThr setFlipY: YES];
        
        /*CCMenuItemImage *upArrowOne = [CCMenuItemImage itemWithNormalSprite:upArrowSpriteOne selectedSprite:nil target:self selector:@selector(upArrowOne)];
        CCMenuItemImage *upArrowTwo = [CCMenuItemImage itemWithNormalSprite:upArrowSpriteTwo selectedSprite:nil target:self selector:@selector(upArrowTwo)];
        CCMenuItemImage *upArrowThr = [CCMenuItemImage itemWithNormalSprite:upArrowSpriteThr selectedSprite:nil target:self selector:@selector(upArrowThree)];
        
        CCMenuItemImage *downArrowOne = [CCMenuItemImage itemWithNormalSprite:downArrowSpriteOne selectedSprite:nil target:self selector:@selector(downArrowOne)];
        CCMenuItemImage *downArrowTwo = [CCMenuItemImage itemWithNormalSprite:downArrowSpriteTwo selectedSprite:nil target:self selector:@selector(downArrowTwo)];
        CCMenuItemImage *downArrowThr = [CCMenuItemImage itemWithNormalSprite:downArrowSpriteThr selectedSprite:nil target:self selector:@selector(downArrowThree)];

        [upArrowOne setPosition: ccp(-96, 30)];
        [upArrowTwo setPosition: ccp(0, 30)];
        [upArrowThr setPosition: ccp(96, 30)];
        
        [downArrowOne setPosition: ccp(-96, -90)];
        [downArrowTwo setPosition: ccp(0, -90)];
        [downArrowThr setPosition: ccp(96, -90)];
        
        CCMenu *menu = [[CCMenu alloc] initWithArray:@[upArrowOne, upArrowTwo, upArrowThr, downArrowOne, downArrowTwo, downArrowThr]];
        [menu setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2 + 160)];
        [self addChild: menu];
        
        CCLabelTTF *createLabel = [CCLabelTTF labelWithString:@"Create" fontName:@"Palatino" fontSize:36.0f];
        CCMenuItemLabel *create = [CCMenuItemLabel itemWithLabel:createLabel target:self selector:@selector(create)];
                                        
        CCMenu *createMenu = [[CCMenu alloc] initWithArray:@[create]];
        [createMenu setPosition:ccp([[CCDirector sharedDirector] viewSize].width / 2, 140)];
        [self addChild: createMenu];*/
        
        letOneInd = 10;
        letTwoInd = 11;
        letThrInd = 12;
    }
    return self;
}

- (void)create{
    [[CCDirector sharedDirector] replaceScene: [GameScene scene] withTransition: [CCTransition transitionCrossFadeWithDuration: 0.5f]];
}

- (void)upArrowOne{
    if(--letOneInd < 0)
        letOneInd = 0;
    [letterOne setTextureRect: CGRectMake((letOneInd % 5) * 96, (letOneInd / 5) * 96, 96, 96)];
}

- (void)upArrowTwo{
    if(--letTwoInd < 0)
        letTwoInd = 0;
    [letterTwo setTextureRect: CGRectMake((letTwoInd % 5) * 96, (letTwoInd / 5) * 96, 96, 96)];
}

- (void)upArrowThree{
    if(--letThrInd < 0)
        letThrInd = 0;
    [letterThr setTextureRect: CGRectMake((letThrInd % 5) * 96, (letThrInd / 5) * 96, 96, 96)];
}

- (void)downArrowOne{
    if(++letOneInd > 23)
        letOneInd = 23;
    [letterOne setTextureRect: CGRectMake((letOneInd % 5) * 96, (letOneInd / 5) * 96, 96, 96)];
}

- (void)downArrowTwo{
    if(++letTwoInd > 23)
        letTwoInd = 23;
    [letterTwo setTextureRect: CGRectMake((letTwoInd % 5) * 96, (letTwoInd / 5) * 96, 96, 96)];
}

- (void)downArrowThree{
    if(++letThrInd > 23)
        letThrInd = 23;
    [letterThr setTextureRect: CGRectMake((letThrInd % 5) * 96, (letThrInd / 5) * 96, 96, 96)];
}

@end
