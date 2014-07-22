//
//  FTEditorRoomPicker.m
//  FratTycoon
//
//  Created by Billy Connolly on 3/13/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTEditorRoomPicker.h"
#import "FTRoomRenderer.h"
#import "EditorScene.h"
#import "FTModel.h"

@implementation FTEditorRoomPicker

- (id)initWithEditorScene:(EditorScene *)es{
    self = [super init];
    if(self){
        editorScene = es;
        
        CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(255, 255, 255, 255)] width:[[CCDirector sharedDirector] viewSize].width height:140];
        [self addChild: background];
        
        dragging = NO;
        movedPast = NO;
        
        renderer = [[FTRoomRenderer alloc] init];
        
        slider = [[CCNode alloc] init];
        sliderSize = CGSizeMake(0, 120);
        
        int index = 0;
        for(NSDictionary *room in [renderer roomRenders]){
            CCSprite *sprite = [[CCSprite alloc] initWithTexture: [room objectForKey:@"texture"]];
            CGSize spriteSize = [sprite boundingBox].size;
            float biggerSize = max(spriteSize.width, spriteSize.height);
            biggerSize = (biggerSize < 100) ? 100 : biggerSize;
            
            [sprite setScale: 100.0f / biggerSize];
            [sprite setPosition: ccp(index * 120 + 60, 80)];
            
            CCNodeColor *backg = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(55, 55, 55, 255)] width:110 height:110];
            [backg setPosition: ccp(index * 120 + 5, 25)];
                        
            CCLabelTTF *nameLabel = [[CCLabelTTF alloc] initWithString:[room objectForKey:@"displayname"] fontName:@"Arial" fontSize:16.0f];
            [nameLabel setColor: [CCColor colorWithCcColor3b: ccc3(0, 0, 0)]];
            [nameLabel setPosition: ccp(index * 120 + 60, 14)];
            
            CCLabelTTF *costLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"$%@", [room objectForKey:@"cost"]] fontName:@"Arial" fontSize:16.0f];
            [costLabel setColor: [CCColor colorWithCcColor3b: ccc3(240, 190, 95)]];
            [costLabel setAnchorPoint: ccp(1, 0)];
            [costLabel setPosition: ccp(index * 120 + 110, 25)];
            
            CCNodeColor *costBackg = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(200, 200, 200, 125)] width:110 height:[costLabel boundingBox].size.height];
            [costBackg setPosition: ccp(index * 120 + 5, 25)];
            
            [slider addChild: backg];
            [slider addChild: sprite];
            [slider addChild: nameLabel];
            [slider addChild: costBackg];
            [slider addChild: costLabel];
            
            sliderSize = CGSizeMake(max(sliderSize.width, backg.boundingBox.origin.x + backg.boundingBox.size.width), sliderSize.height);
            
            index++;
        }
        [self addChild: slider];
        NSLog(@"Slider size: %f %f", sliderSize.width, sliderSize.height);
        
        [self setContentSize: sliderSize];
        [self setUserInteractionEnabled: YES];
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if(CGRectContainsPoint(CGRectMake(0, 0, [[CCDirector sharedDirector] viewSize].width, 120), loc)){
        tapTime = CFAbsoluteTimeGetCurrent();
        
        dragStartLocation = loc;
        dragging = YES;
        movedPast = NO;
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];

    if(dragging){
        if(loc.y - dragStartLocation.y > 40){
            CGPoint sliderLoc = [slider convertToNodeSpace: loc];
            int whichRoom = sliderLoc.x / 120.0f;
            NSDictionary *room = [[[FTRoomRenderer sharedRenderer] roomBlueprints] objectAtIndex: whichRoom];
            CCSprite *roomSprite = [[CCSprite alloc] initWithTexture: [room objectForKey:@"texture"]];
            CGSize spriteSize = [roomSprite boundingBox].size;

            float biggerSize = max(spriteSize.width, spriteSize.height);
            biggerSize = (biggerSize < 100) ? 100 : biggerSize;
            
            dragging = NO;
            [editorScene beginDragDropFrom:ccp(whichRoom * 120 + 60 + slider.position.x, 80) to:loc withStartScale:100.0f / biggerSize withRoomName:[room objectForKey: @"name"]];
        }
        if(fabsf(dragStartLocation.x - loc.x) > 5.0f || movedPast){
            CGPoint newPosition = ccpAdd(dragOffset, ccp(loc.x - dragStartLocation.x, 0));
            if(newPosition.x > 0)
                newPosition.x = 0;
            if(newPosition.x < -(sliderSize.width - [[CCDirector sharedDirector] viewSize].width) - 5)
                newPosition.x = -(sliderSize.width - [[CCDirector sharedDirector] viewSize].width) - 5;
            
            [slider setPosition: newPosition];
            movedPast = YES;
        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];

    if(CFAbsoluteTimeGetCurrent() - tapTime < 0.25 && ccpLength(ccpSub(loc, dragStartLocation)) < 10){
        NSLog(@"Tap at (%f, %f)", loc.x, loc.y);
    }else{
        dragOffset = [slider position];
        dragging = NO;
    }
}

@end
