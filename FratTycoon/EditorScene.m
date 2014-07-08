//
//  EditorScene.m
//  FratTycoon
//
//  Created by Billy Connolly on 3/13/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "EditorScene.h"
#import "FTModel.h"
#import "FTEditorBlueprint.h"
#import "GameScene.h"

@implementation EditorScene

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	EditorScene *node = [EditorScene node];
	[scene addChild: node];
	return scene;
}

- (id)init{
    self = [super init];
    if(self){
        CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(100, 100, 100, 255)]];
        [self addChild: background z:0];
        
        FTEditorBlueprint *blueprint = [[FTEditorBlueprint alloc] initWithWidth:HOUSELOT_WIDTH height:HOUSELOT_HEIGHT];
        [blueprint setAnchorPoint: ccp(0,1)];
        
        structureNode = [[FTStructureNode alloc] initWithWidth:HOUSELOT_WIDTH * 2 height:HOUSELOT_HEIGHT * 2 blueprint:YES];
        [structureNode setScale: EDITOR_SCALE];
        
        house = [[CCNode alloc] init];
        [house addChild: blueprint];
        [house addChild: structureNode];
        
        levels = CFBridgingRelease(CFPropertyListCreateDeepCopy(nil, (CFPropertyListRef)[[[FTModel sharedModel] currentHouseData] objectForKey:@"levels"], kCFPropertyListMutableContainersAndLeaves));
        
        currentLevel = 0;
        [self readCurrentLevel];
        
        [self updateStructureNode];
        
        [house setPosition: ccp(12, 70)];
        [self addChild: house z:2];
       
        roomPicker = [[FTEditorRoomPicker alloc] initWithEditorScene: self];
        [self addChild: roomPicker z:2];
        
        deleteIcon = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(0, 0, 40, 40)];
        [deleteIcon setVisible: NO];
        [self addChild: deleteIcon z:5];
        
        moveIcon = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(42, 0, 40, 40)];
        [moveIcon setVisible: NO];
        [self addChild: moveIcon z:5];
        
        rotateLeftSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(84, 0, 40, 40)];
        [rotateLeftSprite setPosition: ccp(25, 165)];
        [rotateLeftSprite setOpacity: 0];
        [self addChild: rotateLeftSprite z:5];
        
        rotateRightSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(84, 0, 40, 40)];
        [rotateRightSprite setPosition: ccp([[CCDirector sharedDirector] viewSize].width - 25, 165)];
        [rotateRightSprite setOpacity: 0];
        [rotateRightSprite setScaleX: -1.0f];
        [self addChild: rotateRightSprite z:5];
        
        CCNodeColor *topBarBackground = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b: ccc4(200, 200, 200, 200)] width:[[CCDirector sharedDirector] viewSize].width height:60];
        [topBarBackground setPosition: ccp(0, [[CCDirector sharedDirector] viewSize].height - 60)];
        //[self addChild: topBarBackground z:6];
        
        backButton = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(128, 0, 70, 34)];
        [backButton setPosition: ccp(39, [[CCDirector sharedDirector] viewSize].height - 39)];
        [self addChild: backButton z: 7];
        
        /*NSMutableArray *levelMenuArray = [[NSMutableArray alloc] init];
        int index = 0;
        for(NSDictionary *level in levels){
            CCLabelTTF *menuItemLabel = [[CCLabelTTF alloc] initWithString:[level objectForKey:@"levelName"] fontName:@"Palatino" fontSize:24.0f];
            CCMenuItemLabel *menuItem = [[CCMenuItemLabel alloc] initWithLabel:menuItemLabel target:self selector:@selector(levelMenuTap:)];
            [menuItem setAnchorPoint: ccp(0, 0.5)];
            [menuItem setPosition: ccp(0, 28 * index)];
            [menuItem setTag: index + LEVELMENU_TAG_OFFSET];
            
            [levelMenuArray addObject: menuItem];
            
            CCSprite *numberBoxSprite = [[CCSprite alloc] initWithFile:@"GUI.png" rect:CGRectMake(220 + 20 * index, 0, 20, 20)];
            [numberBoxSprite setAnchorPoint: ccp(0, 0.5)];
            [numberBoxSprite setPosition: ccp(2, 162 + index * 28)];
            [numberBoxSprite setTag: index + LEVELMENU_TAG_OFFSET];
            [self addChild: numberBoxSprite z: 8];
            
            if(index == currentLevel){
                [menuItem setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 0)]];
                [numberBoxSprite setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 0)]];
            }
            index++;
        }
        
        levelMenu = [[CCMenu alloc] initWithArray: levelMenuArray];
        [levelMenu setPosition: ccp(24, 160)];
        [self addChild: levelMenu z: 8];*/
        
        [self setContentSize: [[CCDirector sharedDirector] viewSize]];
        [self setUserInteractionEnabled: YES];
        
        currentSelectedRoom = nil;
        panOffset = [house position];
        panStartLocation = ccp(0, 0);
        panning = NO;
        iconsUp = NO;
        dropping = NO;
        justRotated = NO;
    }
    return self;
}

