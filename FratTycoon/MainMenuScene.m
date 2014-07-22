//
//  MainMenuScene.m
//  FratTycoon
//
//  Created by Billy Connolly on 4/23/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "MainMenuScene.h"
#import "CampusScene.h"
#import "GameScene.h"
#import "CCButton.h"
#import "GameScene.h"

@implementation MainMenuScene

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	MainMenuScene *layer = [MainMenuScene node];
	[scene addChild: layer];
	return scene;
}

- (id)init{
    self = [super init];
    if(self){
        CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(125, 125, 125, 255)]];
        [self addChild: background];
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Frat Tycoon" fontName:@"Palatino" fontSize:48.0f];
        [title setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height - 64)];
        [self addChild: title];
        
        CCButton *createButton = [CCButton buttonWithTitle:@"Create New" fontName:@"Palatino" fontSize:36];
        CCButton *resumeButton = [CCButton buttonWithTitle:@"Resume" fontName:@"Palatino" fontSize:36];
        CCButton *optionsButton = [CCButton buttonWithTitle:@"Options" fontName:@"Palatino" fontSize:36];
        
        [createButton setTarget:self selector:@selector(createNew)];
        [resumeButton setTarget:self selector:@selector(resume)];
        [optionsButton setTarget:self selector:@selector(options)];
        
        CCLayoutBox *layout = [[CCLayoutBox alloc] init];
        [layout setDirection: CCLayoutBoxDirectionVertical];
        [layout addChild: optionsButton];
        [layout addChild: resumeButton];
        [layout addChild: createButton];
        [layout setSpacing: 10];
        [layout layout];
        [layout setAnchorPoint: ccp(0.5, 0.5)];
        [layout setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2)];
        [self addChild: layout];
    }
    return self;
}

- (void)createNew{
    [[CCDirector sharedDirector] pushScene: [GameScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

- (void)resume{
    [[CCDirector sharedDirector] pushScene: [CampusScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

- (void)options{
    
}

@end
