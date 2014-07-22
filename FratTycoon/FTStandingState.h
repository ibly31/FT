//
//  FTStandingState.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/18/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTPersonState.h"

@interface FTStandingState : FTPersonState{
    CGPoint targetStandingLocation;
    
    NSTimeInterval lastLookChangeTime;
    NSTimeInterval currentLookChangeDelay;
}

- (id)initWithTargetLocation:(CGPoint)pt;

@end
