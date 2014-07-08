//
//  FTSpaceManager.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/27/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTSpaceManager.h"

typedef struct { cpCollisionType a, b; } cpCollisionTypePair;

@interface FTInvocation : NSObject
{
@public
    cpCollisionType a;
    cpCollisionType b;
    
    NSInvocation *invocation;
}
@property (readwrite, retain) NSInvocation *invocation;
@end

@implementation FTInvocation

@synthesize invocation;

-(void)dealloc
{
    self.invocation = nil;
}

@end

@implementation FTSpaceManager
@synthesize space;

- (id)init{
    self = [super init];
    if(self){
        self.space = cpSpaceNew();
        
        cpSpaceSetGravity(space, cpvzero);
        cpSpaceSetSleepTimeThreshold(space, 0.4f);
        
        _steps = 2;
        _rehashStaticEveryStep = NO;
        _cleanupBodyDependencies = YES;
        _constantDt = 0.0f;
        _timeAccumulator = 0.0f;
        _invocations = [[NSMutableArray alloc] init];

    }
    return self;
}

static void addShape(cpSpace *space, void *obj, void *data){
	cpShape *shape = (cpShape*)(obj);
	cpSpaceAddShape(space, shape);
}

static void removeShape(cpSpace *space, void *obj, void *data)
{
	[(FTSpaceManager*)(data) removeAndMaybeFreeShape:(cpShape*)(obj) freeShape:NO];
}

static void removeAndFreeShape(cpSpace *space, void *shape, void *data)
{
	[(FTSpaceManager*)(data) removeAndMaybeFreeShape:(cpShape*)(shape) freeShape:YES];
}

static void removeBody(cpSpace *space, void *obj, void *data)
{
	[(FTSpaceManager*)(data) removeAndMaybeFreeBody:(cpBody*)(obj) freeBody:NO];
}

static void removeAndFreeBody(cpSpace *space, void *body, void *data)
{
	[(FTSpaceManager*)(data) removeAndMaybeFreeBody:(cpBody*)(body) freeBody:YES];
}

static void freeShapesHelper(cpShape *shape, void *data)
{
	cpSpace *space = (cpSpace*)data;
    
    //Do this for rogue bodies (Free them, clear any references to ensure this only happens once)
	if (shape)
    {
        cpBody* body = shape->body;
        
        if (body
            && body != space->staticBody            //not the spaces own static body
            && !cpSpaceContainsBody(space, body))   //rogue body
        {
            //clear refs from all shapes
            cpBodyEachShape(body, clearBodyReferenceFromShape, NULL);
            cpBodyFree(body);
        }
        
        // no-no freeSpace takes care of this
        //cpShapeFree(shape);
    }
}

static void freeBodiesHelper(cpBody *body, void *data)
{
	//cpSpace *space = (cpSpace*)data;
	if (body)
        cpBodyFree(body);
}

static void freeConstraintsHelper(cpConstraint *constraint, void *data)
{
	//cpSpace *space = (cpSpace*)data;
	if (constraint)
        cpConstraintFree(constraint);
}

static void addBody(cpSpace *space, void *obj, void *data)
{
	cpBody *body = (cpBody*)(obj);
	
	if (body->m != STATIC_MASS && !cpSpaceContainsBody(space, body))
		cpSpaceAddBody(space, body);
}

-(void) step: (cpFloat) delta
{
	//re-calculate static shape positions if this is set
	if (_rehashStaticEveryStep)
		cpSpaceReindexStatic(space);
	
	_lastDt = delta;
	
	if (!_constantDt)
	{
		cpFloat dt = delta/_steps;
		for(int i=0; i<_steps; i++)
			cpSpaceStep(space, dt);
	}
	else
	{
		cpFloat dt = _constantDt/_steps;
		delta += _timeAccumulator;
		while(delta >= _constantDt)
		{
			for(int i=0; i<_steps; i++)
				cpSpaceStep(space, dt);
			
			delta -= _constantDt;
		}
		
		_timeAccumulator = delta > 0 ? delta : 0.0f;
	}
	
}

