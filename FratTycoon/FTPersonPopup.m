//
//  FTPersonPopup.m
//  FratTycoon
//
//  Created by Billy Connolly on 5/9/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTPersonPopup.h"
#import "GameScene.h"

@implementation FTPersonPopup

- (id)initWithGameScene:(GameScene *)gs{
    self = [super init];
    if(self){
        gameScene = gs;
        
        background = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(0, 100, 320, 140)];
        [background setAnchorPoint: ccp(0,0)];
        [self addChild: background];
        
        nameLabel = [[CCLabelTTF alloc] initWithString:@"Name" fontName:@"Palatino" fontSize:16.0f];
        [nameLabel setAnchorPoint: ccp(0, 0.5f)];
        [nameLabel setPosition: ccp(26, 31)];
        [nameLabel setHorizontalAlignment: CCTextAlignmentLeft];
        [self addChild: nameLabel];
        
        personPreviewSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"PeopleSheet.png"] rect:CGRectMake(150, 15, 48, 48)];
        [personPreviewSprite setPosition: ccp(60, 90)];
        [self addChild: personPreviewSprite];
        
        hotnessQuantity = [[FTQuantityBar alloc] initWithFillSpriteNumber: 0];
        intelligenceQuantity = [[FTQuantityBar alloc] initWithFillSpriteNumber: 1];
        happinessQuantity = [[FTQuantityBar alloc] initWithFillSpriteNumber: 2];
        sicknessQuantity = [[FTQuantityBar alloc] initWithFillSpriteNumber: 3];
        thirstQuantity = [[FTQuantityBar alloc] initWithFillSpriteNumber: 1];
        bladderQuantity = [[FTQuantityBar alloc] initWithFillSpriteNumber: 2];
        
        [hotnessQuantity setPosition: ccp(215, 120)];
        [intelligenceQuantity setPosition: ccp(215, 100)];
        [happinessQuantity setPosition: ccp(215, 80)];
        [sicknessQuantity setPosition: ccp(215, 60)];
        [thirstQuantity setPosition: ccp(215, 40)];
        [bladderQuantity setPosition: ccp(215, 20)];
        
        [self addChild: hotnessQuantity];
        [self addChild: intelligenceQuantity];
        [self addChild: happinessQuantity];
        [self addChild: sicknessQuantity];
        [self addChild: thirstQuantity];
        [self addChild: bladderQuantity];
        
        [self setUserInteractionEnabled: YES];
        [self setContentSize: CGSizeMake(320, 140)];
        
        showing = NO;
    }
    return self;
}

- (void)setDataWithDictionary:(NSDictionary *)personDict{
    [nameLabel setString: [personDict objectForKey: @"name"]];
    if([[personDict valueForKey: @"male"] boolValue] == YES){
        [personPreviewSprite setTextureRect: CGRectMake(150, 15, 48, 48)];
    }else{
        [personPreviewSprite setTextureRect: CGRectMake(150, 65, 48, 48)];
    }
    
    [hotnessQuantity setQuantity: [[personDict valueForKey: @"hotness"] floatValue]];
    [intelligenceQuantity setQuantity: [[personDict valueForKey: @"intelligence"] floatValue]];
    [happinessQuantity setQuantity: [[personDict valueForKey: @"happiness"] floatValue]];
    [sicknessQuantity setQuantity: [[personDict valueForKey: @"sickness"] floatValue]];
    [thirstQuantity setQuantity: [[personDict valueForKey: @"thirst"] floatValue]];
    [bladderQuantity setQuantity: [[personDict valueForKey: @"bladder"] floatValue]];
}

- (void)setShowing:(BOOL)sh{
    if(sh && !showing){
        [self setPosition: ccp(0, -140)];
        
        [self runAction: [CCActionMoveTo actionWithDuration:0.4f position:ccp(0,0)]];
    }else if(!sh && showing){
        [self setPosition: ccp(0,0)];
        
        [self runAction: [CCActionMoveTo actionWithDuration:0.4f position:ccp(0,-140)]];
    }
    
    showing = sh;
}

- (BOOL)showing{
    return showing;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if(showing && ![gameScene panning] && CGRectContainsPoint(CGRectMake(0, 0, [[CCDirector sharedDirector] viewSize].width, 140), loc)){
        tapTime = CFAbsoluteTimeGetCurrent();
        
        dragStartLocation = loc;
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if(showing && ![gameScene panning] && CGRectContainsPoint(CGRectMake(0, 0, [[CCDirector sharedDirector] viewSize].width, 140), loc)){
        if(dragStartLocation.y - loc.y > 20){
            [gameScene deselectPerson];
        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if(showing && ![gameScene panning] && CFAbsoluteTimeGetCurrent() - tapTime < 0.25 && ccpLength(ccpSub(loc, dragStartLocation)) < 10){
        NSLog(@"Tap at (%f, %f)", loc.x, loc.y);
    }
}

@end
