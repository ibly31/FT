//
//  GameScene.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/12/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "GameScene.h"
#import "EditorScene.h"
#import "FTPhysicsDebugNode.h"

@implementation GameScene
@synthesize houseNode;

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}

- (id)init{
    self = [super init];
    if(self){
        CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(125, 125, 125, 255)]];
        [self addChild: background];
        
        self.houseNode = [[FTHouseNode alloc] initWithGameScene: self];
        [houseNode setPosition: ccp(-80, -280)];
        [self addChild: houseNode];
        
        personPopup = [[FTPersonPopup alloc] initWithGameScene: self];
        [personPopup setPosition: ccp(0, -140)];
        [self addChild: personPopup];
        
        levelStack = [[FTLevelStack alloc] initWithLevels: @[@"l1",@"l2"]];
        [levelStack setDelegate: houseNode];
        [levelStack setPosition: ccp([[CCDirector sharedDirector] viewSize].width - 30, [[CCDirector sharedDirector] viewSize].height - 65)];
        [self addChild: levelStack];
        
        [levelStack setCurrentLevel: 0];
        
        backButton = [CCButton buttonWithTitle:@"Back" fontName:@"Palatino" fontSize:28];
        [backButton setHorizontalPadding: 10];
        [backButton setVerticalPadding: 5];
        [backButton setLabelColor:[CCColor blackColor] forState:CCControlStateNormal];
        [backButton setLabelColor:[CCColor blackColor] forState:CCControlStateHighlighted];
        [backButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Button.png"] forState:CCControlStateNormal];
        [backButton setBackgroundColor:[CCColor lightGrayColor] forState:CCControlStateHighlighted];
        [backButton setTarget:self selector:@selector(goBack)];
        [backButton setPosition: ccp(5, [[CCDirector sharedDirector] viewSize].height - 5)];
        [backButton setAnchorPoint: ccp(0, 1)];
        [backButton setZoomWhenHighlighted: NO];
        [self addChild: backButton z:2];
        
        debugButton = [CCButton buttonWithTitle:@"Debug" fontName:@"Palatino" fontSize:24];
        [debugButton setHorizontalPadding: 10];
        [debugButton setVerticalPadding: 5];
        [debugButton setLabelColor:[CCColor blackColor] forState:CCControlStateNormal];
        [debugButton setLabelColor:[CCColor blackColor] forState:CCControlStateHighlighted];
        [debugButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Button.png"] forState:CCControlStateNormal];
        [debugButton setTarget:self selector:@selector(toggleDebug)];
        [debugButton setPosition: ccp(5, [[CCDirector sharedDirector] viewSize].height - 50)];
        [debugButton setAnchorPoint: ccp(0, 1)];
        [debugButton setZoomWhenHighlighted: NO];
        [self addChild: debugButton z: 2];
        
        [self setContentSize: [[CCDirector sharedDirector] viewSize]];
        [self setUserInteractionEnabled: YES];
        
        selectedPerson = -1;
        
        panOffset = [houseNode position];
        panStartLocation = ccp(0,0);
        self.panning = NO;
    }
    return self;
}

- (void)goBack{
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionCrossFadeWithDuration: 0.5f]];
}

- (void)toggleDebug{
    FTPhysicsDebugNode *debugNode = [[houseNode peopleNode] debugNode];
    [debugNode setVisible: ![debugNode visible]];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [houseNode convertToNodeSpace: [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]]];
    
    if(CGRectContainsPoint(CGRectMake(0, 0, [houseNode width] * 24, [houseNode height] * 24), loc)){
        CGPoint loc2 = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];

        if((![personPopup showing] || !CGRectContainsPoint(CGRectMake(0, 0, [[CCDirector sharedDirector] viewSize].width, 140), loc2))){
            tapTime = CFAbsoluteTimeGetCurrent();
            
            panStartLocation = loc2;
            
            self.panning = YES;
        }
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if(self.panning){
        if(ccpDistance(loc, panStartLocation) > 10.0f){
            [houseNode setPosition: ccpAdd(panOffset, ccpSub(loc, panStartLocation))];
        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if((![personPopup showing] || !CGRectContainsPoint(CGRectMake(0, 0, [[CCDirector sharedDirector] viewSize].width, 140), loc))){
        if(CFAbsoluteTimeGetCurrent() - tapTime < 0.25 && ccpLength(ccpSub(loc, panStartLocation)) < 10){
            CGPoint mapLoc = [houseNode convertToNodeSpace: ccpMidpoint(loc, panStartLocation)]; // average both to eliminate error
            
            NSLog(@"Tap at %@", NSStringFromCGPoint(mapLoc));
            
            NSDictionary *decAt = [houseNode decorationAtTapLocation: mapLoc];
            
            if(decAt == nil){
                int whichPerson = [[houseNode peopleNode] personAtPoint: mapLoc];
                
                if(whichPerson != -1){
                    if(selectedPerson != -1)
                        [[houseNode peopleNode] personSetSelected:selectedPerson selected:NO];
                    
                    selectedPerson = whichPerson;
                    [[houseNode peopleNode] personSetSelected:selectedPerson selected:YES];
                    [personPopup setDataWithDictionary: [[houseNode peopleNode] personGetData: selectedPerson]];
                    [personPopup setShowing: YES];
                }else{
                    if(selectedPerson != -1){
                        [[houseNode peopleNode] personWalkTo:selectedPerson point:mapLoc];
                    }
                }
            }else if([[decAt objectForKey:@"name"] isEqualToString:@"studytable"]){
                [[CCDirector sharedDirector] replaceScene:[EditorScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration: 0.5f]];
            }else{
                if(selectedPerson != -1){
                    [[houseNode peopleNode] personUseDecoration:selectedPerson decorationDict:decAt walkToStart: YES];
                }
            }
        }
    }
    
    panOffset = [houseNode position];
    self.panning = NO;
}

- (void)deselectPerson{
    [[houseNode peopleNode] personSetSelected:selectedPerson selected:NO];
    selectedPerson = -1;
    [personPopup setShowing: NO];
}

@end
