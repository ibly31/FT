//
//  CampusScene.h
//  FratTycoon
//
//  Created by Billy Connolly on 4/25/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"
#import "FTConstants.h"
#import "FTStructureNode.h"

@interface CampusScene : CCNode {
    CCNode *campus;
    FTStructureNode *structureNode;
    CCSpriteBatchNode *buildingNode;
    
    CCButton *backButton;
    
    ccColor3B houseColors[8];
    
    NSMutableArray *blocks;
        
    NSMutableArray *frats;
    NSMutableArray *soros;
    NSMutableArray *buildings;
    
    NSArray *fratDefs;
    NSArray *soroDefs;
    
    BOOL showingLetters;
    
    int width;
    int height;
    
    int blockWidths[CAMPUS_BLOCKS_ACROSS];
    int blockHeights[CAMPUS_BLOCKS_DOWN];
    int mainStreet;
    
    CGPoint panStartLocation;
    NSTimeInterval tapTime;
    CGPoint panOffset;
    
    BOOL panning;
}

+ (CCScene *) scene;

- (void)flipLabels;

@end
