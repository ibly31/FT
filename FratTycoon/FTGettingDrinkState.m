//
//  FTGettingDrinkState.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/22/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTGettingDrinkState.h"
#import "FTPeopleNode.h"
#import "FTStandingState.h"

@implementation FTGettingDrinkState

- (id)initWithDecorationDict:(NSDictionary *)dd{
    self = [super init];
    if(self){
        self.stateName = @"Getting Drink";
        decDict = dd;
        
        currentStage = FTGettingDrinkStateStageWalking;
    }
    return self;
}

- (void)update{
    ChipmunkBody *personBody = [(ChipmunkShape *)[self.personData objectForKey: @"shape"] body];
    ChipmunkBody *staticTargetBody = (ChipmunkBody *)[self.personData objectForKey:@"staticTargetBody"];
    
    CGPoint usePosition = CGPointFromString([[decDict objectForKey: @"use"] objectForKey: @"useposition"]);
    
    int rot = [(CCSprite *)[decDict objectForKey: @"sprite"] rotation];
    int scaleX = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleX];
    int scaleY = [(CCSprite *)[decDict objectForKey: @"sprite"] scaleY];
    CGPoint pos = [(CCSprite *)[decDict objectForKey: @"sprite"] position];
    
    CGPoint currentDestination = [self.peopleNode transformPoint:usePosition decRot:rot decSX:scaleX decSY:scaleY decPos:pos];
    
    [staticTargetBody setPosition: currentDestination];
    
    if(currentStage == FTGettingDrinkStateStageWalking){
        if(ccpLength(ccpSub([personBody position], currentDestination)) < 11.0f){
            int useRotation = [self.peopleNode transformRotation:[[[decDict objectForKey:@"use"] objectForKey:@"userotation"] intValue] decRot:rot decSX:scaleX decSY:scaleY];
            CGPoint lookAt = ccp(10 * cosf(CC_DEGREES_TO_RADIANS(90 - useRotation)), 10 * sinf(CC_DEGREES_TO_RADIANS(90 - useRotation)));
            self.bodyLookAtPoint = ccpAdd(currentDestination, lookAt);
            self.headLookAtPoint = bodyLookAtPoint;
            
            useStart = CFAbsoluteTimeGetCurrent();
            currentStage = FTGettingDrinkStateStageGetting;
        }else{
            self.bodyLookAtPoint = ccpAdd([personBody position], [personBody velocity]);
            self.headLookAtPoint = bodyLookAtPoint;
        }
    }else{
        if([[decDict objectForKey:@"use"] objectForKey:@"usetime"] != nil){
            if(CFAbsoluteTimeGetCurrent() - useStart > [[[decDict objectForKey:@"use"] objectForKey:@"usetime"] doubleValue]){
                FTStandingState *standingState = [[FTStandingState alloc] initWithTargetLocation: currentDestination];
                [self.peopleNode personChangeState:self.personIndex newState:standingState];
            }
        }
    }
}

@end
