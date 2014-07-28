//
//  FTDecorationNode.h
//  FratTycoon
//
//  Created by Billy Connolly on 2/13/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define MAX_DECORATIONS 100

@interface FTDecorationNode : CCNode {
    int width;
    int height;
    
    CCSpriteBatchNode *sprites;
    
    NSMutableArray *decorations;
}

- (id)init;

@property int width;
@property int height;
@property (nonatomic, retain) NSMutableArray *decorations;

- (void)clearDecorations;
- (void)addDecoration:(NSDictionary *)decoration x:(int)x y:(int)y rot:(int)rot flipVertical:(BOOL)flipVertical flipHorizontal:(BOOL)flipHorizontal;
- (NSMutableDictionary *)decorationFromSequentialLink:(NSDictionary *)decDict;
- (NSMutableDictionary *)decorationFromName:(NSString *)name adjacentTo:(NSDictionary *)decDict;

@end
