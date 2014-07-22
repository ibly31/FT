//
//  FTPhysicsDebugNode.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/18/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "CCDrawNode.h"
#import "ObjectiveChipmunk.h"

#define CIRCLE_NUM_VERTS 32

@interface FTPhysicsDebugNode : CCDrawNode

@property (nonatomic, retain) ChipmunkSpace *space;

@end
