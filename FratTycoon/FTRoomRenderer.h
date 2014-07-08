//
//  FTRoomRenderer.h
//  FratTycoon
//
//  Created by Billy Connolly on 3/11/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"

@interface FTRoomRenderer : NSObject{
    NSMutableArray *roomRenders;
    NSMutableArray *roomBlueprints;
    NSMutableArray *roomBlueprintsDecOnly;
}

+ (id)sharedRenderer;

@property (nonatomic, retain) NSMutableArray *roomRenders;
@property (nonatomic, retain) NSMutableArray *roomBlueprints;
@property (nonatomic, retain) NSMutableArray *roomBlueprintsDecOnly;

- (NSDictionary *)roomRenderWithName:(NSString *)roomName;
- (NSDictionary *)roomBlueprintWithName:(NSString *)roomName;
- (NSDictionary *)roomBlueprintDecOnlyWithName:(NSString *)roomName;

@end
