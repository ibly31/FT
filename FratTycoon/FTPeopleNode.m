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

@implementation FTPeopleNode
@synthesize sprites;
@synthesize space;
@synthesize houseNode;

- (id)init{
    self = [super init];
    if(self){
        self.sprites = [[CCSpriteBatchNode alloc] initWithFile:@"PeopleSheet.png" capacity:MAX_PEOPLE * 3];
        [self addChild: sprites];
        
        self.space = [[ChipmunkSpace alloc] init];
        //[space addCollisionHandler:self typeA:PERSON_COLLISION_TYPE typeB:PERSON_COLLISION_TYPE begin:@selector(personCollision:arbiter:space:) preSolve:@selector(personCollision:arbiter:space:) postSolve:@selector(personCollision:arbiter:space:) separate:@selector(personCollision:arbiter:space:)];
        
        //debugLayer = [[CPDebugLayer alloc] initWithSpace:[spaceManager space] options:nil];
        //[self addChild: debugLayer];
        
        peopleData = [[NSMutableArray alloc] initWithCapacity: MAX_PEOPLE];
        
        /*[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(0, 25, 24, 24)] name:@"walk1"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(25, 25, 24, 24)] name:@"walk2"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(50, 25, 24, 24)] name:@"walk3"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(75, 25, 24, 24)] name:@"walk4"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(100, 25, 24, 24)] name:@"walk5"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(125, 25, 24, 24)] name:@"walk6"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(0, 50, 24, 24)] name:@"walk7"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(25, 50, 24, 24)] name:@"walk8"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(50, 50, 24, 24)] name:@"walk9"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(75, 50, 24, 24)] name:@"walk10"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(100, 50, 24, 24)] name:@"walk11"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:[CCSpriteFrame frameWithTexture:[sprites texture] rect:CGRectMake(125, 50, 24, 24)] name:@"walk12"];
        
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
        
        walkingAnimation = walkAnim;*/
        
        personIndex = 0;
        
        [self scheduleOnce:@selector(spawnPeople) delay:0.05f];
        [self scheduleOnce:@selector(resetTargetBodies) delay:2.0f];
        
        contactTimes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)spawnPeople{
    for(int peopleToSpawn = 50; peopleToSpawn > 0; peopleToSpawn--){
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

- (void)personChangeState:(int)personInd newState:(FTPersonState)newState{
    if(personInd < personIndex && personInd >= 0){
        NSLog(@"Changing person %i to state %@", personInd, [@[@"STANDING", @"WALKING", @"USING"] objectAtIndex: newState]);
        [[peopleData objectAtIndex: personInd] setObject:[NSNumber numberWithInt: newState] forKey:@"currentState"];
        if(newState == FTPersonStateWalking){
            ChipmunkConstraint *pivotJoint = [[peopleData objectAtIndex: personInd] objectForKey: @"pivotJoint"];
            [pivotJoint setMaxBias: [[[peopleData objectAtIndex: personInd] objectForKey:@"walkSpeed"] floatValue]];
            [pivotJoint setMaxForce: 2000];
        }else if(newState == FTPersonStateStanding){
            ChipmunkConstraint *pivotJoint = [[peopleData objectAtIndex: personInd] objectForKey: @"pivotJoint"];
            [pivotJoint setMaxBias: 20.0f];
            [pivotJoint setMaxForce: 200];
        }
    }else{
        NSLog(@"PersonIndex %i out of bounds", personInd);
    }
}

- (void)personAddWalkPoints:(int)personInd points:(NSArray *)points{
    [[peopleData objectAtIndex: personInd] setObject:[NSNumber numberWithInt: 0] forKey:@"currentPathIndex"];
    
    int currentPathIndex = 0;
    NSMutableArray *pointValues = [[NSMutableArray alloc] initWithCapacity: [points count]];
    
    for(NSString *pointString in points){
        CGPoint pt = CGPointFromString(pointString);
        NSLog(@" %@", pointString);
        
        ChipmunkBody *circleBody = [ChipmunkBody staticBody];
        ChipmunkShape *circleShape = [ChipmunkCircleShape circleWithBody:circleBody radius:1.0f offset:cpvzero];
        [circleShape setSensor: YES];
        [space add: circleShape];
        
        NSValue *pointValue = [NSValue valueWithCGPoint: pt];
        [pointValues addObject: pointValue];
        
        currentPathIndex++;
    }
    
    [[peopleData objectAtIndex: personInd] setObject: pointValues forKey:@"path"];
    
    int index = currentPathIndex - 1;
    
    [(ChipmunkBody *)[[peopleData objectAtIndex: personInd] objectForKey: @"staticTargetBody"] setPosition: [[pointValues objectAtIndex: index] CGPointValue]];
    [self personChangeState:personInd newState:FTPersonStateWalking];
}

- (void)personWalkTo:(int)personInd point:(CGPoint)point{
    if(personInd < personIndex && personInd >= 0){
        ChipmunkBody *personBody = [(ChipmunkShape *)[[peopleData objectAtIndex: personInd] objectForKey: @"shape"] body];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
            NSArray *points = [houseNode findPathFrom:[personBody position] end:point];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if(points != nil){
                    [self personAddWalkPoints:personInd points:points];
                }
            });
        });
        
    }else{
        NSLog(@"PersonIndex %i out of bounds", personInd);
    }
}

