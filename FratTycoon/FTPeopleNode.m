//
//  FTPeopleNode.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/24/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTPeopleNode.h"
#import "FTHouseNode.h"
#import "GameScene.h"
#import "FTModel.h"
#import "FTWalkingState.h"
#import "FTStandingState.h"
#import "FTUsingSequentialState.h"
#import "FTGettingDrinkState.h"
#import "CCAnimation.h"

@implementation FTPeopleNode
@synthesize sprites;
@synthesize space;
@synthesize drinkContainers;
@synthesize debugNode;
@synthesize houseNode;
@synthesize decorationNode;

- (id)init{
    self = [super init];
    if(self){
        self.sprites = [[CCSpriteBatchNode alloc] initWithFile:@"PeopleSheet.png" capacity:MAX_PEOPLE * 4];
        [self addChild: sprites];
        
        self.space = [[ChipmunkSpace alloc] init];
        cpSpaceUseSpatialHash([space space], 7, 10 * MAX_PEOPLE);
        [space setGravity: ccp(0, -10)];
        [space setIterations: 3];
        
        [space addCollisionHandler:self typeA:PERSON_COLLISION_TYPE typeB:PERSON_COLLISION_TYPE begin:@selector(collisionPersonPersonBegin:space:userData:) preSolve:@selector(collisionPersonPersonPreSolve:space:userData:) postSolve:nil separate:@selector(collisionPersonPersonSeparate:space:userData:)];
        [space addCollisionHandler:self typeA:PERSON_COLLISION_TYPE typeB:DECORATION_COLLISION_TYPE begin:@selector(collisionPersonDecorationBegin:space:userData:) preSolve:nil postSolve:nil separate:nil];
        
        /*self.debugNode = [[FTPhysicsDebugNode alloc] init];
        [debugNode setSpace: space];
        [self addChild: debugNode z: 1000];*/
        
        //[space addCollisionHandler:self typeA:PERSON_COLLISION_TYPE typeB:PERSON_COLLISION_TYPE begin:@selector(personCollision:arbiter:space:) preSolve:@selector(personCollision:arbiter:space:) postSolve:@selector(personCollision:arbiter:space:) separate:@selector(personCollision:arbiter:space:)];
        
        //debugLayer = [[CPDebugLayer alloc] initWithSpace:[spaceManager space] options:nil];
        //[self addChild: debugLayer];
        
        peopleData = [[NSMutableArray alloc] initWithCapacity: MAX_PEOPLE];
        
        CGSize originalSize = [[sprites texture] contentSizeInPixels];
        CGRect rectInPixels = CGRectMake(0, 50, 48, 48);
        float rectInPixelsChange = 50;
        
        if([[UIScreen mainScreen] scale] == 1.0){
            rectInPixels = CGRectMake(0, 25, 24, 24);
            rectInPixelsChange = 25;
        }
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk1"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk2"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk3"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk4"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk5"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk6"];
        
        rectInPixels = CGRectMake(0, 100, 48, 48);
        if([[UIScreen mainScreen] scale] == 1.0){
            rectInPixels = CGRectMake(0, 50, 24, 24);
            rectInPixelsChange = 25;
        }
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk7"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk8"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk9"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk10"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk11"]; rectInPixels.origin.x += rectInPixelsChange;
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:originalSize] name:@"walk12"];
        
        NSMutableArray *walkAnim = [[NSMutableArray alloc] initWithCapacity:24];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk1"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk2"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk3"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk4"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk5"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk6"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk5"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk4"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk3"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk2"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk1"]];
        
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk7"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk8"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk9"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk10"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk11"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk12"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk11"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk10"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk9"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk8"]];
        [walkAnim addObject: [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"walk7"]];
        
        walkingAnimation = walkAnim;
        
        personIndex = 0;
        
        [self scheduleOnce:@selector(spawnPeople) delay:0.05f];
        [self scheduleOnce:@selector(resetTargetBodies) delay:2.0f];
        [self schedule:@selector(printInfo) interval:0.2f repeat:CCTimerRepeatForever delay:0.0f];
        
        contactTimes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

bool checkPersonIndex(int personInd, int numPeople){
    if(personInd < numPeople && personInd >= 0){
        return YES;
    }else{
        NSLog(@"PersonIndex %i out of bounds", personInd);
        return NO;
    }
}

- (void)spawnPeople{
    for(int peopleToSpawn = 60; peopleToSpawn > 0; peopleToSpawn--){
        while(YES){
            CGPoint try = ccp(CCRANDOM_0_1() * HOUSELOT_WIDTH * 24, CCRANDOM_0_1() * HOUSELOT_HEIGHT * 24);
            if([houseNode pointCanSpawnPerson: try]){
                [self addRandomPersonAt:try];
                break;
            }
        }
    }
}

- (void)resetTargetBodies{
    for(int i = 0; i < personIndex; i++){
        CGPoint bodyPos = [[(ChipmunkShape *)[[peopleData objectAtIndex: i] objectForKey: @"shape"] body] position];
        [(ChipmunkBody *)[[peopleData objectAtIndex: i] objectForKey: @"staticTargetBody"] setPosition: bodyPos];
    }
}

- (void)personChangeState:(int)personInd newState:(FTPersonState *)newState{
    if(checkPersonIndex(personInd, personIndex)){
        NSLog(@"Changing person %i to state %@", personInd, [newState stateName]);
        [[peopleData objectAtIndex: personInd] setObject:newState forKey:@"currentState"];
        [newState setPersonIndex: personInd];
        [newState setPeopleNode: self];
        [newState setPersonData: [peopleData objectAtIndex: personInd]];
        [newState prepare];
    }
}

- (void)personWalkTo:(int)personInd point:(CGPoint)point{
    if(checkPersonIndex(personInd, personIndex)){
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            NSArray *points = [self pointsForPersonWalkTo:personInd point:point];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(points != nil){
                    FTWalkingState *walkingState = [[FTWalkingState alloc] initWithPointArray: points];
                    [self personChangeState:personInd newState:walkingState];
                }
            });
        });
        
    }
}

- (NSArray *)pointsForPersonWalkTo:(int)personInd point:(CGPoint)point{
    ChipmunkBody *personBody = [(ChipmunkShape *)[[peopleData objectAtIndex: personInd] objectForKey: @"shape"] body];
    NSArray *points = [houseNode findPathFrom:[personBody position] end:point];
    if(points != nil){
        return points;
    }else{
        return nil;
    }
}

