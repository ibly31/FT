//
//  FTPersonState.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/17/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTPersonState.h"
#import "FTPeopleNode.h"

@implementation FTPersonState
@synthesize personIndex;
@synthesize personData;
@synthesize peopleNode;
@synthesize bodyLookAtPoint;
@synthesize headLookAtPoint;
@synthesize stateName;

- (id)init{
    self = [super init];
    if(self){
        self.stateName = @"default";
    }
    return self;
}

- (void)update{
    
}

- (void)prepare{
    
}

@end
