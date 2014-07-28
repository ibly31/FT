//
//  FTStandingState.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/18/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTStandingState.h"

@implementation FTStandingState

- (id)initWithTargetLocation:(CGPoint)pt{
    self = [super init];
    if(self){
        self.stateName = @"Standing";
        
        targetStandingLocation = pt;
        
        self.bodyLookAtPoint = ccpAdd(pt, ccp(0, 10));
        self.headLookAtPoint = bodyLookAtPoint;
    }
    return self;
}

- (void)prepare{
    lastLookChangeTime = CFAbsoluteTimeGetCurrent();
    currentLookChangeDelay = CCRANDOM_0_1() * 3.5f + 0.5f;
    
    ChipmunkConstraint *pivotJoint = [self.personData objectForKey: @"pivotJoint"];
    [pivotJoint setMaxBias: 20.0f];
    [pivotJoint setMaxForce: STAND_FORCE];
}

- (void)update:(CCTime)delta{
    ChipmunkBody *personBody = [(ChipmunkShape *)[self.personData objectForKey: @"shape"] body];

    if(CFAbsoluteTimeGetCurrent() - lastLookChangeTime > currentLookChangeDelay){
        float bodyLookAtAngle = 90 - CC_RADIANS_TO_DEGREES(atan2f(bodyLookAtPoint.y - [personBody position].y, bodyLookAtPoint.x - [personBody position].x));
        float newHeadLookAtAngle = bodyLookAtAngle + CCRANDOM_MINUS1_1() * 80.0f;
        
        float newHeadLookAtAngleRads = CC_DEGREES_TO_RADIANS(90 - newHeadLookAtAngle);
        self.headLookAtPoint = ccpAdd([personBody position], ccpMult(ccpForAngle(newHeadLookAtAngleRads), 10));
        
        lastLookChangeTime = CFAbsoluteTimeGetCurrent();
        currentLookChangeDelay = CCRANDOM_0_1() * 3.5f + 0.5f;
    }
}

@end