- (void)personUseDecoration:(int)personInd decorationDict:(NSMutableDictionary *)decDict walkToStart:(BOOL)walkToStart{
    if(checkPersonIndex(personInd, personIndex)){
        if([decDict objectForKey: @"use"] != nil){
            int numUsers = [[decDict objectForKey: @"numusers"] intValue];
            int maxUsers = [[[decDict objectForKey: @"use"] objectForKey: @"maxusers"] intValue];
            
            if(numUsers < maxUsers){
                int rot = [(CCSprite *)[decDict objectForKey: @"sprite"] rotation];
                int scaleX = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleX];
                int scaleY = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleY];
                CGPoint pos = [(CCSprite *)[decDict objectForKey: @"sprite"] position];
                
                numUsers++;
                [decDict setObject:@(numUsers) forKey:@"numusers"];
                
                if([[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential"] || [[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential-link"]){
                    NSArray *usePositionSets = [[decDict objectForKey: @"use"] objectForKey: @"usepositionsets"];
                    NSArray *usePositions = nil;
                    
                    if(usePositionSets != nil){
                        int numusers = [[decDict objectForKey: @"numusers"] intValue];
                        usePositions = [usePositionSets objectAtIndex: numusers - 1];
                    }else{
                        usePositions = [[decDict objectForKey: @"use"] objectForKey: @"usepositions"];
                    }

                    if(usePositions){
                        CGPoint startingPoint = CGPointFromString([usePositions objectAtIndex: 0]);
                        startingPoint = [self transformPoint:startingPoint decRot:rot decSX:scaleX decSY:scaleY decPos:pos];
                        
                        if(walkToStart){
                            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                            dispatch_async(queue, ^{
                                NSArray *points = [self pointsForPersonWalkTo:personInd point:startingPoint];
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    if(points != nil){
                                        FTUsingSequentialState *usingState = [[FTUsingSequentialState alloc] initWithDecorationDict: decDict];
                                        FTWalkingState *walkingState = [[FTWalkingState alloc] initWithPointArray: points];
                                        [walkingState setNextState: usingState];
                                        [self personChangeState:personInd newState:walkingState];
                                    }
                                });
                            });
                        }else{
                            FTUsingSequentialState *usingState = [[FTUsingSequentialState alloc] initWithDecorationDict: decDict];
                            [self personChangeState:personInd newState:usingState];
                        }
                    }
                }else if([[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"getdrink"]){
                    CGPoint usePosition = CGPointFromString([[decDict objectForKey: @"use"] objectForKey: @"useposition"]);
                    
                    CGPoint startingPoint = [self transformPoint:usePosition decRot:rot decSX:scaleX decSY:scaleY decPos:pos];
                    if(walkToStart){
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                        dispatch_async(queue, ^{
                            NSArray *points = [self pointsForPersonWalkTo:personInd point:startingPoint];
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                if(points != nil){
                                    FTGettingDrinkState *drinkState = [[FTGettingDrinkState alloc] initWithDecorationDict: decDict];
                                    FTWalkingState *walkingState = [[FTWalkingState alloc] initWithPointArray: points];
                                    [walkingState setNextState: drinkState];
                                    [self personChangeState:personInd newState:walkingState];
                                }
                            });
                        });
                    }else{
                        FTGettingDrinkState *drinkState = [[FTGettingDrinkState alloc] initWithDecorationDict: decDict];
                        [self personChangeState:personInd newState:drinkState];
                    }
                }
            }
        }
    }
}

- (void)personTakeDrink:(int)personInd drinkType:(FTDrinkSpriteType)type from:(CGPoint)from to:(CGPoint)to{
    if(checkPersonIndex(personInd, personIndex)){
        [peopleData[personInd] setObject:[NSValue valueWithCGPoint:from] forKey:@"drinkOffset"];
        [peopleData[personInd] setObject:[NSValue valueWithCGPoint:to] forKey:@"desiredDrinkOffset"];
        [peopleData[personInd] setObject:@(CFAbsoluteTimeGetCurrent()) forKey:@"drinkStartTime"];
        [peopleData[personInd] setObject:@(1.0) forKey:@"drinkAmountLeft"];
        [(FTDrinkSprite *)[peopleData[personInd] objectForKey:@"drinkSprite"] setType: type];
    }
}

- (int)personAtPoint:(CGPoint)point{
    float shortestDist = INFINITY;
    int shortestIndex = -1;
    for(int i = 0; i < personIndex; i++){
        ChipmunkShape *personShape = [[peopleData objectAtIndex: i] objectForKey: @"shape"];
        ChipmunkBody *personBody = [personShape body];
        float dist = ccpDistance([personBody position], point);
        if(dist < shortestDist){
            shortestDist = dist;
            shortestIndex = i;
        }
    }
    
    if(shortestDist < 16.0f)
        return shortestIndex;
    else
        return -1;
}

- (void)personSetSelected:(int)personInd selected:(BOOL)selected{
    if(checkPersonIndex(personInd, personIndex)){
        [[peopleData objectAtIndex: personInd] setObject:[NSNumber numberWithBool:selected] forKey:@"selected"];
        CCSprite *selectionSprite = (CCSprite *)[[peopleData objectAtIndex: personInd] objectForKey: @"selectionSprite"];
        if(selected){
            [selectionSprite setOpacity: 0];
            [selectionSprite runAction: [CCActionFadeIn actionWithDuration: 0.3f]];
        }else{
            [selectionSprite setOpacity: 1];
            [selectionSprite runAction: [CCActionFadeOut actionWithDuration: 0.3f]];
        }
    }
}

- (NSDictionary *)personGetData:(int)personInd{
    if(checkPersonIndex(personInd, personIndex)){
        return [peopleData objectAtIndex: personInd];
    }
    return nil;
}

- (int)thirstyPersonIndex{
    int attempts = 0;
    while(attempts != personIndex){
        int indexTry = CCRANDOM_0_1() * personIndex;
        FTPersonState *state = [peopleData[indexTry] objectForKey: @"currentState"];
        if([state isKindOfClass: [FTStandingState class]]){
            float thirst = [[peopleData[indexTry] objectForKey: @"thirst"] floatValue];
            if(thirst >= 0.7f)
                return indexTry;
        }
        
        attempts++;
    }
    return -1;
}