- (void)readCurrentLevel{
    currentRooms = [[NSMutableArray alloc] init];
    
    int roomID = 0;
    for(NSMutableDictionary *room in [[levels objectAtIndex: currentLevel] objectForKey: @"rooms"]){
        NSMutableDictionary *roomDef = [[[FTModel sharedModel] roomWithName: [room objectForKey:@"roomName"]] mutableCopy];
        
        NSDictionary *roomRender = [[FTRoomRenderer sharedRenderer] roomBlueprintDecOnlyWithName: [roomDef objectForKey:@"name"]];
        CCSprite *roomSprite = [[CCSprite alloc] initWithTexture: [roomRender objectForKey:@"texture"]];
        [roomSprite setScale: EDITOR_SCALE];
        [roomSprite setOpacity: 0];
        [roomSprite runAction: [CCActionFadeIn actionWithDuration: 0.4f]];
        
        int roomX = [[room objectForKey: @"x"] intValue];
        int roomY = [[room objectForKey: @"y"] intValue];
        int roomRot = [[room objectForKey: @"rot"] intValue];
        int roomWidth = [[roomDef objectForKey:@"width"] intValue];
        int roomHeight = [[roomDef objectForKey:@"height"] intValue];
        int roomXSubs = 1;
        int roomYSubs = 1;
        if([roomDef objectForKey:@"xsubs"] != nil)
            roomXSubs = [[roomDef objectForKey:@"xsubs"] intValue];
        if([roomDef objectForKey:@"ysubs"] != nil)
            roomXSubs = [[roomDef objectForKey:@"ysubs"] intValue];
        
        roomWidth *= roomXSubs;
        roomHeight *= roomYSubs;
        
        [roomDef setObject:[NSNumber numberWithInt:roomX] forKey:@"x"];
        [roomDef setObject:[NSNumber numberWithInt:roomY] forKey:@"y"];
        [roomDef setObject:[NSNumber numberWithInt:roomRot] forKey:@"rot"];
        
        [roomSprite setRotation: roomRot];
        [roomSprite setPosition: ccp(roomX * 24 * EDITOR_SCALE + [roomSprite boundingBox].size.width / 2, (HOUSELOT_HEIGHT - roomY) * 24 * EDITOR_SCALE - [roomSprite boundingBox].size.height / 2)];
        [roomDef setObject:roomSprite forKey:@"sprite"];
        [currentRooms addObject: roomDef];
        [house addChild: roomSprite];
        
        roomID++;
    }
}

