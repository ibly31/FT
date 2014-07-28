//
//  FTWalkingState.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/17/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTWalkingState.h"
#import "FTStandingState.h"
#import "FTPeopleNode.h"

@implementation FTWalkingState
@synthesize nextState;

- (id)initWithPointArray:(NSArray *)ptArray{
    self = [super init];
    if(self){
        self.stateName = @"Walking";
        
        currentPathIndex = 0;
        points = [[NSMutableArray alloc] initWithCapacity: [ptArray count]];
        
        for(NSString *pointString in ptArray){
            CGPoint pt = CGPointFromString(pointString);
            
            NSValue *pointValue = [NSValue valueWithCGPoint: pt];
            [points addObject: pointValue];
            
            currentPathIndex++;
        }
                
        ChipmunkBody *staticTargetBody = [self.personData objectForKey: @"staticTargetBody"];
        [staticTargetBody setPosition: [[points objectAtIndex: currentPathIndex - 1] CGPointValue]];
    }
    return self;
}

- (void)prepare{
    ChipmunkConstraint *pivotJoint = [self.personData objectForKey: @"pivotJoint"];
    [pivotJoint setMaxBias: [[self.personData objectForKey:@"walkSpeed"] floatValue]];
    [pivotJoint setMaxForce: WALK_FORCE];
}

- (void)update:(CCTime)delta{
    ChipmunkBody *personBody = [(ChipmunkShape *)[self.personData objectForKey: @"shape"] body];
    ChipmunkBody *staticTargetBody = (ChipmunkBody *)[self.personData objectForKey:@"staticTargetBody"];

    CGPoint currentDestination = [[points objectAtIndex: currentPathIndex - 1] CGPointValue];
    [staticTargetBody setPosition: currentDestination];
    
    //CGPoint velNorm = ccpNormalize(ccp(currentDestination.x - personBody.position.x, currentDestination.y - personBody.position.y));
    //[personBody setVelocity: ccpMult(velNorm, [[self.personData objectForKey: @"walkSpeed"] floatValue])];
    
    self.bodyLookAtPoint = ccpAdd([personBody position], [personBody velocity]);
    self.headLookAtPoint = bodyLookAtPoint;
    //self.headLookAtPoint = ccpAdd(self.bodyLookAtPoint, ccp(CCRANDOM_MINUS1_1() * 5, CCRANDOM_MINUS1_1() * 5));
    
    if(ccpLength(ccpSub([personBody position], currentDestination)) < 11.0f){
        currentPathIndex--;
        if(currentPathIndex <= 0){
            if(self.nextState != nil){
                [self.peopleNode personChangeState:self.personIndex newState:self.nextState];
            }else{
                CGPoint pathZero = [[points objectAtIndex: 0] CGPointValue];
                FTStandingState *standingState = [[FTStandingState alloc] initWithTargetLocation: pathZero];
                [self.peopleNode personChangeState:self.personIndex newState:standingState];
            }
        }else{
            CGPoint newDestination = [[points objectAtIndex: currentPathIndex - 1] CGPointValue];
            [staticTargetBody setPosition: newDestination];
        }
    }
}

@end