- (int)fullBladderPersonIndex{
    int attempts = 0;
    while(attempts != personIndex){
        int indexTry = CCRANDOM_0_1() * personIndex;
        FTPersonState *state = [peopleData[indexTry] objectForKey: @"currentState"];
        if([state isKindOfClass: [FTStandingState class]]){
            float bladder = [[peopleData[indexTry] objectForKey: @"bladder"] floatValue];
            if(bladder >= 0.8f)
                return indexTry;
        }
        
        attempts++;
    }
    return -1;
}

- (int)idlePersonIndex{
    int attempts = 0;
    while(attempts != personIndex){
        int indexTry = CCRANDOM_0_1() * personIndex;
        FTPersonState *state = [peopleData[indexTry] objectForKey: @"currentState"];
        if([state isKindOfClass: [FTStandingState class]]){
            return indexTry;
        }
        
        attempts++;
    }
    return -1;
}

- (void)addRandomPersonAt:(CGPoint)pt{
    BOOL isFemale = (CCRANDOM_0_1() < 0.5f);
    
    CCSprite *feetSprite = [[CCSprite alloc] initWithTexture:[sprites texture] rect:CGRectMake(0, 25, 24, 24)];
    [feetSprite setPosition: pt];
    [sprites addChild: feetSprite z:1];

    CCSprite *bodySprite = [[CCSprite alloc] initWithTexture:[sprites texture] rect:CGRectMake(25 + isFemale * 25, 0, 24, 24)];
    [bodySprite setPosition: pt];
    [sprites addChild: bodySprite z:2];
    
    CCSprite *headSprite = [[CCSprite alloc] initWithTexture:[sprites texture] rect:CGRectMake(75 + isFemale * 25, 0, 14, 14)];
    [headSprite setPosition: pt];
    [sprites addChild: headSprite z:3];
    
    CCSprite *selectionSprite = [[CCSprite alloc] initWithTexture:[sprites texture] rect:CGRectMake(0, 0, 24, 24)];
    [selectionSprite setPosition: pt];
    [selectionSprite setOpacity: 0];
    [selectionSprite setScale: 4.0f / 3.0f];
    [selectionSprite runAction: [CCActionRepeatForever actionWithAction: [CCActionSequence actionOne:[CCActionScaleTo actionWithDuration:0.4 scale:4.4f/3.0f] two:[CCActionScaleTo actionWithDuration:0.4 scale:4.0f/3.0f]]]];
    [sprites addChild: selectionSprite z:4];
    
    FTDrinkSprite *drinkSprite = [[FTDrinkSprite alloc] init];
    [drinkSprite setVisible: NO];
    [sprites addChild: drinkSprite z:5];
    
    ChipmunkBody *body = [ChipmunkBody bodyWithMass:5 andMoment:cpMomentForCircle(5, 0, 7, cpvzero)];
    ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:7 offset:cpvzero];
    ChipmunkBody *staticBody = [ChipmunkBody staticBody];
    ChipmunkShape *staticShape = [ChipmunkCircleShape circleWithBody:staticBody radius:0.0f offset:cpvzero];
    [staticShape setSensor: YES];
    
    [shape setCollisionType: PERSON_COLLISION_TYPE];
    
    [body setPosition: pt];
    [staticBody setPosition: pt];
    
    [space add: body];
    [space add: shape];

    [space add: staticBody];
    [space add: staticShape];
    
    //cpShapeSetCollisionType(shape, PERSON_COLLISION_TYPE);
    //cpShapeSetCollisionType(staticShape, STATIC_COLLISION_TYPE);
    
    ChipmunkConstraint *pivot = [ChipmunkPivotJoint pivotJointWithBodyA:body bodyB:staticBody anchorA:cpvzero anchorB:cpvzero];
    [pivot setMaxBias: 20.0f];
    [pivot setMaxForce: 200.0f];
    [space add: pivot];
    
    NSMutableDictionary *personData = [[NSMutableDictionary alloc] init];
    [personData setValue:[NSNumber numberWithBool: !isFemale] forKey:@"male"];
    NSArray *firstNames = nil;
    if(!isFemale)
        firstNames = (NSArray *)[[FTModel sharedModel] peopleDataPropertyWithName:@"guynames"];
    else
        firstNames = (NSArray *)[[FTModel sharedModel] peopleDataPropertyWithName:@"girlnames"];
    NSString *lastLetters = @"ABCDEFGHJKLMNPRSTWY";
    NSString *actualName = [NSString stringWithFormat:@"%@ %c.", [firstNames objectAtIndex: CCRANDOM_0_1() * [firstNames count]], [lastLetters characterAtIndex: CCRANDOM_0_1() * [lastLetters length]]];
    [personData setObject:actualName forKey:@"name"];
    [personData setValue:[NSNumber numberWithFloat:(int)(CCRANDOM_0_1() * 5) / 10.0f + 0.5f] forKey:@"happiness"];
    [personData setValue:[NSNumber numberWithFloat:(int)(CCRANDOM_0_1() * 3) / 10.0f] forKey:@"sickness"];
    [personData setValue:[NSNumber numberWithFloat:(int)(CCRANDOM_0_1() * 10) / 10.0f] forKey:@"hotness"];
    [personData setValue:[NSNumber numberWithFloat:(int)(CCRANDOM_0_1() * 10) / 10.0f] forKey:@"intelligence"];
    [personData setValue:[NSNumber numberWithFloat:(int)(CCRANDOM_0_1() * 10) / 10.0f] forKey:@"thirst"];
    [personData setValue:[NSNumber numberWithFloat:(int)(CCRANDOM_0_1() * 10) / 10.0f] forKey:@"bladder"];
    [personData setObject:feetSprite forKey:@"feetSprite"];
    [personData setObject:bodySprite forKey:@"bodySprite"];
    [personData setObject:headSprite forKey:@"headSprite"];
    [personData setObject:selectionSprite forKey:@"selectionSprite"];
    [personData setObject:drinkSprite forKey:@"drinkSprite"];
    [personData setObject:[NSValue valueWithCGPoint: ccp(0, 8)] forKey:@"drinkOffset"];
    [personData setObject:[NSValue valueWithCGPoint: ccp(0, 8)] forKey:@"desiredDrinkOffset"];
    [personData setObject:@(0.0) forKey:@"drinkStartTime"];
    [personData setObject:@(CCRANDOM_0_1()) forKey:@"drinkAmountLeft"];
    [personData setObject:[NSNumber numberWithBool: NO] forKey:@"selected"];
    [personData setObject:[NSNumber numberWithBool: NO] forKey:@"animatingFeet"];
    [personData setObject:shape forKey:@"shape"];
    [personData setObject:staticBody forKey:@"staticTargetBody"];
    [personData setObject:pivot forKey:@"pivotJoint"];
    [personData setObject:[NSNumber numberWithFloat: 40.0f] forKey:@"walkSpeed"];
    
    [peopleData addObject: personData];
    
    personIndex = (int)[peopleData count];
    
    FTStandingState *standingState = [[FTStandingState alloc] initWithTargetLocation: pt];
    standingState.bodyLookAtPoint = ccp(pt.x + 5 * CCRANDOM_MINUS1_1(), pt.y + 5 * CCRANDOM_MINUS1_1());
    [self personChangeState:personIndex - 1 newState:standingState];
    
}