- (void)levelMenuTap:(CCNode *)sender{
    int nextLevel = [sender.name intValue] - LEVELMENU_TAG_OFFSET;
    if(nextLevel != currentLevel){
        [self saveCurrentLevel];
        
        /*for(CCMenuItem *item in [levelMenu children]){
            CCSprite *boxSprite = nil;
            for(CCNode *child in [self children])
                if(child.tag == item.tag)
                    boxSprite = (CCSprite *)child;
            
            if(item.tag != sender.tag){
                [item setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 255)]];
                [boxSprite setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 255)]];
            }else{
                [item setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 0)]];
                [boxSprite setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 0)]];
            }
        }*/
        
        currentLevel = nextLevel;
        
        [structureNode fadeTilesInAndOut];
        for(NSDictionary *room in currentRooms){
            [[room objectForKey: @"sprite"] runAction: [CCActionFadeOut actionWithDuration: 0.4f]];
        }
        
        [self scheduleOnce:@selector(readCurrentLevel) delay:0.4f];
        [self scheduleOnce:@selector(updateStructureNode) delay:0.4f];
    }
}

int wrapAndAddAngle(int angle, int add){
    int toRot = ((int)angle / 90) * 90 + add;
    if(toRot > 0)
        toRot = toRot % 360;
    else if(toRot < 0)
        toRot = (toRot % -360);
    if(toRot < 0)
        toRot += 360;
    return toRot;
}

- (void)saveCurrentLevel{
    NSMutableArray *roomArray = [[NSMutableArray alloc] init];
    for(NSDictionary *room in currentRooms){
        NSDictionary *houseRoom = [[NSDictionary alloc] initWithObjectsAndKeys:[room objectForKey:@"name"], @"roomName", [room objectForKey: @"x"], @"x", [room objectForKey: @"y"], @"y", [room objectForKey: @"rot"], @"rot", nil];
        [roomArray addObject: houseRoom];
    }
    
    [[levels objectAtIndex: currentLevel] setObject:roomArray forKey:@"rooms"];
    
    NSMutableDictionary *houseData = [[NSMutableDictionary alloc] initWithObjectsAndKeys:levels, @"levels", nil];
    [[FTModel sharedModel] setCurrentHouseData: houseData];

}

