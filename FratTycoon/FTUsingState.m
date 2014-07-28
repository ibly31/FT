//
//  FTUsingState.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/27/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTUsingState.h"
#import "FTHouseNode.h"
#import "FTStandingState.h"
#import "FTWalkingState.h"

@implementation FTUsingState
@synthesize decDict;
@synthesize useStart;

- (void)finishUse:(BOOL)assign{
    int currentUsers = [[decDict objectForKey: @"numusers"] intValue];
    currentUsers--;
    
    if(currentUsers < 0)
        currentUsers = 0;
    
    [decDict setObject:@(currentUsers) forKey:@"numusers"];
    
    CGPoint personPos = [(CCSprite *)[self.personData objectForKey: @"bodySprite"] position];
    
    if(assign){
        int attempts = 0;
        while(YES){
            CGPoint try = ccp(CCRANDOM_MINUS1_1() * 150, CCRANDOM_MINUS1_1() * 150);
            try = ccpAdd(try, personPos);
            
            attempts++;
            
            if(attempts > 100){
                NSLog(@"Too many attempts");
                break;
            }
            
            if([[self.peopleNode houseNode] pointCanSpawnPerson: try]){
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                dispatch_async(queue, ^{
                    NSArray *points = [self.peopleNode pointsForPersonWalkTo:self.personIndex point:try];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if(points != nil){
                            FTStandingState *standingState = [[FTStandingState alloc] initWithTargetLocation: try];
                            FTWalkingState *walkingState = [[FTWalkingState alloc] initWithPointArray: points];
                            [walkingState setNextState: standingState];
                            [self.peopleNode personChangeState:self.personIndex newState:walkingState];
                        }
                    });
                });
                break;
            }
        }
    }
}

@end
