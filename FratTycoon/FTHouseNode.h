//
//  FTHouseNode.h
//  FratTycoon
//
//  Created by Billy Connolly on 2/12/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"
#import "FTStructureNode.h"
#import "FTDecorationNode.h"
#import "FTPeopleNode.h"
#import "FTConstants.h"
#import "FTLevelStack.h"

@class GameScene;

@interface FTHouseNode : CCNode <FTLevelStackDelegate>{
    FTPeopleNode *peopleNode;
    FTDecorationNode *decorationNode;
    FTStructureNode *structureNode;
    FTStructureNode *floorMapNode;
    
    NSSet *startingClosedSet;
    int blocked[HOUSELOT_HEIGHT * 2][HOUSELOT_WIDTH * 2];
    float openWeights[HOUSELOT_HEIGHT * 2][HOUSELOT_WIDTH * 2];
    
    NSMutableArray *levels;
    int currentLevel;
    
    NSMutableArray *currentRooms;
        
    int width;
    int height;
}

- (id)initWithGameScene:(GameScene *)gs;

@property (nonatomic, retain) FTPeopleNode *peopleNode;
@property (nonatomic, retain) FTDecorationNode *decorationNode;
@property (nonatomic, retain) FTStructureNode *structureNode;
@property (nonatomic, retain) FTStructureNode *floorMapNode;

@property (nonatomic, retain) GameScene *gameScene;

@property int width;
@property int height;

- (void)resetHouseData;
- (void)readHouseData:(NSDictionary *)houseData;
- (void)addRoom:(NSString *)roomName x:(int)xx y:(int)yy rot:(int)rot;
- (NSDictionary *)decorationAtTapLocation:(CGPoint)tap;
- (NSArray *)findPathFrom:(CGPoint)start end:(CGPoint)end;
- (BOOL)pointCanSpawnPerson:(CGPoint)pt;

@end