- (void)personUseDecoration:(int)personInd decorationDict:(NSDictionary *)decDict walkToStart:(BOOL)walkToStart{
    if(personInd < personIndex && personInd >= 0){
        if([decDict objectForKey: @"use"] != nil){
            if([[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential"] || [[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential-link"]){
                NSArray *usePositions = [[decDict objectForKey: @"use"] objectForKey: @"usepositions"];
                if(usePositions){
                    int rot = [(CCSprite *)[decDict objectForKey: @"sprite"] rotation];
                    int scaleX = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleX];
                    int scaleY = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleY];
                    
                    NSMutableDictionary *decDictMutable = [decDict mutableCopy];
                    
                    if([[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential-link"]){
                        NSDictionary *nextDecDict = [[houseNode decorationNode] decorationFromSequentialLink: decDict];
                        [decDictMutable setObject:nextDecDict forKey:@"uselinkdict"];
                    }
                    
                    CGPoint startingPoint = CGPointFromString([usePositions objectAtIndex: 0]);
                    startingPoint = [self transformPoint:startingPoint decRot:rot decSX:scaleX decSY:scaleY decPos:[(CCSprite *)[decDict objectForKey: @"sprite"] position]];
                    
                    [[peopleData objectAtIndex: personInd] setObject:decDictMutable forKey:@"useDecoration"];
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                    dispatch_async(queue, ^{
                        ChipmunkBody *personBody = [(ChipmunkShape *)[[peopleData objectAtIndex: personInd] objectForKey: @"shape"] body];
                        NSArray *points = [houseNode findPathFrom:[personBody position] end:startingPoint];
                        NSMutableArray *actualPoints = nil;
                        if(walkToStart)
                            actualPoints = [points mutableCopy];
                        else
                            actualPoints = [[NSMutableArray alloc] init];
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            if(points != nil){
                                for(int x = 0; x < [usePositions count]; x++){
                                    CGPoint usePos = CGPointFromString([usePositions objectAtIndex: x]);
                                    CGPoint actualPosition = [self transformPoint:usePos decRot:rot decSX:scaleX decSY:scaleY decPos:[(CCSprite *)[decDict objectForKey:@"sprite"] position]];
                                    [actualPoints insertObject:NSStringFromCGPoint(actualPosition) atIndex:0];
                                }
                                [self personAddWalkPoints:personInd points:actualPoints];
                            }
                        });
                    });
                }
            }
        }
    }else{
        NSLog(@"PersonIndex %i out of bounds", personInd);
    }
}

