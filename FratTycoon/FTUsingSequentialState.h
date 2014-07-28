//
//  FTUsingSequentialState.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/18/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTUsingState.h"

typedef enum{
    FTUsingStateStageWalking = 0,
    FTUsingStateStageUsing,
    FTUsingStateStageLeaving
}FTUsingStateStage;

@interface FTUsingSequentialState : FTUsingState{
    NSMutableArray *points;
    int currentPathIndex;
        
    FTUsingStateStage currentStage;
    
    NSMutableDictionary *useLinkDict;
}

- (id)initWithDecorationDict:(NSMutableDictionary *)dd;

@end
