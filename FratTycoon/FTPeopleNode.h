//
//  FTPeopleNode.h
//  FratTycoon
//
//  Created by Billy Connolly on 2/24/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

#define MAX_PEOPLE 200
#define STATIC_COLLISION_TYPE 2
#define PERSON_COLLISION_TYPE 3
#define DECORATION_COLLISION_TYPE 4

@class FTHouseNode;

typedef enum{
    FTPersonStateStanding = 0,
    FTPersonStateWalking,
    FTPersonStateUsing
}FTPersonState;

/*typedef struct FTPerson{
    CCSprite *bodySprite;
    CCSprite *headSprite;
    CCSprite *feetSprite;
    CCSprite *selectionSprite;
    
    NSDictionary *personData;
    
    BOOL selected;
    
    BOOL animatingFeet;
    
    cpShape *shape;
    FTPersonState currentState;
    cpBody *staticTargetBody;
    cpConstraint *pivotJoint;
    CGPoint path[200];
    int currentPathIndex;
    
    NSDictionary *useDecoration;
    CFAbsoluteTime useStart;
    
    CGPoint lookAtPoint;
    
    float walkSpeed;
}FTPerson;*/

@interface FTPeopleNode : CCNode {
    CCSpriteBatchNode *sprites;
    ChipmunkSpace *space;
        
    NSArray *walkingAnimation;
    
    NSMutableDictionary *contactTimes;
    
    NSMutableArray *peopleData;
    //struct FTPerson peopleData[MAX_PEOPLE];
    int personIndex;
}

@property (nonatomic, retain) CCSpriteBatchNode *sprites;
@property (nonatomic, retain) ChipmunkSpace *space;

@property (nonatomic, retain) FTHouseNode *houseNode;

- (void)addRandomPersonAt:(CGPoint)pt;
- (void)createPhysicsBounds;

- (void)personChangeState:(int)personInd newState:(FTPersonState)newState;
- (void)personWalkTo:(int)personInd point:(CGPoint)point;
- (void)personUseDecoration:(int)personInd decorationDict:(NSDictionary *)decDict walkToStart:(BOOL)walkToStart;

- (int)personAtPoint:(CGPoint)point;
- (void)personSetSelected:(int)personInd selected:(BOOL)selected;
- (NSDictionary *)personGetData:(int)personInd;

- (CGPoint)transformPoint:(CGPoint)pt decRot:(int)rot decSX:(int)sx decSY:(int)sy decPos:(CGPoint)p;

@end