-(BOOL) isSpaceLocked
{
    return space->CP_PRIVATE(locked) != 0;
}

-(void) removeAndFreeBody:(cpBody*)body
{
    if ([self isSpaceLocked])
		cpSpaceAddPostStepCallback(space, removeAndFreeBody, body, self);
	else
		[self removeAndMaybeFreeBody:body freeBody:YES];
}

-(void) removeBody:(cpBody*)body
{
  	if ([self isSpaceLocked])
		cpSpaceAddPostStepCallback(space, removeBody, body, self);
	else
		[self removeAndMaybeFreeBody:body freeBody:NO];
}

-(void) addBody:(cpBody*)body
{
	if ([self isSpaceLocked])
		cpSpaceAddPostStepCallback(space, addBody, body, self);
	else
		addBody(space, body, self);
}

-(void) removeAndMaybeFreeBody:(cpBody*)body freeBody:(BOOL)freeBody
{
    //in this space?
    if (cpSpaceContainsBody(space, body))
        cpSpaceRemoveBody(space, body);
    
    //Free it
    if (freeBody)
    {
        //cleanup any constraints
        if (_cleanupBodyDependencies)
            [self removeAndFreeConstraintsOnBody:body];
        
        cpBodyFree(body);
    }
}

-(void) removeAndMaybeFreeShape:(cpShape*)shape freeShape:(BOOL)freeShape
{
    //This space owns it?
    if (cpSpaceContainsShape(space, shape))
        cpSpaceRemoveShape(space, shape);
	
	//Make sure it's not our static body
	if (shape->body != space->staticBody)
	{
		// If zero shapes on this body, get rid of it
		if ([self shapesOnBody:shape->body] == 0)
            [self removeAndMaybeFreeBody:shape->body freeBody:freeShape];
	}
	
	if (freeShape)
		cpShapeFree(shape);
}

static void clearBodyReferenceFromShape(cpBody *body, cpShape *shape, void *data)
{
    shape->body = NULL;
}

static void countBodyReferences(cpBody *body, cpShape *shape, void *data)
{
    int *count = (int*)data;
    (*count)++;
}

-(int) shapesOnBody:(cpBody*)body{
    int countShared = 0;
    
    //anyone else have this body? - should prob not count static..?
    cpBodyEachShape(body, countBodyReferences, &countShared);
    
    return countShared;
}

-(cpConstraint*) removeConstraint:(cpConstraint*)constraint
{
	cpSpaceRemoveConstraint(space, constraint);
	return constraint;
}

-(void) removeAndFreeConstraint:(cpConstraint*)constraint
{
	[self removeConstraint:constraint];
	cpConstraintFree(constraint);
}

void removeAndFreeConstraintsOnBody(cpBody *body, cpConstraint *constraint, void *data){
    cpBodyRemoveConstraint(body, constraint);
    cpConstraintFree(constraint);
}

-(void) removeAndFreeConstraintsOnBody:(cpBody*)body{
    cpBodyEachConstraint(body, (cpBodyConstraintIteratorFunc)removeAndFreeConstraintsOnBody, body);
}

-(void) setupDefaultShape:(cpShape*) s{
	s->e = .7f;
	s->u = .05f;
	s->collision_type = 0;
	s->data = nil;
}

-(cpShape*) addCircleAt:(cpVect)pos mass:(cpFloat)mass radius:(cpFloat)radius
{
    cpBody* body;
	if (mass != STATIC_MASS)
        body = cpBodyNew(mass, cpMomentForCircle(mass, radius, radius, cpvzero));
	else
        body = cpBodyNewStatic();
    
    cpBodySetPos(body, pos);
    
    [self addBody:body];
	
	return [self addCircleToBody:body radius:radius];
}