- (void)createPhysicsBounds{
    for(NSMutableDictionary *decoration in [decorationNode decorations]){
        if([decoration objectForKey:@"collision"] == nil || ([[decoration objectForKey:@"collision"] isEqualToString:@"YES"])){
            if([decoration objectForKey:@"collisionrect"] != nil){
                CGRect collisionRect = CGRectFromString([decoration objectForKey:@"collisionrect"]);
                collisionRect = CGRectMake(0, 0, collisionRect.size.width / 2, collisionRect.size.height / 2);

                CCSprite *decorationSprite = [decoration objectForKey: @"sprite"];
                if(decorationSprite != nil){
                    ChipmunkBody *decBody = [ChipmunkBody staticBody];
                    ChipmunkShape *decShape = [ChipmunkPolyShape boxWithBody:decBody width:collisionRect.size.width height:collisionRect.size.height radius:0];
                    
                    [decShape setCollisionType: DECORATION_COLLISION_TYPE];
                    
                    [decBody setPosition: [decorationSprite position]];
                    [decBody setAngle: CC_DEGREES_TO_RADIANS([decorationSprite rotation])];
                    
                    //cpShapeSetCollisionType(decRect, DECORATION_COLLISION_TYPE);
                    [space add: decBody];
                    [space add: decShape];
                    [decoration setObject:decShape forKey:@"collisionshape"];
                }
            }else if([decoration objectForKey:@"collisioncircle"] != nil){
                CGRect collisionCircle = CGRectFromString([decoration objectForKey:@"collisioncircle"]);
                CCSprite *decorationSprite = [decoration objectForKey: @"sprite"];
                if(decorationSprite != nil){
                    ChipmunkBody *decBody = [ChipmunkBody staticBody];
                    ChipmunkShape *decShape = [ChipmunkCircleShape circleWithBody:decBody radius:collisionCircle.size.width offset:cpvzero];
                    
                    [decShape setCollisionType: DECORATION_COLLISION_TYPE];

                    [decBody setPosition: [decorationSprite position]];
                    [decBody setAngle: CC_DEGREES_TO_RADIANS([decorationSprite rotation])];

                    [space add: decBody];
                    [space add: decShape];
                    //cpShapeSetCollisionType(decCircle, DECORATION_COLLISION_TYPE);
                    
                    [decoration setObject:decShape forKey:@"collisionshape"];
                }
            }
        }
    }
    
    int w = [[houseNode structureNode] width];
    int h = [[houseNode structureNode] height];
    
    BOOL usedBlocks[h][w];
    for(int x = 0; x < w; x++){
        for(int y = 0; y < h; y++)
            usedBlocks[y][x] = NO;
    }
    
    // Add horizontal physics bounds
    for(int y = 1; y < h - 1; y++){
        for(int x = 1; x < w - 1; x++){
            if((![[houseNode structureNode] tileAt:x - 1 y:y]->type || usedBlocks[y][x-1]) && [[houseNode structureNode] tileAt:x y:y]->type && !usedBlocks[y][x]){
                int contiguousBlocks = 0;
                for(int xx = x; xx < w - 1; xx++){
                    if([[houseNode structureNode] tileAt:xx y:y]->type && !usedBlocks[y][xx])
                        contiguousBlocks++;
                    else
                        break;
                }
                
                if(contiguousBlocks > 2){
                    for(int xx = x; xx < x + contiguousBlocks; xx++)
                        usedBlocks[y][xx] = YES;
                    
                    CGPoint rectCenter = ccpAdd(ccp(x*12, ([[houseNode structureNode] height] * 12) - y*12 - 6), ccp(contiguousBlocks * 6, 0));
                    ChipmunkBody *rectBody = [ChipmunkBody staticBody];
                    ChipmunkShape *rectShape = [ChipmunkPolyShape boxWithBody:rectBody width:contiguousBlocks * 12 height:12 radius:0];
                    
                    [rectShape setCollisionType: STATIC_COLLISION_TYPE];
                    [rectBody setPosition: rectCenter];
                    
                    [space add: rectBody];
                    [space add: rectShape];
                    
                    //cpShapeSetCollisionType(rect, STATIC_COLLISION_TYPE);
                }
            }
        }
    }
    
    // Add vertical physics bounds
    for(int x = 1; x < w - 1; x++){
        for(int y = 1; y < h - 1; y++){
            if((![[houseNode structureNode] tileAt:x y:y - 1]->type || usedBlocks[y-1][x]) && [[houseNode structureNode] tileAt:x y:y]->type && !usedBlocks[y][x]){
                int contiguousBlocks = 0;
                for(int yy = y; yy < h - 1; yy++){
                    if([[houseNode structureNode] tileAt:x y:yy]->type && !usedBlocks[yy][x])
                        contiguousBlocks++;
                    else
                        break;
                }
                
                if(contiguousBlocks > 2){
                    for(int yy = y; yy < y + contiguousBlocks; yy++)
                        usedBlocks[yy][x] = YES;
                    
                    CGPoint rectCenter = ccpAdd(ccp(x*12 + 6, ([[houseNode structureNode] height] * 12) - y*12), ccp(0, -contiguousBlocks * 6));
                    
                    ChipmunkBody *rectBody = [ChipmunkBody staticBody];
                    ChipmunkShape *rectShape = [ChipmunkPolyShape boxWithBody:rectBody width:12 height:contiguousBlocks * 12 radius:0];

                    [rectShape setCollisionType: STATIC_COLLISION_TYPE];
                    [rectBody setPosition: rectCenter];
                    
                    [space add: rectBody];
                    [space add: rectShape];

                    //cpShapeSetCollisionType(rect, STATIC_COLLISION_TYPE);
                }
            }
        }
    }
    
    // Add any single blocks
    for(int x = 0; x < w; x++){
        for(int y = 0; y < h; y++){
            if(!usedBlocks[y][x] && [[houseNode structureNode] tileAt:x y:y]->type){
                ChipmunkBody *rectBody = [ChipmunkBody staticBody];
                ChipmunkShape *rectShape = [ChipmunkPolyShape boxWithBody:rectBody width:12 height:12 radius:0];
                
                [rectShape setCollisionType: STATIC_COLLISION_TYPE];
                [rectBody setPosition: ccp(x*12 + 6, ([[houseNode structureNode] height] * 12) - y*12 - 6)];
              
                [space add: rectShape];
                [space add: rectBody];

                //cpShapeSetCollisionType(rect, STATIC_COLLISION_TYPE);
                usedBlocks[y][x] = YES;
            }
        }
    }
}

