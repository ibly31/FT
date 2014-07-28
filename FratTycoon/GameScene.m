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
        [levelStack setPosition: ccp([[CCDirector sharedDirector] viewSize].width - 23, [[CCDirector sharedDirector] viewSize].height - 46)];
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
        
        viewButton = [CCButton buttonWithTitle:@"View" fontName:@"Palatino" fontSize:24];
        [viewButton setHorizontalPadding: 10];
        [viewButton setVerticalPadding: 5];
        [viewButton setLabelColor:[CCColor blackColor] forState:CCControlStateNormal];
        [viewButton setLabelColor:[CCColor blackColor] forState:CCControlStateHighlighted];
        [viewButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Button.png"] forState:CCControlStateNormal];
        [viewButton setTarget:self selector:@selector(changeViewMode)];
        [viewButton setPosition: ccp(5, [[CCDirector sharedDirector] viewSize].height - 50)];
        [viewButton setAnchorPoint: ccp(0, 1)];
        [viewButton setZoomWhenHighlighted: NO];
        [self addChild: viewButton z: 2];
        
        [self setContentSize: [[CCDirector sharedDirector] viewSize]];
        [self setUserInteractionEnabled: YES];
        
        selectedPerson = -1;
        
        [self setViewMode: @"PeopleTrashDecorationsWalls"];
        
        panOffset = [houseNode position];
        panStartLocation = ccp(0,0);
        self.panning = NO;
        
        [self schedule:@selector(updatePersonPopup) interval:0.2f];
    }
    return self;
}

- (void)goBack{
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionCrossFadeWithDuration: 0.5f]];
}

- (void)setViewMode:(NSString *)vm{
    viewMode = [vm lowercaseString];
    BOOL showPeople = ([viewMode rangeOfString:@"people"].location != NSNotFound);
    BOOL showTrash = ([viewMode rangeOfString:@"trash"].location != NSNotFound);
    BOOL showDecorations = ([viewMode rangeOfString:@"decorations"].location != NSNotFound);
    BOOL showWalls = ([viewMode rangeOfString:@"walls"].location != NSNotFound);
    BOOL showDebug = ([viewMode rangeOfString:@"debug"].location != NSNotFound);
    
    if([vm characterAtIndex: 0] == '-'){
        if(showPeople)
            [[houseNode peopleNode] setVisible: NO];
        if(showTrash)
            [[houseNode trashNode] setVisible: NO];
        if(showDecorations)
            [[houseNode decorationNode] setVisible: NO];
        if(showWalls)
            [[houseNode structureNode] setVisible: NO];
        if(showDebug)
            [[[houseNode peopleNode] debugNode] setVisible: NO];

    }else if([vm characterAtIndex: 0] == '+'){
        if(showPeople)
            [[houseNode peopleNode] setVisible: YES];
        if(showTrash)
            [[houseNode trashNode] setVisible: YES];
        if(showDecorations)
            [[houseNode decorationNode] setVisible: YES];
        if(showWalls)
            [[houseNode structureNode] setVisible: YES];
        if(showDebug)
            [[[houseNode peopleNode] debugNode] setVisible: YES];
        
    }else{
        [[houseNode peopleNode] setVisible: showPeople];
        [[houseNode trashNode] setVisible: showTrash];
        [[houseNode decorationNode] setVisible: showDecorations];
        [[houseNode structureNode] setVisible: showWalls];
        [[[houseNode peopleNode] debugNode] setVisible: showDebug];
    }
}

- (void)changeViewMode{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter View Mode" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    [alert setAlertViewStyle: UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSString *newViewMode = [[alertView textFieldAtIndex: 0] text];
        [self setViewMode: newViewMode];
    }
}

- (void)updatePersonPopup{
    if(selectedPerson != -1){
        [personPopup setDataWithDictionary: [[houseNode peopleNode] personGetData: selectedPerson]];
    }
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
            
            NSMutableDictionary *decAt = [houseNode decorationAtTapLocation: mapLoc];
            
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
