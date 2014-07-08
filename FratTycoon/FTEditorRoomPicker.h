//
//  FTEditorRoomPicker.h
//  FratTycoon
//
//  Created by Billy Connolly on 3/13/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"
#import "FTRoomRenderer.h"

@class EditorScene;

@interface FTEditorRoomPicker : CCNode {
    FTRoomRenderer *renderer;
    
    CGPoint dragStartLocation;
    NSTimeInterval tapTime;
    CGPoint dragOffset;
    
    BOOL dragging;
    BOOL movedPast;
    
    CCNode *slider;
    CGSize sliderSize;
    
    EditorScene *editorScene;
}

- (id)initWithEditorScene:(EditorScene *)es;

@end