- (BOOL)collisionPersonDecorationBegin:(cpArbiter *)arb space:(cpSpace *)space userData:(cpDataPointer *)userData{
    cpShape *a, *b = nil;
    cpArbiterGetShapes(arb, &a, &b);

    NSMutableDictionary *personData = nil;
    NSMutableDictionary *decDict = nil;
    
    cpCollisionType typeA = cpShapeGetCollisionType(a);
    
    if([typeA isEqualToString: PERSON_COLLISION_TYPE]){
        for(int x = 0; x < personIndex; x++){
            if([[peopleData[x] objectForKey: @"shape"] shape] == a){
                personData = peopleData[x];
            }
        }
        
        for(NSMutableDictionary *dec in [decorationNode decorations]){
            if([[dec objectForKey: @"collisionshape"] shape] == b){
                decDict = dec;
            }
        }
    }else{
        for(int x = 0; x < personIndex; x++){
            if([[peopleData[x] objectForKey: @"shape"] shape] == b){
                personData = peopleData[x];
            }
        }
        
        for(NSMutableDictionary *dec in [decorationNode decorations]){
            if([[dec objectForKey: @"collisionshape"] shape] == a){
                decDict = dec;
            }
        }
    }
    
    if(personData != nil && decDict != nil){
        FTPersonState *currentState = [personData objectForKey: @"currentState"];
        if([currentState isKindOfClass: [FTUsingState class]]){
            NSMutableDictionary *dec = [(FTUsingState *)currentState decDict];
            if(dec == decDict)
                return NO;
        }
    }else{
        NSLog(@"Couldn't find a person or dec for collision.");
    }
    
    return YES;
}

- (BOOL)collisionPersonPersonBegin:(cpArbiter *)arb space:(cpSpace *)space userData:(cpDataPointer *)userData{
    cpShape *a, *b = NULL;
    cpArbiterGetShapes(arb, &a, &b);
    int whichPersonA = -1;
    int whichPersonB = -1;
    for(int x = 0; x < personIndex; x++){
        cpShape *shape = [[peopleData[x] objectForKey:@"shape"] shape];
        if(shape == a)
            whichPersonA = x;
        else if(shape == b)
            whichPersonB = x;
    }
    
    if(whichPersonA == -1 || whichPersonB == -1){
        NSLog(@"Failed to find a person for shape.");
    }else{
        NSString *pairString = NSStringFromCGPoint(ccp(whichPersonA, whichPersonB));
        NSString *oppositePairString = NSStringFromCGPoint(ccp(whichPersonB, whichPersonA));
        
        if([contactTimes objectForKey:pairString] == nil && [contactTimes objectForKey:oppositePairString] == nil)
            [contactTimes setObject:[NSNumber numberWithDouble: CFAbsoluteTimeGetCurrent()] forKey:pairString];
        
    }
    return YES;
}

- (BOOL)collisionPersonPersonPreSolve:(cpArbiter *)arb space:(cpSpace *)space userData:(cpDataPointer *)userData{
    cpShape *a, *b = NULL;
    cpArbiterGetShapes(arb, &a, &b);
    int whichPersonA = -1;
    int whichPersonB = -1;
    for(int x = 0; x < personIndex; x++){
        if([[peopleData[x] objectForKey:@"shape"] shape] == a)
            whichPersonA = x;
        else if([[peopleData[x] objectForKey:@"shape"] shape] == b)
            whichPersonB = x;
    }
    
    if(whichPersonA == -1 || whichPersonB == -1){
        NSLog(@"Failed to find a person for shape.");
        return YES;
    }else{
        NSString *pairString = NSStringFromCGPoint(ccp(whichPersonA, whichPersonB));
        NSString *oppositePairString = NSStringFromCGPoint(ccp(whichPersonB, whichPersonA));
        
        BOOL ignoreCollision = NO;
        if([contactTimes objectForKey:pairString] != nil){
            CFAbsoluteTime contactLife = CFAbsoluteTimeGetCurrent() - [[contactTimes objectForKey: pairString] doubleValue];
            if(contactLife > 0.2f && contactLife < 1.2f)
                ignoreCollision = YES;
            
            
        }else if([contactTimes objectForKey: oppositePairString]){
            CFAbsoluteTime contactLife = CFAbsoluteTimeGetCurrent() - [[contactTimes objectForKey: oppositePairString] doubleValue];
            if(contactLife > 0.2f && contactLife < 1.2f)
                ignoreCollision = YES;
        }
        
        return !ignoreCollision;
    }
}

- (void)collisionPersonPersonSeparate:(cpArbiter *)arb space:(cpSpace *)space userData:(cpDataPointer *)userData{
    cpShape *a, *b = NULL;
    cpArbiterGetShapes(arb, &a, &b);
    int whichPersonA = -1;
    int whichPersonB = -1;
    for(int x = 0; x < personIndex; x++){
        if([[peopleData[x] objectForKey:@"shape"] shape] == a)
            whichPersonA = x;
        
        if([[peopleData[x] objectForKey:@"shape"] shape] == b)
            whichPersonB = x;
    }
    
    if(whichPersonA == -1 || whichPersonB == -1){
        NSLog(@"Failed to find a person for shape.");
    }else{
        NSString *pairString = NSStringFromCGPoint(ccp(whichPersonA, whichPersonB));
        NSString *oppositePairString = NSStringFromCGPoint(ccp(whichPersonB, whichPersonA));
        
        if([contactTimes objectForKey:pairString] != nil){
            [contactTimes removeObjectForKey: pairString];
        }else if([contactTimes objectForKey:oppositePairString] != nil){
            [contactTimes removeObjectForKey:oppositePairString];
        }
    }
}