- (int)personAtPoint:(CGPoint)point{
    float shortestDist = INFINITY;
    int shortestIndex = -1;
    for(int i = 0; i < personIndex; i++){
        ChipmunkBody *personBody = [(ChipmunkShape *)[[peopleData objectAtIndex: i] objectForKey: @"shape"] body];
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
    if(personInd < personIndex && personInd >= 0){
        [[peopleData objectAtIndex: personInd] setObject:[NSNumber numberWithBool:selected] forKey:@"selected"];
        CCSprite *selectionSprite = (CCSprite *)[[peopleData objectAtIndex: personInd] objectForKey: @"selectionSprite"];
        [selectionSprite setVisible: YES];
        if(selected){
            [selectionSprite setOpacity: 0];
            [selectionSprite runAction: [CCActionFadeIn actionWithDuration: 0.3f]];
        }
    }else{
        NSLog(@"PersonIndex %i out of bounds", personInd);
    }
}

- (NSDictionary *)personGetData:(int)personInd{
    if(personInd < personIndex && personInd >= 0){
        return [peopleData objectAtIndex: personInd];
    }else{
        NSLog(@"PersonIndex %i out of bounds", personInd);
    }
    return nil;
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
    [selectionSprite setVisible: NO];
    [selectionSprite setScale: 4.0f / 3.0f];
    [sprites addChild: selectionSprite z:4];
    
    ChipmunkBody *body = [ChipmunkBody bodyWithMass:5 andMoment:cpMomentForCircle(5, 0, 7, cpvzero)];
    ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:7 offset:cpvzero];
    ChipmunkBody *staticBody = [ChipmunkBody staticBody];
    ChipmunkShape *staticShape = [ChipmunkCircleShape circleWithBody:staticBody radius:0.0f offset:cpvzero];
    [staticShape setSensor: YES];
    
    [space add: shape];
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
    [personData setObject:feetSprite forKey:@"feetSprite"];
    [personData setObject:bodySprite forKey:@"bodySprite"];
    [personData setObject:headSprite forKey:@"headSprite"];
    [personData setObject:selectionSprite forKey:@"selectionSprite"];
    [personData setObject:[NSNumber numberWithBool: NO] forKey:@"selected"];
    [personData setObject:[NSNumber numberWithBool: NO] forKey:@"animatingFeet"];
    [personData setObject:shape forKey:@"shape"];
    [personData setObject:staticBody forKey:@"staticTargetBody"];
    [personData setObject:pivot forKey:@"pivotJoint"];
    [personData setObject:[NSNumber numberWithInt: FTPersonStateStanding] forKey:@"currentState"];
    [personData setObject:[NSNumber numberWithFloat: 40.0f] forKey:@"walkSpeed"];
    [personData setValue:[NSValue valueWithCGPoint:ccp(pt.x, pt.y + 12)] forKey:@"lookAtPoint"];
    
    [peopleData addObject: personData];
}