- (void)beginDragDropFrom:(CGPoint)from to:(CGPoint)to withStartScale:(float)startScale withRoomName:(NSString *)roomName{
    dropping = YES;
    NSDictionary *roomDict = [[FTRoomRenderer sharedRenderer] roomBlueprintWithName: roomName];
    dropRoomDict = roomDict;
    lastDropTouch = to;
    dropRoomToRot = 0;
    
    dropRoom = [[CCSprite alloc] initWithTexture: [roomDict objectForKey:@"texture"]];
    [dropRoom setScale: startScale];
    [dropRoom runAction: [CCActionScaleTo actionWithDuration:0.1f scale:EDITOR_SCALE]];
    [dropRoom setPosition: from];
    [dropRoom runAction: [CCActionMoveTo actionWithDuration:0.05f position:to]];
    [self addChild: dropRoom z:3];
    
    [rotateLeftSprite runAction: [CCActionFadeIn actionWithDuration: 0.15f]];
    [rotateRightSprite runAction: [CCActionFadeIn actionWithDuration: 0.15f]];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];

    if(loc.y > 140){ // not tapping picker
        if(dropping){
            if(CGRectContainsPoint([rotateLeftSprite boundingBox], loc)){
                dropRoomToRot = wrapAndAddAngle([dropRoom rotation], -90);
                [dropRoom runAction: [CCActionRotateTo actionWithDuration:0.1f angle:dropRoomToRot]];
                justRotated = YES;
            }else if(CGRectContainsPoint([rotateRightSprite boundingBox], loc)){
                dropRoomToRot = wrapAndAddAngle([dropRoom rotation], 90);
                [dropRoom runAction: [CCActionRotateTo actionWithDuration:0.1f angle:dropRoomToRot]];
                justRotated = YES;
            }
            if(justRotated){
                CGPoint houseLoc = [house convertToNodeSpace: [dropRoom position]];
                int rw = [[dropRoomDict objectForKey:@"width"] intValue];
                int rh = [[dropRoomDict objectForKey:@"height"] intValue];
                
                if(dropRoomToRot == 90 || dropRoomToRot == -90 || dropRoomToRot == 270){
                    int temp = rw;
                    rw = rh;
                    rh = temp;
                }
                
                houseLoc = ccp(((int)houseLoc.x / (int)(24 * EDITOR_SCALE)) * (24.0f * EDITOR_SCALE), ((int)houseLoc.y / (int)(24 * EDITOR_SCALE)) * (24.0f * EDITOR_SCALE)); // snap to grid
                
                // if room is odd width or odd height, move it back to grid
                if(rw % 2){
                    houseLoc.x += 24.0f * EDITOR_SCALE * 0.5f;
                }
                
                if(rh % 2){
                    houseLoc.y += 24.0f * EDITOR_SCALE * 0.5f;
                }
                
                [dropRoom runAction: [CCActionMoveTo actionWithDuration:0.05f position:ccpAdd([house position], houseLoc)]];
            }
        }else{
            tapTime = CFAbsoluteTimeGetCurrent();
            panStartLocation = loc;
            panning = YES;
        }
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if(panning){
        if(iconsUp){
            [self hideIcons];
        }
        if(ccpDistance(loc, panStartLocation) > 10.0f){
            [house setPosition: ccpAdd(panOffset, ccpSub(loc, panStartLocation))];
        }
    }else if(dropping){
        // Make sure touch is one on top of room
        
        if(ccpDistance(loc, lastDropTouch) < 100){
            CGPoint houseLoc = [house convertToNodeSpace: loc];
            int rw = [[dropRoomDict objectForKey:@"width"] intValue];
            int rh = [[dropRoomDict objectForKey:@"height"] intValue];
            
            if(dropRoomToRot == 90 || dropRoomToRot == -90 || dropRoomToRot == 270){
                int temp = rw;
                rw = rh;
                rh = temp;
            }
            
            //houseLoc.y += rh * 24.0f * EDITOR_SCALE * 0.5f; // move up so small rooms aren't hidden under finger
            
            houseLoc = ccp(((int)houseLoc.x / (int)(24 * EDITOR_SCALE)) * (24.0f * EDITOR_SCALE), ((int)houseLoc.y / (int)(24 * EDITOR_SCALE)) * (24.0f * EDITOR_SCALE)); // snap to grid
            
            // if room is odd width or odd height, move it back to grid
            if(rw % 2){
                houseLoc.x += 24.0f * EDITOR_SCALE * 0.5f;
            }
            
            if(rh % 2){
                houseLoc.y += 24.0f * EDITOR_SCALE * 0.5f;
            }
            
            [dropRoom setPosition: ccpAdd([house position], houseLoc)];
            
            if(loc.y < 100){
                [dropRoom setOpacity: 125];
            }else{
                [dropRoom setOpacity: 255];
            }
            lastDropTouch = loc;
        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];

    if(panning){
        if(CFAbsoluteTimeGetCurrent() - tapTime < 0.25 && ccpLength(ccpSub(loc, panStartLocation)) < 10){
            if([[CCDirector sharedDirector] viewSize].height - loc.y < 40){
                if(CGRectContainsPoint([backButton boundingBox], loc)){
                    [self saveCurrentLevel];
                    [[CCDirector sharedDirector] replaceScene:[GameScene scene] withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
                }
            }else{
                CGPoint houseLoc = [house convertToNodeSpace: loc];
                
                if(iconsUp){
                    if(CGRectContainsPoint([deleteIcon boundingBox], loc)){
                        if(currentSelectedRoom){
                            [house removeChild:[currentSelectedRoom objectForKey:@"sprite"]];
                            [currentRooms removeObject:currentSelectedRoom];
                            
                            [self updateStructureNode];
                            
                            [self hideIcons];
                        }
                    }else if(CGRectContainsPoint([moveIcon boundingBox], loc)){
                        NSLog(@"Move icon");
                    }else{
                        [self hideIcons];
                    }
                }else{
                    CCSprite *roomSpriteTap = nil;

                    for(CCNode *child in [house children]){
                        if([child isKindOfClass: [CCSprite class]]){
                            if(CGRectContainsPoint([child boundingBox], houseLoc))
                                roomSpriteTap = (CCSprite *)child;
                        }
                    }
                    
                    if(roomSpriteTap != nil){
                        for(NSDictionary *room in currentRooms){
                            if([room objectForKey:@"sprite"] == roomSpriteTap){
                                CCActionSequence *pulse = [CCActionSequence actionWithArray: @[[CCActionTintTo actionWithDuration:0.25f color:[CCColor colorWithCcColor3b:ccc3(255, 155, 155)]], [CCActionTintTo actionWithDuration:0.25f color:[CCColor whiteColor]]]];
                                [roomSpriteTap runAction: pulse];
                                
                                currentSelectedRoom = room;
                                [self showIconsFrom: loc];
                            }
                        }
                    }
                }
            }
        }
        
        panOffset = [house position];
        panning = NO;
    }else if(dropping){
        if(loc.y > 100){
            // Make sure touch is one on top of room

            if(ccpDistance(loc, lastDropTouch) < 100){
                dropping = NO;
                
                int rot = dropRoomToRot;
                if(rot > 360)
                    rot = rot % 360;
                else if(rot < 0)
                    rot = (rot % -360) + 360;
                
                CGRect bounding = [dropRoom boundingBox];
                bounding.origin = [house convertToNodeSpace: bounding.origin];
                CGPoint upperCorner = ccp(roundf(bounding.origin.x / (24.0f * EDITOR_SCALE)), roundf(HOUSELOT_HEIGHT - (bounding.origin.y + bounding.size.height) / (24.0f * EDITOR_SCALE)));
                
                NSDictionary *blueprintDecOnlyRender = [[FTRoomRenderer sharedRenderer] roomBlueprintDecOnlyWithName: [dropRoomDict objectForKey:@"name"]];

                CCSprite *newRoomSprite = [[CCSprite alloc] initWithTexture: [blueprintDecOnlyRender objectForKey:@"texture"]];
                [newRoomSprite setScale: EDITOR_SCALE];
                [newRoomSprite setPosition: [house convertToNodeSpace: [dropRoom position]]];
                [newRoomSprite setRotation: rot];
                
                NSMutableDictionary *newRoom = [[[FTModel sharedModel] roomWithName: [dropRoomDict objectForKey: @"name"]] mutableCopy];
                [newRoom setObject:newRoomSprite forKey:@"sprite"];
                [newRoom setObject:[NSNumber numberWithInt:upperCorner.x] forKey:@"x"];
                [newRoom setObject:[NSNumber numberWithInt:upperCorner.y] forKey:@"y"];
                [newRoom setObject:[NSNumber numberWithInt:rot] forKey:@"rot"];
                [currentRooms addObject: newRoom];
                
                [house addChild: newRoomSprite];
                
                [self updateStructureNode];
                                
                [rotateLeftSprite runAction: [CCActionFadeOut actionWithDuration: 0.15f]];
                [rotateRightSprite runAction: [CCActionFadeOut actionWithDuration: 0.15f]];
                [dropRoom setVisible: NO];
            }else{
                justRotated = NO;
            }
        }else{
            [rotateLeftSprite runAction: [CCActionFadeOut actionWithDuration: 0.15f]];
            [rotateRightSprite runAction: [CCActionFadeOut actionWithDuration: 0.15f]];
            [dropRoom setVisible: NO];
            dropping = NO;
        }
    }
}

- (void)updateStructureNode{
    [structureNode clearAllTiles];
    
    int roomID = 0;
    for(NSMutableDictionary *room in currentRooms){
        int roomX = [[room objectForKey: @"x"] intValue];
        int roomY = [[room objectForKey: @"y"] intValue];
        int roomW = [[room objectForKey: @"width"] intValue];
        int roomH = [[room objectForKey: @"height"] intValue];
        int roomRot = [[room objectForKey: @"rot"] intValue];
        
        if(roomRot == 90 || roomRot == -90 || roomRot == 270){
            int temp = roomW;
            roomW = roomH;
            roomH = temp;
        }
        
        BOOL subs = ([room objectForKey:@"xsubs"] != nil);
        
        if(subs){
            int xsubs = [[room objectForKey: @"xsubs"] intValue];
            int ysubs = [[room objectForKey: @"ysubs"] intValue];
            
            if(roomRot == 90 || roomRot == -90 || roomRot == 270){
                int temp = xsubs;
                xsubs = ysubs;
                ysubs = temp;
            }
            
            for(int x = 0; x < xsubs; x++){
                for(int y = 0; y < ysubs; y++){
                    [structureNode createWallRectangle:roomX + x * roomW y:roomY + y * roomH width:roomW height:roomH roomID:roomID roomName:[room objectForKey:@"name"]];
                }
            }
        }else{
            [structureNode createWallRectangle:roomX y:roomY width:roomW height:roomH roomID:roomID roomName:[room objectForKey:@"name"]];
        }
        
        roomID++;
    }

    [structureNode removeDoorways: currentRooms];
    [structureNode removeDoubleWalls: currentRooms];
    [structureNode removeSingles];
    [structureNode correctWallOrientations];
}

- (void)showIconsFrom:(CGPoint)pt{
    iconsUp = YES;
    
    [deleteIcon setScale: 0];
    [moveIcon setScale: 0];
    [deleteIcon setPosition: pt];
    [moveIcon setPosition: pt];
    [deleteIcon setOpacity: 0];
    [moveIcon setOpacity: 0];
    
    [deleteIcon setVisible: YES];
    [moveIcon setVisible: YES];
    
    [deleteIcon runAction: [CCActionScaleTo actionWithDuration:0.25f scale:1.0f]];
    [moveIcon runAction: [CCActionScaleTo actionWithDuration:0.25f scale:1.0f]];
    [deleteIcon runAction: [CCActionFadeIn actionWithDuration: 0.25f]];
    [moveIcon runAction: [CCActionFadeIn actionWithDuration: 0.25f]];
    [deleteIcon runAction: [CCActionMoveBy actionWithDuration:0.25f position: ccp(-25, 0)]];
    [moveIcon runAction: [CCActionMoveBy actionWithDuration:0.25f position: ccp(25, 0)]];
}

- (void)hideIcons{
    iconsUp = NO;
    currentSelectedRoom = nil;
    
    [deleteIcon setScale: 1];
    [moveIcon setScale: 1];
    [deleteIcon setOpacity: 255];
    [moveIcon setOpacity: 255];
    
    [deleteIcon runAction: [CCActionScaleTo actionWithDuration:0.25f scale:0.0f]];
    [moveIcon runAction: [CCActionScaleTo actionWithDuration:0.25f scale:0.0f]];
    [deleteIcon runAction: [CCActionFadeOut actionWithDuration: 0.25f]];
    [moveIcon runAction: [CCActionFadeOut actionWithDuration: 0.25f]];
    [deleteIcon runAction: [CCActionMoveBy actionWithDuration:0.25f position:ccp(25, 0)]];
    [moveIcon runAction: [CCActionMoveBy actionWithDuration:0.25f position:ccp(-25, 0)]];
    
    [self scheduleOnce:@selector(setIconsInvisible) delay:0.25f];
}

- (void)setIconsInvisible{
    [deleteIcon setVisible: NO];
    [moveIcon setVisible: NO];
}

@end