-(cpShape*) addCircleToBody:(cpBody*)body radius:(cpFloat)radius
{
    return [self addCircleToBody:body radius:radius offset:cpvzero];
}

-(cpShape*) addCircleToBody:(cpBody*)body radius:(cpFloat)radius offset:(CGPoint)offset
{
    cpShape* shape;
    
    shape = cpCircleShapeNew(body, radius, cpvzero);
    cpCircleShapeSetOffset(shape, offset);
	
	[self setupDefaultShape:shape];
	[self addShape:shape];
    
    return shape;
}

-(cpShape*) addRectAt:(cpVect)pos mass:(cpFloat)mass width:(cpFloat)width height:(cpFloat)height rotation:(cpFloat)r
{
	const cpFloat halfHeight = height/2.0f;
	const cpFloat halfWidth = width/2.0f;
	return [self addPolyAt:pos mass:mass rotation:r numPoints:4 points:
            cpv(-halfWidth, halfHeight),	/* top-left */
            cpv( halfWidth, halfHeight),	/* top-right */
            cpv( halfWidth,-halfHeight),	/* bottom-right */
            cpv(-halfWidth,-halfHeight)];	/* bottom-left */
}

-(cpShape*) addRectToBody:(cpBody*)body width:(cpFloat)width height:(cpFloat)height rotation:(cpFloat)r
{
    return [self addRectToBody:body width:width height:height rotation:r offset:cpvzero];
}

-(cpShape*) addRectToBody:(cpBody*)body width:(cpFloat)width height:(cpFloat)height rotation:(cpFloat)r offset:(CGPoint)offset
{
    const cpFloat halfHeight = height/2.0f;
	const cpFloat halfWidth = width/2.0f;
    cpVect verts[4] = {
        cpv(-halfWidth, halfHeight),	/* top-left */
        cpv( halfWidth, halfHeight),	/* top-right */
        cpv( halfWidth,-halfHeight),	/* bottom-right */
        cpv(-halfWidth,-halfHeight)     /* bottom-left */
    };
    
    return [self addPolyToBody:body rotation:r numPoints:4 pointsArray:verts offset:offset];
}

-(cpShape*) addPolyAt:(cpVect)pos mass:(cpFloat)mass rotation:(cpFloat)r numPoints:(int)numPoints points:(cpVect)pt, ...
{
	cpShape* shape = nil;
	
	va_list args;
	va_start(args,pt);
    
	//Setup our vertices
	cpVect verts[numPoints];
	verts[0] = pt;
	for (int i = 1; i < numPoints; i++)
		verts[i] = va_arg(args, cpVect);
    
	shape = [self addPolyAt:pos mass:mass rotation:r numPoints:numPoints pointsArray:verts];
    
	va_end(args);
	
	return shape;
}

-(cpShape*) addPolyAt:(cpVect)pos mass:(cpFloat)mass rotation:(cpFloat)r points:(NSArray*)points
{
	//Setup our vertices
	int numPoints = [points count];
	cpVect verts[numPoints];
	for (int i = 0; i < numPoints; i++)
	{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		verts[i] = [[points objectAtIndex:i] CGPointValue];
#else
		verts[i] = [[points objectAtIndex:i] pointValue];
#endif
	}
	return [self addPolyAt:pos mass:mass rotation:r numPoints:numPoints pointsArray:verts];
}

//patch submitted by ja...@nuts.pl for c-style arrays
-(cpShape*) addPolyAt:(cpVect)pos mass:(cpFloat)mass rotation:(cpFloat)r numPoints:(int)numPoints pointsArray:(cpVect*)points
{
	if (numPoints >= 3)
	{
		//Setup our poly shape
		cpBody *body;
        if (mass != STATIC_MASS)
            body = cpBodyNew(mass, cpMomentForPoly(mass, numPoints, points, cpvzero));
        else
            body = cpBodyNewStatic();
        
        cpBodySetPos(body, pos);
        cpBodySetAngle(body, r);
        
        [self addBody:body];
        
        //rotation should be zero now
        return [self addPolyToBody:body rotation:0 numPoints:numPoints pointsArray:points];
	}
    else
        return nil;
}

