//
//  FTWalkingState.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/17/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTPersonState.h"

@interface FTWalkingState : FTPersonState{
    NSMutableArray *points;
    int currentPathIndex;
    
    FTPersonState *nextState;
}

- (id)initWithPointArray:(NSArray *)ptArray;

@property (nonatomic, retain) FTPersonState *nextState;

@end
