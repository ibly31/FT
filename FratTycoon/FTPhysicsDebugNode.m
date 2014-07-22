//
//  FTPhysicsDebugNode.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/18/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTPhysicsDebugNode.h"

@implementation FTPhysicsDebugNode
@synthesize space;

- (void)drawRect:(CGRect)rect color:(CCColor *)color{
    [self drawSegmentFrom:rect.origin to:ccp(rect.origin.x + rect.size.width, rect.origin.y) radius:1 color:color];
    [self drawSegmentFrom:ccp(rect.origin.x + rect.size.width, rect.origin.y) to:ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height) radius:1 color:color];
    [self drawSegmentFrom:ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height) to:ccp(rect.origin.x, rect.origin.y + rect.size.height) radius:1 color:color];
    [self drawSegmentFrom:ccp(rect.origin.x, rect.origin.y + rect.size.height) to:rect.origin radius:1 color:color];
}

- (void)drawCircle:(CGPoint)pt radius:(float)rad color:(CCColor *)color{
    CGPoint verts[CIRCLE_NUM_VERTS];
    for(int i = 0; i < CIRCLE_NUM_VERTS; i++){
        float angle = (2 * M_PI * i) / (float)CIRCLE_NUM_VERTS;
        verts[i] = ccp(pt.x + rad * cosf(angle), pt.y + rad * sinf(angle));
    }
    
    [self drawPolyWithVerts:&verts[0] count:CIRCLE_NUM_VERTS fillColor:[CCColor clearColor] borderWidth:1.0f borderColor:color];
}

- (void)update:(CCTime)delta{
    [self clear];
    for(ChipmunkShape *shape in [space shapes]){
        if([shape isKindOfClass: [ChipmunkCircleShape class]]){
            cpBB boundingBox = [shape bb];
            float radius = (boundingBox.r - boundingBox.l) / 2.0f;
            [self drawCircle:ccp(boundingBox.l + radius, boundingBox.b + radius) radius:radius color:[CCColor greenColor]];
        }else{
            cpBB boundingBox = [shape bb];
            CGRect boundingBoxRect = CGRectMake(boundingBox.l, boundingBox.b, boundingBox.r - boundingBox.l, boundingBox.t - boundingBox.b);
            [self drawRect:boundingBoxRect color:[CCColor greenColor]];
        }
    }
}

@end
