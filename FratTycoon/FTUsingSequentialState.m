//
//  FTUsingSequentialState.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/18/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTUsingSequentialState.h"
#import "FTPeopleNode.h"
#import "FTHouseNode.h"
#import "FTDecorationNode.h"
#import "FTStandingState.h"

@implementation FTUsingSequentialState

- (id)initWithDecorationDict:(NSDictionary *)dd{
    self = [super init];
    if(self){
        self.stateName = @"Using-Sequential";
        
        currentStage = FTUsingStateStageWalking;
        
        decDict = dd;
        
        currentPathIndex = 0;
        points = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)prepare{
    if([decDict objectForKey: @"use"] != nil){
        if([[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential"] || [[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential-link"]){
            NSArray *usePositions = [[decDict objectForKey: @"use"] objectForKey: @"usepositions"];
            if(usePositions){
                int rot = [(CCSprite *)[decDict objectForKey: @"sprite"] rotation];
                int scaleX = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleX];
                int scaleY = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleY];
                
                if([[[decDict objectForKey: @"use"] objectForKey: @"usestyle"] isEqualToString: @"sequential-link"]){
                    NSDictionary *nextDecDict = [[[self.peopleNode houseNode] decorationNode] decorationFromSequentialLink: decDict];
                    useLinkDict = nextDecDict;
                }
                
                CGPoint startingPoint = CGPointFromString([usePositions objectAtIndex: 0]);
                startingPoint = [self.peopleNode transformPoint:startingPoint decRot:rot decSX:scaleX decSY:scaleY decPos:[(CCSprite *)[decDict objectForKey: @"sprite"] position]];
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                dispatch_async(queue, ^{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if(points != nil){
                            for(int x = 0; x < [usePositions count]; x++){
                                CGPoint usePos = CGPointFromString([usePositions objectAtIndex: x]);
                                CGPoint actualPosition = [self.peopleNode transformPoint:usePos decRot:rot decSX:scaleX decSY:scaleY decPos:[(CCSprite *)[decDict objectForKey:@"sprite"] position]];
                                [points insertObject:[NSValue valueWithCGPoint:actualPosition] atIndex:0];
                                currentPathIndex = (int)[points count];
                            }
                        }
                    });
                });
            }
        }
    }
    
    ChipmunkConstraint *pivotJoint = [self.personData objectForKey: @"pivotJoint"];
    [pivotJoint setMaxBias: [[self.personData objectForKey:@"walkSpeed"] floatValue]];
    [pivotJoint setMaxForce: WALK_FORCE];
}