/*- (BOOL)personCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space{
    cpShape *a, *b = NULL;
    cpArbiterGetShapes(arb, &a, &b);
    int whichPersonA = -1;
    int whichPersonB = -1;
    for(int x = 0; x < personIndex; x++){
        if([[[peopleData objectAtIndex: x] valueForKey:@"shape"] pointerValue] == a)
            whichPersonA = x;
        else if([[[peopleData objectAtIndex: x] valueForKey:@"shape"] pointerValue] == b)
            whichPersonB = x;
    }
    
    if(whichPersonA == -1 || whichPersonB == -1){
        NSLog(@"Failed to find a person for shape.");
    }else{
        NSString *pairString = NSStringFromCGPoint(ccp(whichPersonA, whichPersonB));
        NSString *oppositePairString = NSStringFromCGPoint(ccp(whichPersonB, whichPersonA));
        
        if(moment == COLLISION_BEGIN){
            [contactTimes setObject:[NSNumber numberWithDouble: CFAbsoluteTimeGetCurrent()] forKey:pairString];
        }else if(moment == COLLISION_POSTSOLVE){
            BOOL push = NO;
            if([contactTimes objectForKey:pairString] != nil){
                CFAbsoluteTime contactLife = CFAbsoluteTimeGetCurrent() - [[contactTimes objectForKey: pairString] doubleValue];
                if(contactLife > 0.2f)
                    push = YES;
                
                
            }else if([contactTimes objectForKey: oppositePairString]){
                CFAbsoluteTime contactLife = CFAbsoluteTimeGetCurrent() - [[contactTimes objectForKey: oppositePairString] doubleValue];
                if(contactLife > 0.2f)
                    push = YES;
            }
            
            if(push && ([[[peopleData objectAtIndex: whichPersonA] objectForKey:@"currentState"] intValue] == FTPersonStateWalking || [[[peopleData objectAtIndex: whichPersonB] objectForKey:@"currentState"] intValue] == FTPersonStateWalking)){
                cpBody *pusherBody = cpShapeGetBody(a);
                cpBody *pusheeBody = cpShapeGetBody(b);
                
                if([[[peopleData objectAtIndex: whichPersonB] objectForKey:@"currentState"] intValue] == FTPersonStateWalking){
                    cpBody *tempB = pusherBody;
                    pusherBody = pusheeBody;
                    pusheeBody = tempB;
                }
                
                NSLog(@"Pushing %@", pairString);
                
                CGPoint velocityUnit = ccpNormalize(cpBodyGetVelocity(pusherBody));
                //CGPoint centerUnit = ccpNormalize(ccpSub(pusherBody->p, pusheeBody->p));
                
                CGPoint perpUnit = ccp(-velocityUnit.y, velocityUnit.x);
                
                if(fabsf(perpUnit.x) > fabsf(perpUnit.y)){ // x is biggest factor
                    if(cpBodyGetPosition(pusheeBody).x - cpBodyGetPosition(pusherBody).x > 0.0f){ // pushee is on right side of pusher
                        if(perpUnit.x < 0.0f)
                            perpUnit = ccpNeg(perpUnit);
                    }
                }else{ // y is biggest factor
                    if(cpBodyGetPosition(pusheeBody).y - cpBodyGetPosition(pusherBody).y > 0.0f){ // pushee is on upper side of pusher
                        if(perpUnit.y < 0.0f)
                            perpUnit = ccpNeg(perpUnit);
                    }
                }
                
                cpBodyApplyImpulseAtLocalPoint(pusheeBody, ccpMult(perpUnit, 100.0f), cpvzero);
                
                if([contactTimes objectForKey:pairString] != nil){
                    [contactTimes setObject:[NSNumber numberWithDouble:[[contactTimes objectForKey:pairString] doubleValue] + 0.2f] forKey:pairString];
                }else if([contactTimes objectForKey:oppositePairString] != nil){
                    [contactTimes setObject:[NSNumber numberWithDouble:[[contactTimes objectForKey:oppositePairString] doubleValue] + 0.2f] forKey:oppositePairString];
                }
            }
        }else if(moment == COLLISION_SEPARATE){
            if([contactTimes objectForKey:pairString] != nil){
                [contactTimes removeObjectForKey: pairString];
            }else if([contactTimes objectForKey:oppositePairString] != nil){
                [contactTimes removeObjectForKey:oppositePairString];
            }
        }
    }
    
    return YES;
}

- (BOOL)personDecorationCollision:(cpArbiter*)arbiter space:(cpSpace*)space{
    cpShape *person, *decoration = NULL;
    cpArbiterGetShapes(arbiter, &person, &decoration);
    
    /*if(cpShapeGetCollisionType(person) != PERSON_COLLISION_TYPE){
        cpShape *temp = person;
        person = decoration;
        decoration = temp;
    }
    
    int whichPerson = -1;
    for(int x = 0; x < personIndex; x++){
        if([[[peopleData objectAtIndex: x] valueForKey:@"shape"] pointerValue] == person)
            whichPerson = x;
    }
    
    if(whichPerson == -1){
        NSLog(@"Failed to find a person for shape.");
    }else{
        for(int x = 0; x < [[decorationNode decorations] count]; x++){
            NSDictionary *decDict = [[decorationNode decorations] objectAtIndex: x];
            if([[decDict valueForKey: @"collisionshape"] pointerValue] == decoration){
                if([[peopleData objectAtIndex: whichPerson] objectForKey:@"useDecoration"] != nil && [[peopleData objectAtIndex: whichPerson] objectForKey:@"useDecoration"] == decDict){
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (BOOL)personCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    cpShape *a, *b = NULL;
    cpArbiterGetShapes(arb, &a, &b);
    int whichPersonA = -1;
    int whichPersonB = -1;
    for(int x = 0; x < personIndex; x++){
        if([[[peopleData objectAtIndex: x] valueForKey:@"shape"] pointerValue] == a)
            whichPersonA = x;
        else if([[[peopleData objectAtIndex: x] valueForKey:@"shape"] pointerValue] == b)
            whichPersonB = x;
    }
    
    if(whichPersonA == -1 || whichPersonB == -1){
        NSLog(@"Failed to find a person for shape.");
    }else{
        NSString *pairString = NSStringFromCGPoint(ccp(whichPersonA, whichPersonB));
        NSString *oppositePairString = NSStringFromCGPoint(ccp(whichPersonB, whichPersonA));
        
        if(moment == COLLISION_BEGIN){
            [contactTimes setObject:[NSNumber numberWithDouble: CFAbsoluteTimeGetCurrent()] forKey:pairString];
        }else if(moment == COLLISION_POSTSOLVE){
            BOOL push = NO;
            if([contactTimes objectForKey:pairString] != nil){
                CFAbsoluteTime contactLife = CFAbsoluteTimeGetCurrent() - [[contactTimes objectForKey: pairString] doubleValue];
                if(contactLife > 0.2f)
                    push = YES;
                
                
            }else if([contactTimes objectForKey: oppositePairString]){
                CFAbsoluteTime contactLife = CFAbsoluteTimeGetCurrent() - [[contactTimes objectForKey: oppositePairString] doubleValue];
                if(contactLife > 0.2f)
                    push = YES;
            }
            
            if(push && ([[[peopleData objectAtIndex: whichPersonA] objectForKey:@"currentState"] intValue] == FTPersonStateWalking || [[[peopleData objectAtIndex: whichPersonB] objectForKey:@"currentState"] intValue] == FTPersonStateWalking)){
                cpBody *pusherBody = cpShapeGetBody(a);
                cpBody *pusheeBody = cpShapeGetBody(b);
                
                if([[[peopleData objectAtIndex: whichPersonB] objectForKey:@"currentState"] intValue] == FTPersonStateWalking){
                    cpBody *tempB = pusherBody;
                    pusherBody = pusheeBody;
                    pusheeBody = tempB;
                }
                
                NSLog(@"Pushing %@", pairString);
                
                CGPoint velocityUnit = ccpNormalize(cpBodyGetVelocity(pusherBody));
                //CGPoint centerUnit = ccpNormalize(ccpSub(pusherBody->p, pusheeBody->p));
                
                CGPoint perpUnit = ccp(-velocityUnit.y, velocityUnit.x);
                
                if(fabsf(perpUnit.x) > fabsf(perpUnit.y)){ // x is biggest factor
                    if(cpBodyGetPosition(pusheeBody).x - cpBodyGetPosition(pusherBody).x > 0.0f){ // pushee is on right side of pusher
                        if(perpUnit.x < 0.0f)
                            perpUnit = ccpNeg(perpUnit);
                    }
                }else{ // y is biggest factor
                    if(cpBodyGetPosition(pusheeBody).y - cpBodyGetPosition(pusherBody).y > 0.0f){ // pushee is on upper side of pusher
                        if(perpUnit.y < 0.0f)
                            perpUnit = ccpNeg(perpUnit);
                    }
                }
                
                cpBodyApplyImpulseAtLocalPoint(pusheeBody, ccpMult(perpUnit, 100.0f), cpvzero);
                
                if([contactTimes objectForKey:pairString] != nil){
                    [contactTimes setObject:[NSNumber numberWithDouble:[[contactTimes objectForKey:pairString] doubleValue] + 0.2f] forKey:pairString];
                }else if([contactTimes objectForKey:oppositePairString] != nil){
                    [contactTimes setObject:[NSNumber numberWithDouble:[[contactTimes objectForKey:oppositePairString] doubleValue] + 0.2f] forKey:oppositePairString];
                }
            }
        }else if(moment == COLLISION_SEPARATE){
            if([contactTimes objectForKey:pairString] != nil){
                [contactTimes removeObjectForKey: pairString];
            }else if([contactTimes objectForKey:oppositePairString] != nil){
                [contactTimes removeObjectForKey:oppositePairString];
            }
        }
    }
    
    return YES;
}*/

