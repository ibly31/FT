//
//  EditorScene.h
//  FratTycoon
//
//  Created by Billy Connolly on 3/13/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"
#import "FTEditorRoomPicker.h"
#import "FTConstants.h"
#import "FTStructureNode.h"

#define EDITOR_SCALE 0.66666666666666666666667
#define LEVELMENU_TAG_OFFSET 20

@interface EditorScene : CCNode {
    FTEditorRoomPicker *roomPicker;
    
    //CCMenu *levelMenu;
    
    NSMutableArray *levels;
    
    NSMutableArray *currentRooms;
    NSDictionary *currentSelectedRoom;
    int currentLevel;
    
    CCSprite *backButton;
    
    CCSprite *deleteIcon;
    CCSprite *moveIcon;
    
    CCSprite *rotateLeftSprite;
    CCSprite *rotateRightSprite;
    
    CGPoint panStartLocation;
    NSTimeInterval tapTime;
    CGPoint panOffset;
    
    BOOL panning;
    BOOL iconsUp;
    BOOL justRotated;
    
    BOOL dropping;
    int dropRoomToRot;
    CCSprite *dropRoom;
    NSDictionary *dropRoomDict;
    CGPoint lastDropTouch;
    
    CCNode *house;
    FTStructureNode *structureNode;
}

+ (CCScene *) scene;

- (void)readCurrentLevel;
- (void)levelMenuTap:(CCNode *)sender;
- (void)saveCurrentLevel;

- (void)beginDragDropFrom:(CGPoint)from to:(CGPoint)to withStartScale:(float)startScale withRoomName:(NSString *)roomName;

@end
