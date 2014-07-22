//
//  FTGettingDrinkState.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/22/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTPersonState.h"

typedef enum{
    FTGettingDrinkStateStageWalking = 0,
    FTGettingDrinkStateStageGetting
}FTGettingStateDrinkStage;

@interface FTGettingDrinkState : FTPersonState{
    NSDictionary *decDict;
    
    FTGettingStateDrinkStage currentStage;
    
    NSTimeInterval useStart;
}

- (id)initWithDecorationDict:(NSDictionary *)dd;

@end
