//
//  FTPersonState.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/17/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"
#import "FTConstants.h"

@class FTPeopleNode;

@interface FTPersonState : NSObject{
    CGPoint bodyLookAtPoint;
    CGPoint headLookAtPoint;
}

@property int personIndex;
@property (nonatomic, retain) NSMutableDictionary *personData;
@property (nonatomic, retain) FTPeopleNode *peopleNode;
@property (nonatomic, retain) NSString *stateName;
@property CGPoint bodyLookAtPoint;
@property CGPoint headLookAtPoint;

- (void)prepare;
- (void)update;

@end
