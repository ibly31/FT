//
//  FTTrashNode.m
//  FratTycoon
//
//  Created by Billy Connolly on 7/24/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTTrashNode.h"

@implementation FTTrashNode

- (id)initWithChipmunkSpace:(ChipmunkSpace *)s{
    self = [super initWithFile:@"PeopleSheet.png" capacity:MAX_TRASH];
    space = s;
    currentTrash = 0;
    return self;
}

- (void)addNewTrash:(FTTrashType)type from:(CGPoint)from to:(CGPoint)to{
    CCSprite *trashSprite = nil;
    
    NSArray *queryObjects = [space segmentQueryAllFrom:from to:to radius:3 filter:cpShapeFilterNew(CP_NO_GROUP, CP_ALL_CATEGORIES, CP_ALL_CATEGORIES)];
    float shortestAlpha = 1.0f;
    
    if([queryObjects count] > 0){
        for(int i = 0; i < [queryObjects count]; i++){
            ChipmunkSegmentQueryInfo *info = [queryObjects objectAtIndex: i];
            cpSegmentQueryInfo *infoStruct = [info info];
            
            if(infoStruct->alpha < shortestAlpha){
                shortestAlpha = infoStruct->alpha;
                if(shortestAlpha == 0)
                    break;
            }
        }
        
        to = cpvlerp(from, to, shortestAlpha);
    }
    
    if(currentTrash < MAX_TRASH){
        trashSprite = [CCSprite spriteWithTexture:self.texture rect:CGRectMake(125 + type * 10, 10, 8, 13)];
        [self addChild: trashSprite];
    }else{
        trashSprite = [[self children] objectAtIndex: (currentTrash % MAX_TRASH)];
    }
    
    [trashSprite setPosition: from];
    [trashSprite setRotation: CCRANDOM_0_1() * 360];
    [trashSprite setScale: CCRANDOM_MINUS1_1() * 0.2f + 1.0f];
    [trashSprite setColor: [CCColor colorWithWhite:CCRANDOM_0_1() * 0.2 + 0.8f alpha:1.0f]];
    
    [trashSprite runAction: [CCActionMoveTo actionWithDuration:0.2f position:to]];
    [trashSprite runAction: [CCActionSequence actionOne:[CCActionScaleTo actionWithDuration:0.1f scale:1.4f] two:[CCActionScaleTo actionWithDuration:0.1f scale:1.0f]]];
    [trashSprite runAction: [CCActionRotateTo actionWithDuration:0.2f angle:CCRANDOM_0_1() * 360]];
    
    currentTrash++;

}

@end
