//
//  FTLevelStack.h
//  FratTycoon
//
//  Created by Billy Connolly on 5/26/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"

#define kMenuTagOffset 20

@protocol FTLevelStackDelegate <NSObject>

- (void)changeLevel:(int)level;

@end

@interface FTLevelStack : CCNode {
    int currentLevel;
    CCNode<FTLevelStackDelegate> *delegate;
}

- (id)initWithLevels:(NSArray *)l;

@property (nonatomic, retain) CCNode<FTLevelStackDelegate> *delegate;

- (void)changeLevel:(CCNode *)sender;
- (void)setCurrentLevel:(int)level;

@end
