//
//  FTTrashNode.h
//  FratTycoon
//
//  Created by Billy Connolly on 7/24/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

#define MAX_TRASH 2500

typedef enum{
    FTTrashCan = 0,
    FTTrashCup,
    FTTrashBottle
}FTTrashType;

@interface FTTrashNode : CCSpriteBatchNode{
    NSInteger currentTrash;
    ChipmunkSpace *space;
}

- (id)initWithChipmunkSpace:(ChipmunkSpace *)s;

- (void)addNewTrash:(FTTrashType)type from:(CGPoint)from to:(CGPoint)to;

@end