-(cpShape*) addPolyToBody:(cpBody*)body rotation:(cpFloat)r points:(NSArray*)points
{
    return [self addPolyToBody:body rotation:r points:points offset:cpvzero];
}

-(cpShape*) addPolyToBody:(cpBody*)body rotation:(cpFloat)r points:(NSArray*)points offset:(CGPoint)offset
{
    //Setup our vertices
	int numPoints = [points count];
	cpVect verts[numPoints];
	for (int i = 0; i < numPoints; i++)
	{
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		verts[i] = [[points objectAtIndex:i] CGPointValue];
#else
		verts[i] = [[points objectAtIndex:i] pointValue];
#endif
	}
	return [self addPolyToBody:body rotation:r numPoints:numPoints pointsArray:verts offset:offset];
}

-(cpShape*) addPolyToBody:(cpBody*)body rotation:(cpFloat)r numPoints:(int)numPoints pointsArray:(cpVect*)points
{
    return [self addPolyToBody:body rotation:r numPoints:numPoints pointsArray:points offset:cpvzero];
}

-(cpShape*) addPolyToBody:(cpBody*)body rotation:(cpFloat)r numPoints:(int)numPoints pointsArray:(cpVect*)points offset:(CGPoint)offset
{
    cpShape *shape = nil;
    
    if (numPoints >= 3)
    {
        if (r != 0.0f)
        {
            cpVect angle = cpvforangle(r);
            for (int i = 0; i < numPoints; i++)
                points[i] = cpvrotate(points[i], angle);
        }
        
        shape = cpPolyShapeNew(body, numPoints, points, offset);
		
		[self setupDefaultShape:shape];
		[self addShape:shape];
    }
    
    return shape;
}

-(void) addShape:(cpShape*)shape
{
	if ([self isSpaceLocked])
		cpSpaceAddPostStepCallback(space, addShape, shape, self);
	else
		addShape(space, shape, self);
}

static void removeCollision(cpSpace *space, void *collisionPair, void *inv_list)
{
    cpCollisionTypePair *ids = (cpCollisionTypePair*)collisionPair;
    NSMutableArray *invocations = (NSMutableArray*)inv_list;
    FTInvocation *found_info = nil;
    
    /* Find our invocation info so we can remove it */
    for (FTInvocation *info in invocations)
    {
        if ((info->a == ids->a && info->b == ids->b) ||
            (info->b == ids->a && info->a == ids->b))
        {
            found_info = info;
            break;
        }
    }
    
    if (found_info)
        [invocations removeObject:found_info];
    
    cpSpaceRemoveCollisionHandler(space, ids->a, ids->b);
    
    /* This was allocated earlier, free it now */
    free(ids);
}

static int handleInvocations(CollisionMoment moment, cpArbiter *arb, struct cpSpace *space, void *data)
{
    FTInvocation *info = (FTInvocation*)data;
	NSInvocation *invocation = info->invocation;
	
	@try {
		[invocation setArgument:&moment atIndex:2];
		[invocation setArgument:&arb atIndex:3];
		[invocation setArgument:&space atIndex:4];
	}
	@catch (NSException *e) {
		//No biggie, continue!
	}
	
	[invocation invoke];
	
	//default is yes, thats what it is in chipmunk
	BOOL retVal = YES;
	
	//not sure how heavy these methods are...
	if ([[invocation methodSignature]  methodReturnLength] > 0)
		[invocation getReturnValue:&retVal];
	
	return retVal;
}

static int collBegin(cpArbiter *arb, struct cpSpace *space, void *data)
{
	return handleInvocations(COLLISION_BEGIN, arb, space, data);
}

