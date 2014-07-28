//
//  FTUsingState.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/27/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTPersonState.h"

@interface FTUsingState : FTPersonState{
    NSMutableDictionary *decDict;
    NSTimeInterval useStart;
}

@property (nonatomic, retain) NSMutableDictionary *decDict;
@property NSTimeInterval useStart;

- (void)finishUse:(BOOL)assign;

@end
