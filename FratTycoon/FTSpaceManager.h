//
//  FTSpaceManager.h
//  FratTycoon
//
//  Created by Billy Connolly on 2/27/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "chipmunk.h"
//#import "chipmunk_private.h"

#define STATIC_MASS INFINITY

/*! Collision Moments */
typedef enum {
	COLLISION_BEGIN = 1,
	COLLISION_PRESOLVE,
	COLLISION_POSTSOLVE,
	COLLISION_SEPARATE
} CollisionMoment;

@interface FTSpaceManager : NSObject{
    /* Number of steps (across dt) perform on each step call */
	int	_steps;
    
    NSMutableArray *_invocations;
	
	/* The dt used last within step */
	cpFloat	_lastDt;
	
	/* If constant dt used, then this accumulates left over */
	cpFloat _timeAccumulator;
    
    cpSpace *space;
    
    BOOL							_cleanupBodyDependencies;
    BOOL							_rehashStaticEveryStep;
    cpFloat							_constantDt;
}

@property cpSpace *space;

- (void)step:(cpFloat)delta;
- (cpShape*)addCircleAt:(cpVect)pos mass:(cpFloat)mass radius:(cpFloat)radius;
- (cpShape*)addRectAt:(cpVect)pos mass:(cpFloat)mass width:(cpFloat)width height:(cpFloat)height rotation:(cpFloat)r;
- (cpShape*)addPolyAt:(cpVect)pos mass:(cpFloat)mass rotation:(cpFloat)r numPoints:(int)numPoints points:(cpVect)pt, ...;
- (void)ignoreCollisionBetweenType:(unsigned int)type1 otherType:(unsigned int)type2;
- (void)addCollisionCallbackBetweenType:(unsigned int)type1 otherType:(unsigned int)type2 target:(id)target selector:(SEL)selector;
- (void)addCollisionCallbackBetweenType:(unsigned int)type1
							  otherType:(unsigned int)type2
								 target:(id)target
							   selector:(SEL)selector
								moments:(CollisionMoment)moment, ... NS_REQUIRES_NIL_TERMINATION;

- (void)removeCollisionCallbackBetweenType:(unsigned int)type1 otherType:(unsigned int)type2;

- (void)removeAndFreeBody:(cpBody*)body;
- (void)removeBody:(cpBody*)body;

@end
