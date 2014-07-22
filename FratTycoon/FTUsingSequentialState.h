//
//  FTUsingSequentialState.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/18/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTPersonState.h"

typedef enum{
    FTUsingStateStageWalking = 0,
    FTUsingStateStageUsing,
    FTUsingStateStageLeaving
}FTUsingStateStage;

@interface FTUsingSequentialState : FTPersonState{
    NSMutableArray *points;
    int currentPathIndex;
    
    NSTimeInterval useStart;
    
    FTUsingStateStage currentStage;
    
    NSDictionary *decDict;
    NSDictionary *useLinkDict;
}

- (id)initWithDecorationDict:(NSDictionary *)dd;

@end