- (void)createPhysicsBounds{
    for(NSMutableDictionary *decoration in [[houseNode decorationNode] decorations]){
        if([decoration objectForKey:@"collision"] == nil || ([[decoration objectForKey:@"collision"] isEqualToString:@"YES"])){
            if([decoration objectForKey:@"collisionrect"] != nil){
                CGRect collisionRect = CGRectFromString([decoration objectForKey:@"collisionrect"]);
                collisionRect = CGRectMake(0, 0, collisionRect.size.width / 2, collisionRect.size.height / 2);

                CCSprite *decorationSprite = [decoration objectForKey: @"sprite"];
                if(decorationSprite != nil){
                    ChipmunkBody *decBody = [ChipmunkBody staticBody];
                    ChipmunkShape *decShape = [ChipmunkPolyShape boxWithBody:decBody width:collisionRect.size.width height:collisionRect.size.height radius:20];
                    
                    //cpShapeSetCollisionType(decRect, DECORATION_COLLISION_TYPE);
                    [space add: decShape];
                    [decoration setObject:decShape forKey:@"collisionshape"];
                }
            }else if([decoration objectForKey:@"collisioncircle"] != nil){
                CGRect collisionCircle = CGRectFromString([decoration objectForKey:@"collisioncircle"]);
                CCSprite *decorationSprite = [decoration objectForKey: @"sprite"];
                if(decorationSprite != nil){
                    ChipmunkBody *decBody = [ChipmunkBody staticBody];
                    ChipmunkShape *decShape = [ChipmunkCircleShape circleWithBody:decBody radius:collisionCircle.size.width offset:cpvzero];
                    
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
                    ChipmunkShape *rectShape = [ChipmunkPolyShape boxWithBody:rectBody width:contiguousBlocks * 12 height:12 radius:12];
                    [rectBody setPosition: rectCenter];
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
                    ChipmunkShape *rectShape = [ChipmunkPolyShape boxWithBody:rectBody width:12 height:contiguousBlocks * 12 radius:12];
                    [rectBody setPosition: rectCenter];
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
                ChipmunkShape *rectShape = [ChipmunkPolyShape boxWithBody:rectBody width:12 height:12 radius:12];
                [rectBody setPosition: ccp(x*12 + 6, ([[houseNode structureNode] height] * 12) - y*12 - 6)];
                [space add: rectShape];

                //cpShapeSetCollisionType(rect, STATIC_COLLISION_TYPE);
                usedBlocks[y][x] = YES;
            }
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
        for(int x = 0; x < [[[houseNode decorationNode] decorations] count]; x++){
            NSDictionary *decDict = [[[houseNode decorationNode] decorations] objectAtIndex: x];
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
    
- (void)update:(CCTime)delta{
    [space step: delta];
    for(int x = 0; x < personIndex; x++){
        ChipmunkShape *personShape = [[peopleData objectAtIndex: x] objectForKey:@"shape"];
        ChipmunkBody *personBody = [personShape body];

        [(CCSprite *)[[peopleData objectAtIndex: x] objectForKey:@"feetSprite"] setPosition: [personBody position]];
        [(CCSprite *)[[peopleData objectAtIndex: x] objectForKey:@"bodySprite"] setPosition: [personBody position]];
        [(CCSprite *)[[peopleData objectAtIndex: x] objectForKey:@"headSprite"] setPosition: [personBody position]];
        [(CCSprite *)[[peopleData objectAtIndex: x] objectForKey:@"selectionSprite"] setPosition: [personBody position]];
        
        [personBody activate];
        
        CGPoint lookAtPoint = [[[peopleData objectAtIndex: x] valueForKey:@"lookAtPoint"] CGPointValue];
        float lookAtAngle = 90 - CC_RADIANS_TO_DEGREES(atan2f(lookAtPoint.y - [personBody position].y, lookAtPoint.x - [personBody position].x));
        
        if(ccpLength([personBody velocity]) > 2.0f && [[[peopleData objectAtIndex: x] objectForKey:@"animatingFeet"] boolValue] == NO){
            float velocityAngle = 90 - CC_RADIANS_TO_DEGREES(atan2f([personBody velocity].y, [personBody velocity].x));
            if(fabsf(velocityAngle - [(CCSprite *)[[peopleData objectAtIndex: x] objectForKey:@"bodySprite"] rotation]) < 15.0f){ // velocity and facing same direction
                /*CCAnimate *walk = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:walkingAnimation delay:0.05f]];
                [peopleData[x].feetSprite runAction: [CCSequence actions: walk, [CCCallBlock actionWithBlock:^{
                    peopleData[x].animatingFeet = NO;
                }], nil]];
                peopleData[x].animatingFeet = YES;*/
            }
        }
        
        if([[[peopleData objectAtIndex: x] objectForKey:@"currentState"] intValue] == FTPersonStateWalking){
            lookAtAngle = 90 - CC_RADIANS_TO_DEGREES(atan2f([personBody velocity].y, [personBody velocity].x));
            
            int currentPathIndex = [[[peopleData objectAtIndex: x] objectForKey: @"currentPathIndex"] intValue];
            CGPoint currentDestination = [[[[peopleData objectAtIndex: x] objectForKey: @"path"] objectAtIndex: currentPathIndex - 1] CGPointValue];
            if(ccpLength(ccpSub([personBody position], currentDestination)) < 11.0f){
                currentPathIndex--;
                [[peopleData objectAtIndex: x] setObject:[NSNumber numberWithInt: currentPathIndex] forKey:@"currentPathIndex"];
                if(currentPathIndex == 0){
                    if([[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] != nil){
                        if([[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey: @"uselinkdict"] != nil){
                            NSDictionary *nextDecDict = [[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey: @"uselinkdict"];
                            [self personUseDecoration:x decorationDict:nextDecDict walkToStart: NO];
                        }else{
                            int useRotation = [[[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey:@"use"] objectForKey:@"userotation"] intValue];
                            useRotation += [(CCSprite *)[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey:@"sprite"] rotation];
                            
                            if((int)[(CCSprite *)[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey:@"sprite"] scaleX] == -1 || (int)[(CCSprite *)[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey:@"sprite"] scaleY] == -1){
                                useRotation += 180;
                            }
                            
                            if(useRotation > 360)
                                useRotation %= 360;
                            else if(useRotation < 0)
                                useRotation += 360;
                            
                            if(useRotation == 270)
                                useRotation = -90;
                            
                            CGPoint pathZero = [[[[peopleData objectAtIndex: x] objectForKey: @"path"] objectAtIndex: 0] CGPointValue];
                            CGPoint lookAt = ccp(10 * cosf(CC_DEGREES_TO_RADIANS(90 - useRotation)), 10 * sinf(CC_DEGREES_TO_RADIANS(90 - useRotation)));
                            lookAt = ccpAdd(pathZero, lookAt);
                            [[peopleData objectAtIndex: x] setValue:[NSValue valueWithCGPoint:lookAt] forKey:@"lookAtPoint"];
                            [[peopleData objectAtIndex: x] setObject:[NSNumber numberWithDouble:CFAbsoluteTimeGetCurrent()] forKey: @"useStart"];
                            [self personChangeState:x newState:FTPersonStateUsing];
                        }
                    }else{
                        [self personChangeState:x newState:FTPersonStateStanding];
                        CGPoint pathZero = [[[[peopleData objectAtIndex: x] objectForKey: @"path"] objectAtIndex: 0] CGPointValue];
                        [[peopleData objectAtIndex: x] setValue:[NSValue valueWithCGPoint:ccpAdd(pathZero, ccp(0, 10))] forKey:@"lookAtPoint"];
                    }
                }else{
                    CGPoint newDestination = [[[[peopleData objectAtIndex: x] objectForKey: @"path"] objectAtIndex: currentPathIndex - 1] CGPointValue];
                    [(ChipmunkBody *)[[peopleData objectAtIndex: x] objectForKey:@"staticTargetBody"] setPosition: newDestination];
                }
            }
        }else if([[[peopleData objectAtIndex: x] objectForKey:@"currentState"] intValue] == FTPersonStateUsing){
            if([[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey:@"use"] objectForKey:@"usetime"] != nil){
                if(CFAbsoluteTimeGetCurrent() - [[[peopleData objectAtIndex: x] objectForKey:@"useState"] doubleValue] > [[[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey:@"use"] objectForKey:@"usetime"] doubleValue]){
                    if([[[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential"]){
                        NSArray *usePositions = [[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey: @"use"] objectForKey: @"usepositions"];
                        if(usePositions){
                            int rot = [(CCSprite *)[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey: @"sprite"] rotation];
                            int scaleX = [(CCSprite *)[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey: @"sprite"] scaleX];
                            int scaleY = [(CCSprite *)[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey: @"sprite"] scaleY];
                            CGPoint pos = [(CCSprite *)[[[peopleData objectAtIndex: x] objectForKey:@"useDecoration"] objectForKey: @"sprite"] position];
                            
                            CGPoint endingPoint = CGPointFromString([usePositions objectAtIndex: 0]);
                            endingPoint = [self transformPoint:endingPoint decRot:rot decSX:scaleX decSY:scaleY decPos:pos];
                            
                            NSMutableArray *points = [[NSMutableArray alloc] init];
                            
                            for(int i = [usePositions count] - 1; i > 0; i--){
                                CGPoint usePos = CGPointFromString([usePositions objectAtIndex: i]);
                                
                                CGPoint actualPosition = [self transformPoint:usePos decRot:rot decSX:scaleX decSY:scaleY decPos:pos];
                                [points insertObject:NSStringFromCGPoint(actualPosition) atIndex:0];
                            }
                            [points insertObject:NSStringFromCGPoint(endingPoint) atIndex:0];
                            [self personAddWalkPoints:x points:points];
                            [[peopleData objectAtIndex: x] removeObjectForKey: @"useDecoration"];
                        }
                    }
                }
            }
        }
        
        CCSprite *feetSprite = [[peopleData objectAtIndex: x] objectForKey:@"feetSprite"];
        CCSprite *bodySprite = [[peopleData objectAtIndex: x] objectForKey:@"bodySprite"];
        CCSprite *headSprite = [[peopleData objectAtIndex: x] objectForKey:@"headSprite"];
        
        [feetSprite setRotation: [self rotateTowards:lookAtAngle current:[feetSprite rotation] turnSpeed:240 * delta]];
        [bodySprite setRotation: [self rotateTowards:lookAtAngle current:[bodySprite rotation] turnSpeed:180 * delta]];
        [headSprite setRotation: [self rotateTowards:lookAtAngle current:[headSprite rotation] turnSpeed:360 * delta]];
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

@end