- (void)createParticles:(NSDictionary *)particles withDecoration:(NSDictionary *)dec{
    CCParticleSystem *system = [[CCParticleSystem alloc] initWithTotalParticles: 100];
    
}

- (void)printInfo{
    int numStanding = 0, numWalking = 0, numUsing = 0;
    
    for(int x = 0; x < personIndex; x++){
        FTPersonState *currentState = [[peopleData objectAtIndex: x] objectForKey: @"currentState"];
        
        if([currentState isKindOfClass: [FTStandingState class]])
            numStanding++;
        if([currentState isKindOfClass: [FTWalkingState class]])
            numWalking++;
        if([currentState isKindOfClass: [FTUsingState class]])
            numUsing++;
    }
    
    NSLog(@"Standing: %i, Walking: %i, Using: %i", numStanding, numWalking, numUsing);
}
    
- (void)update:(CCTime)delta{
    NSTimeInterval start = CFAbsoluteTimeGetCurrent();
    [space step: delta];
    start = CFAbsoluteTimeGetCurrent();
    
    /*if([[contactTimes allKeys] count]){
        NSLog(@"Contact times: ");
        for(NSString *pair in [contactTimes allKeys]){
            NSLog(@"[%@] : %@", pair, [contactTimes objectForKey: pair]);
        }
    }*/

    for(NSMutableDictionary *dec in [decorationNode decorations]){
        if([dec objectForKey: @"use"] != nil){
            int currentUsers = [[dec objectForKey: @"numusers"] intValue];
            int maxUsers = [[[dec objectForKey: @"use"] objectForKey: @"maxusers"] intValue];

            if(currentUsers < maxUsers){
                if([[dec objectForKey: @"use"] objectForKey: @"drinks"] != nil){
                    int thirstyPersonIndex = [self thirstyPersonIndex];
                    if(thirstyPersonIndex != -1){
                        [self personUseDecoration:thirstyPersonIndex decorationDict:dec walkToStart:YES];
                    }
                }else if([[dec objectForKey: @"use"] objectForKey: @"toilet"] != nil){
                    int fullBladderPersonIndex = [self fullBladderPersonIndex];
                    if(fullBladderPersonIndex != -1){
                        [self personUseDecoration:fullBladderPersonIndex decorationDict:dec walkToStart:YES];
                    }
                }
            }
            
        }
    }
    
    for(int x = 0; x < personIndex; x++){
        ChipmunkShape *personShape = [[peopleData objectAtIndex: x] objectForKey:@"shape"];
        ChipmunkBody *personBody = [personShape body];
        [personBody activate];

        CGPoint pos = [personBody position];
        
        if(ccpLength([personBody velocity]) > 2.0f && [[[peopleData objectAtIndex: x] objectForKey:@"animatingFeet"] boolValue] == NO){
            float velocityAngle = 90 - CC_RADIANS_TO_DEGREES(atan2f([personBody velocity].y, [personBody velocity].x));
            if(fabsf(velocityAngle - [(CCSprite *)[[peopleData objectAtIndex: x] objectForKey:@"bodySprite"] rotation]) < 15.0f){ // velocity and facing same direction
                CCAnimation *anim = [CCAnimation animationWithSpriteFrames:walkingAnimation delay:0.05f];
                CCActionAnimate *walk = [CCActionAnimate actionWithAnimation: anim];
                [[peopleData[x] objectForKey:@"feetSprite"] runAction: [CCActionSequence actions: walk, [CCActionCallBlock actionWithBlock:^{
                    [peopleData[x] setObject:@(NO) forKey:@"animatingFeet"];
                }], nil]];
                [peopleData[x] setObject:@(YES) forKey:@"animatingFeet"];
            }
        }
        
        FTPersonState *currentState = [[peopleData objectAtIndex: x] objectForKey: @"currentState"];
        
        [currentState update: delta];
        
        CGPoint bodyLookAtPoint = [currentState bodyLookAtPoint];
        CGPoint headLookAtPoint = [currentState headLookAtPoint];
        
        float bodyLookAtAngle = 90 - CC_RADIANS_TO_DEGREES(atan2f(bodyLookAtPoint.y - pos.y, bodyLookAtPoint.x - pos.x));
        float headLookAtAngle = 90 - CC_RADIANS_TO_DEGREES(atan2f(headLookAtPoint.y - pos.y, headLookAtPoint.x - pos.x));
        
        CCSprite *feetSprite = [peopleData[x] objectForKey:@"feetSprite"];
        CCSprite *bodySprite = [peopleData[x] objectForKey:@"bodySprite"];
        CCSprite *headSprite = [peopleData[x] objectForKey:@"headSprite"];
        CCSprite *selectionSprite = [peopleData[x] objectForKey:@"selectionSprite"];
        FTDrinkSprite *drinkSprite = [peopleData[x] objectForKey:@"drinkSprite"];
        
        [feetSprite setPosition: pos];
        [bodySprite setPosition: pos];
        [headSprite setPosition: pos];
        [selectionSprite setPosition: pos];
        [drinkSprite setPosition: pos];
        
        CGPoint drinkOffset = [[peopleData[x] objectForKey:@"drinkOffset"] CGPointValue];
        CGPoint desiredDrinkOffset = [[peopleData[x] objectForKey:@"desiredDrinkOffset"] CGPointValue];
        
        NSTimeInterval drinkStartMove = [[peopleData[x] objectForKey:@"drinkStartTime"] doubleValue];
        float t = 2 * min(CFAbsoluteTimeGetCurrent() - drinkStartMove, 0.5f);
        
        drinkOffset = cpvlerp(drinkOffset, desiredDrinkOffset, t);
        
        float newBodyRotation = [self rotateTowards:bodyLookAtAngle current:[bodySprite rotation] turnSpeed:180 * delta];
        drinkOffset = ccpRotateByAngle(drinkOffset, CGPointZero, CC_DEGREES_TO_RADIANS(-newBodyRotation));
        [drinkSprite setPosition: ccpAdd(pos, drinkOffset)];
        
        float amountLeft = [[peopleData[x] objectForKey:@"drinkAmountLeft"] floatValue];

        if(amountLeft > 0){
            float amountDrank = 0.25 * delta;
            amountLeft = max(amountLeft - amountDrank, 0.0f);
            
            if([[peopleData[x] objectForKey:@"drinkAmountLeft"] floatValue] > 0 && amountLeft <= 0){
                FTDrinkSpriteType type = [drinkSprite type];
                CGPoint startThrowPoint = ccpAdd(pos, ccpMult(ccpNormalize(drinkOffset), 10));
                CGPoint throwPoint = ccpAdd(pos, ccpMult(ccpNormalize(drinkOffset), CCRANDOM_0_1() * 30 + 15));
                [[self.houseNode trashNode] addNewTrash:(FTTrashType)type from:startThrowPoint to:throwPoint];
                [drinkSprite setType: rand() % 3];
            }
        
            float thirst = [[peopleData[x] objectForKey: @"thirst"] floatValue];
            float bladder = [[peopleData[x] objectForKey: @"bladder"] floatValue];
            
            thirst = max(thirst - amountDrank * 0.25f, 0);
            bladder = min(bladder + amountDrank * 0.5f, 1);
            
            [peopleData[x] setObject:@(amountLeft) forKey:@"drinkAmountLeft"];
            [peopleData[x] setObject:@(thirst) forKey:@"thirst"];
            [peopleData[x] setObject:@(bladder) forKey:@"bladder"];
            
            [drinkSprite setVisible: YES];
        }else{
            [drinkSprite setVisible: NO];
        }
    
        [feetSprite setRotation: [self rotateTowards:bodyLookAtAngle current:[feetSprite rotation] turnSpeed:240 * delta]];
        [bodySprite setRotation: newBodyRotation];
        [headSprite setRotation: [self rotateTowards:headLookAtAngle current:[headSprite rotation] turnSpeed:360 * delta]];
        [drinkSprite setRotation: newBodyRotation];
    }
    
}

