//
//  FTGettingDrinkState.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/22/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTUsingState.h"

typedef enum{
    FTGettingDrinkStateStageWalking = 0,
    FTGettingDrinkStateStageGetting
}FTGettingStateDrinkStage;

@interface FTGettingDrinkState : FTUsingState{
    FTGettingStateDrinkStage currentStage;
}

- (id)initWithDecorationDict:(NSMutableDictionary *)dd;

@end