- (void)update{
    ChipmunkBody *personBody = [(ChipmunkShape *)[self.personData objectForKey: @"shape"] body];
    ChipmunkBody *staticTargetBody = (ChipmunkBody *)[self.personData objectForKey:@"staticTargetBody"];
    
    //CGPoint velNorm = ccpNormalize(ccp(currentDestination.x - personBody.position.x, currentDestination.y - personBody.position.y));
    //[personBody setVelocity: ccpMult(velNorm, [[self.personData objectForKey: @"walkSpeed"] floatValue])];
    
    if(currentStage == FTUsingStateStageWalking){
        self.bodyLookAtPoint = ccpAdd([personBody position], [personBody velocity]);
        self.headLookAtPoint = bodyLookAtPoint;
        
        CGPoint currentDestination = [[points objectAtIndex: currentPathIndex - 1] CGPointValue];
        [staticTargetBody setPosition: currentDestination];
        
        if(ccpLength(ccpSub([personBody position], currentDestination)) < 11.0f){
            currentPathIndex--;
            if(currentPathIndex == 0){
                if(useLinkDict != nil){
                    FTUsingSequentialState *usingState = [[FTUsingSequentialState alloc] initWithDecorationDict: useLinkDict];
                    [self.peopleNode personChangeState:self.personIndex newState:usingState];
                    return;
                }
                
                currentStage = FTUsingStateStageUsing;
                useStart = CFAbsoluteTimeGetCurrent();
                
                int sx = (int)[(CCSprite *)[decDict objectForKey:@"sprite"] scaleX];
                int sy = (int)[(CCSprite *)[decDict objectForKey:@"sprite"] scaleY];
                
                int useRotation = [self.peopleNode transformRotation:[[[decDict objectForKey:@"use"] objectForKey:@"userotation"] intValue] decRot:[(CCSprite *)[decDict objectForKey:@"sprite"] rotation] decSX:sx decSY:sy];
                
                CGPoint pathZero = [[points objectAtIndex: 0] CGPointValue];
                CGPoint lookAt = ccp(10 * cosf(CC_DEGREES_TO_RADIANS(90 - useRotation)), 10 * sinf(CC_DEGREES_TO_RADIANS(90 - useRotation)));
                self.bodyLookAtPoint = ccpAdd(pathZero, lookAt);
                self.headLookAtPoint = bodyLookAtPoint;
            }else{
                CGPoint newDestination = [[points objectAtIndex: currentPathIndex - 1] CGPointValue];
                [staticTargetBody setPosition: newDestination];
            }
        }
    }else if(currentStage == FTUsingStateStageUsing){
        if([[decDict objectForKey:@"use"] objectForKey:@"usetime"] != nil){
            if(CFAbsoluteTimeGetCurrent() - useStart > [[[decDict objectForKey:@"use"] objectForKey:@"usetime"] doubleValue]){
                currentStage = FTUsingStateStageLeaving;
                NSString *useStyle = [[decDict objectForKey: @"use"] objectForKey: @"usestyle"];
                if([useStyle isEqualToString: @"sequential"] || [useStyle isEqualToString: @"sequential-link"]){
                    NSArray *usePositions = [[decDict objectForKey: @"use"] objectForKey: @"usepositions"];
                    if(usePositions){
                        int rot = [(CCSprite *)[decDict objectForKey: @"sprite"] rotation];
                        int scaleX = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleX];
                        int scaleY = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleY];
                        CGPoint pos = [(CCSprite *)[decDict objectForKey: @"sprite"] position];
                        
                        CGPoint endingPoint = CGPointFromString([usePositions objectAtIndex: 0]);
                        endingPoint = [self.peopleNode transformPoint:endingPoint decRot:rot decSX:scaleX decSY:scaleY decPos:pos];
                        
                        points = [[NSMutableArray alloc] init];
                        
                        for(int i = (int)[usePositions count] - 1; i > 0; i--){
                            CGPoint usePos = CGPointFromString([usePositions objectAtIndex: i]);
                            
                            CGPoint actualPosition = [self.peopleNode transformPoint:usePos decRot:rot decSX:scaleX decSY:scaleY decPos:pos];
                            [points insertObject:[NSValue valueWithCGPoint: actualPosition] atIndex:0];
                        }
                        [points insertObject:[NSValue valueWithCGPoint: endingPoint] atIndex:0];
                        currentPathIndex = (int)[points count];
                    }
                }
            }
        }
    }else if(currentStage == FTUsingStateStageLeaving){
        self.bodyLookAtPoint = ccpAdd([personBody position], [personBody velocity]);
        self.headLookAtPoint = bodyLookAtPoint;
        
        CGPoint currentDestination = [[points objectAtIndex: currentPathIndex - 1] CGPointValue];
        [staticTargetBody setPosition: currentDestination];
        
        if(ccpLength(ccpSub([personBody position], currentDestination)) < 11.0f){
            currentPathIndex--;
            if(currentPathIndex == 0){
                FTStandingState *standingState = [[FTStandingState alloc] initWithTargetLocation: currentDestination];
                [self.peopleNode personChangeState:self.personIndex newState:standingState];
            }else{
                CGPoint newDestination = [[points objectAtIndex: currentPathIndex - 1] CGPointValue];
                [staticTargetBody setPosition: newDestination];
            }
        }
    }
}

@end