- (float)rotateTowards:(float)wanted current:(float)current turnSpeed:(float)turnSpeed{
    if(current > 0)
        current = fmodf(current, 360.0f);
    else
        current = fmodf(current, -360.0f);
    
    float diffAngle = wanted - current;
    if(diffAngle > 180)
        diffAngle -= 360;
    if(diffAngle < -180)
        diffAngle += 360;
    
    float sign = (diffAngle < 0) ? -1.0f : 1.0f;
    diffAngle = sign * min(fabsf(diffAngle), turnSpeed);
    return current + diffAngle;
}

- (CGPoint)transformPoint:(CGPoint)pt decRot:(int)rot decSX:(int)sx decSY:(int)sy decPos:(CGPoint)p{
    if(rot == 90){
        int temp = pt.x;
        pt.x = pt.y;
        pt.y = -temp;
    }else if(rot == 180){
        pt.x *= -1;
        pt.y *= -1;
    }else if(rot == -90 || rot == 270){
        int temp = pt.x;
        pt.x = -pt.y;
        pt.y = temp;
    }
    
    pt.x *= sx;
    pt.y *= sy;
    
    pt = ccpAdd(pt, p);
    return pt;
}

- (int)transformRotation:(int)rotation decRot:(int)decRot decSX:(int)sx decSY:(int)sy{
    int actualRot = rotation + decRot;
    
    if(sx == -1 || sy == -1){
        actualRot += 180;
    }
    
    if(actualRot > 360)
        actualRot %= 360;
    else if(actualRot < 0)
        actualRot += 360;
    
    if(actualRot == 270)
        actualRot = -90;
    return actualRot;
}

@end