static int collPreSolve(cpArbiter *arb, struct cpSpace *space, void *data)
{
	return handleInvocations(COLLISION_PRESOLVE, arb, space, data);
}

static void collPostSolve(cpArbiter *arb, struct cpSpace *space, void *data)
{
	handleInvocations(COLLISION_POSTSOLVE, arb, space, data);
}

static void collSeparate(cpArbiter *arb, struct cpSpace *space, void *data)
{
	handleInvocations(COLLISION_SEPARATE, arb, space, data);
}

static int collIgnore(cpArbiter *arb, struct cpSpace *space, void *data)
{
	return 0;
}

-(void) ignoreCollisionBetweenType:(unsigned int)type1 otherType:(unsigned int)type2
{
	cpSpaceAddCollisionHandler(space, type1, type2, NULL, collIgnore, NULL, NULL, NULL);
}


-(void) addCollisionCallbackBetweenType:(unsigned int)type1 otherType:(unsigned int) type2 target:(id)target selector:(SEL)selector
{
	//set up the invocation
	NSMethodSignature * sig = [[target class] instanceMethodSignatureForSelector:selector];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
	
	[invocation setTarget:target];
	[invocation setSelector:selector];
    
    FTInvocation *info = [[[FTInvocation alloc] init] autorelease];
    info->a = type1;
    info->b = type2;
    info.invocation = invocation;
	
	//add the callback to chipmunk
	cpSpaceAddCollisionHandler(space, type1, type2, collBegin, collPreSolve, collPostSolve, collSeparate, info);
	
	//we'll keep a ref so it won't disappear, prob could just retain and clear hash later
	[_invocations addObject:info];
}

-(void) addCollisionCallbackBetweenType:(unsigned int)type1
							  otherType:(unsigned int)type2
								 target:(id)target
							   selector:(SEL)selector
								moments:(CollisionMoment)moment, ...
{
	//set up the invocation
	NSMethodSignature * sig = [[target class] instanceMethodSignatureForSelector:selector];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
	
	[invocation setTarget:target];
	[invocation setSelector:selector];
    
    FTInvocation *info = [[[FTInvocation alloc] init] autorelease];
    info->a = type1;
    info->b = type2;
    info.invocation = invocation;
	
	cpCollisionBeginFunc begin = NULL;
	cpCollisionPreSolveFunc preSolve = NULL;
	cpCollisionPostSolveFunc postSolve = NULL;
	cpCollisionSeparateFunc separate = NULL;
	
	va_list args;
	va_start(args, moment);
	
	while (moment != 0)
	{
		switch (moment)
		{
			case COLLISION_BEGIN:
				begin = collBegin;
				break;
			case COLLISION_PRESOLVE:
				preSolve = collPreSolve;
				break;
			case COLLISION_POSTSOLVE:
				postSolve = collPostSolve;
				break;
			case COLLISION_SEPARATE:
				separate = collSeparate;
				break;
			default:
				break;
		}
		moment = (CollisionMoment)va_arg(args, int);
	}
    
	va_end(args);
    
	//add the callback to chipmunk
	cpSpaceAddCollisionHandler(space, type1, type2, begin, preSolve, postSolve, separate, info);
	
	//we'll keep a ref so it won't disappear, prob could just retain and clear hash later
	[_invocations addObject:info];
}

-(void) removeCollisionCallbackBetweenType:(unsigned int)type1 otherType:(unsigned int)type2
{
	//Chipmunk hashes the invocation for us, we must pull it out
	cpCollisionTypePair *pair = (cpCollisionTypePair*)malloc(sizeof(cpCollisionTypePair));
    pair->a = type1;
    pair->b = type2;
	
	//delete the invocation, if there is one
	if ([self isSpaceLocked])
		cpSpaceAddPostStepCallback(space, removeCollision, (void*)pair, (void*)_invocations);
	else
		removeCollision(space, (void*)pair, (void*)_invocations);
}


@end
