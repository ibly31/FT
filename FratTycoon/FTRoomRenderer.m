//
//  FTRoomRenderer.m
//  FratTycoon
//
//  Created by Billy Connolly on 3/11/14.
//  Copyright (c) 2014 ibly31apps. All rights reserved.
//

#import "FTRoomRenderer.h"
#import "FTModel.h"

static FTRoomRenderer *renderer = nil;

@implementation FTRoomRenderer
@synthesize roomRenders;
@synthesize roomBlueprints;
@synthesize roomBlueprintsDecOnly;

- (id)init{
    if(self){
        self.roomRenders = [[NSMutableArray alloc] initWithCapacity: [[[[FTModel sharedModel] roomData] objectForKey:@"rooms"] count]];
        self.roomBlueprints = [[NSMutableArray alloc] initWithCapacity: [roomRenders count]];
        self.roomBlueprintsDecOnly = [[NSMutableArray alloc] initWithCapacity: [roomRenders count]];
        
        [self renderRoomsAsBlueprints: NO decorationsOnly: NO];
        [self renderRoomsAsBlueprints: YES decorationsOnly: NO];
        [self renderRoomsAsBlueprints: YES decorationsOnly: YES];
    }
    return self;
}

- (void)renderRoomsAsBlueprints:(BOOL)bp decorationsOnly:(BOOL)decOnly{
    for(NSDictionary *roomDef in [[[FTModel sharedModel] roomData] objectForKey:@"rooms"]){
        if(roomDef != nil){
            BOOL subs = ([roomDef objectForKey:@"xsubs"] != nil);
            int roomWidth = [[roomDef objectForKey:@"width"] intValue];
            int roomHeight = [[roomDef objectForKey:@"height"] intValue];
            
            CCRenderTexture *render = [[CCRenderTexture alloc] initWithWidth:roomWidth * 24 height:roomHeight * 24 pixelFormat:CCTexturePixelFormat_Default];
            [render begin];
            if(!decOnly)
                [self createWallRectangle:roomWidth height:roomHeight asBlueprint:bp];
            [self createDecorations:[roomDef objectForKey:@"decorations"] width:roomWidth height:roomHeight asBlueprint:bp];
            if(bp && !subs && [roomDef objectForKey:@"blueprintname"] != nil){
                CCLabelTTF *blueprintName = [[CCLabelTTF alloc] initWithString:[roomDef objectForKey:@"blueprintname"] fontName:@"Draftsman.ttf" fontSize:[[roomDef objectForKey:@"blueprintnamesize"] intValue]];
                [blueprintName setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 255)]];
                [blueprintName setPosition: CGPointFromString([roomDef objectForKey:@"blueprintnameloc"])];
                [blueprintName setScaleY: -1.0f];
                [blueprintName visit];
            }
            [render end];
            
            CCSprite *sprite = [[CCSprite alloc] initWithTexture: render.sprite.texture];
            
            if(subs){
                int xsubs = [[roomDef objectForKey: @"xsubs"] intValue];
                int ysubs = [[roomDef objectForKey: @"ysubs"] intValue];
                NSString *subflip = [roomDef objectForKey: @"subflip"];
                
                CCRenderTexture *actualRender = [[CCRenderTexture alloc] initWithWidth:roomWidth * xsubs * 24 height:roomHeight * ysubs * 24 pixelFormat:CCTexturePixelFormat_Default];
                [actualRender begin];
                
                CCLabelTTF *blueprintName = nil;
                if(bp && [roomDef objectForKey:@"blueprintname"] != nil){
                    blueprintName = [[CCLabelTTF alloc] initWithString:[roomDef objectForKey:@"blueprintname"] fontName:@"Draftsman.ttf" fontSize:[[roomDef objectForKey:@"blueprintnamesize"] intValue]];
                    [blueprintName setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 255)]];
                    [blueprintName setScaleY: -1.0f];
                }
                
                for(int x = 0; x < xsubs; x++){
                    for(int y = 0; y < ysubs; y++){
                        [sprite setPosition:ccp(x * [sprite boundingBox].size.width + [sprite boundingBox].size.width / 2, y * [sprite boundingBox].size.height + [sprite boundingBox].size.height / 2)];
                        if([subflip isEqualToString:@"vertical"] && y % 2){
                            [sprite setScaleX: 1.0f];
                            [sprite setScaleY: 1.0f];
                            [sprite visit];
                            
                            if(blueprintName != nil){
                                CGPoint bpnameloc = CGPointFromString([roomDef objectForKey:@"blueprintnameloc"]);
                                [blueprintName setPosition: ccp(bpnameloc.x + x * [sprite boundingBox].size.width, (y + 1) * [sprite boundingBox].size.height - bpnameloc.y)];
                                [blueprintName visit];
                            }
                        }else if([subflip isEqualToString:@"horizontal"] && x % 2){
                            [sprite setScaleX: -1.0f];
                            [sprite setScaleY: -1.0f];
                            [sprite visit];
                            
                            if(blueprintName != nil){
                                CGPoint bpnameloc = CGPointFromString([roomDef objectForKey:@"blueprintnameloc"]);
                                [blueprintName setPosition: ccp((x + 1) * [sprite boundingBox].size.width - bpnameloc.x, bpnameloc.y + y * [sprite boundingBox].size.height)];
                                [blueprintName visit];
                            }
                        }else{
                            [sprite setScaleX: 1.0f];
                            [sprite setScaleY: -1.0f];
                            [sprite visit];
                            
                            if(blueprintName != nil){
                                CGPoint bpnameloc = CGPointFromString([roomDef objectForKey:@"blueprintnameloc"]);
                                [blueprintName setPosition: ccp(bpnameloc.x + x * [sprite boundingBox].size.width, bpnameloc.y + y * [sprite boundingBox].size.height)];
                                [blueprintName visit];
                            }

                        }
                        
                    }
                }
                
                [actualRender end];
                NSMutableDictionary *roomDict = [roomDef mutableCopy];
                [roomDict setObject:actualRender.sprite.texture forKey:@"texture"];
                
                if(!bp)
                    [roomRenders addObject: roomDict];
                else if(!decOnly)
                    [roomBlueprints addObject: roomDict];
                else
                    [roomBlueprintsDecOnly addObject: roomDict];
            }else{
                NSMutableDictionary *roomDict = [roomDef mutableCopy];
                [roomDict setObject:render.sprite.texture forKey:@"texture"];
                
                if(!bp)
                    [roomRenders addObject: roomDict];
                else if(!decOnly)
                    [roomBlueprints addObject: roomDict];
                else
                    [roomBlueprintsDecOnly addObject: roomDict];
            }
            
        }
    }
}

- (NSDictionary *)roomRenderWithName:(NSString *)roomName{
    NSDictionary *render = nil;
    for(NSDictionary *dict in roomRenders){
        if([[dict objectForKey:@"name"] isEqualToString: roomName]){
            render = dict;
        }
    }
    return render;
}

- (NSDictionary *)roomBlueprintWithName:(NSString *)roomName{
    NSDictionary *render = nil;
    for(NSDictionary *dict in roomBlueprints){
        if([[dict objectForKey:@"name"] isEqualToString: roomName]){
            render = dict;
        }
    }
    return render;
}

- (NSDictionary *)roomBlueprintDecOnlyWithName:(NSString *)roomName{
    NSDictionary *render = nil;
    for(NSDictionary *dict in roomBlueprintsDecOnly){
        if([[dict objectForKey:@"name"] isEqualToString: roomName]){
            render = dict;
        }
    }
    return render;
}

- (void)createWallRectangle:(int)w height:(int)h asBlueprint:(BOOL)bp{
    /*CCSprite *tile = [[CCSprite alloc] initWithFile:@"TextureMap.png" rect:CGRectMake(0, 150, 24, 24)];
    for(int x = 0; x < w; x++){
        for(int y = 0; y < h; y++){
            [tile setPosition: ccp(x * 24 + 12, y * 24 + 12)];
            [tile visit];
        }
    }*/

    int offset = bp ? 26 : 0;
    
    CCSprite *wallPiece = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"WallPieces.png"] rect:CGRectMake(78, offset, 12, 12)];
    [wallPiece setScaleY: -1.0f];
    [wallPiece setPosition: ccp(6, 6)];
    [wallPiece visit];
    [wallPiece setTextureRect: CGRectMake(91, offset, 12, 12)];
    [wallPiece setPosition: ccp(w * 24 - 6, 6)];
    [wallPiece visit];
    [wallPiece setTextureRect: CGRectMake(65, offset, 12, 12)];
    [wallPiece setPosition: ccp(6, h * 24 - 6)];
    [wallPiece visit];
    [wallPiece setTextureRect: CGRectMake(104, offset, 12, 12)];
    [wallPiece setPosition: ccp(w * 24 - 6, h * 24 - 6)];
    [wallPiece visit];
    
    [wallPiece setTextureRect:CGRectMake(130, offset, 12, 12)];
    for(int x = 1; x < w * 2 - 1; x++){
        [wallPiece setPosition: ccp(x * 12 + 6, 6)];
        [wallPiece visit];
        
        [wallPiece setPosition: ccp(x * 12 + 6, (h * 24) - 6)];
        [wallPiece visit];
    }
    
    [wallPiece setTextureRect: CGRectMake(117, offset, 12, 12)];
    for(int y = 1; y < h * 2 - 1; y++){
        [wallPiece setPosition: ccp(6, y * 12 + 6)];
        [wallPiece visit];
        
        [wallPiece setPosition: ccp((w * 24) - 6, y * 12 + 6)];
        [wallPiece visit];
    }
}

- (void)createDecorations:(NSArray *)decorations width:(int)w height:(int)h asBlueprint:(BOOL)bp{
    for(int x = 0; x < [decorations count]; x++){
        NSDictionary *decoration = [decorations objectAtIndex: x];
        if([decoration objectForKey: @"decName"] != nil ){
            NSString *decName = [decoration objectForKey:@"decName"];
            int decX = [[decoration objectForKey:@"x"] intValue];
            int decY = [[decoration objectForKey:@"y"] intValue];
            int decRot = [[decoration objectForKey:@"rot"] intValue];
            NSDictionary *decorationDict = [[FTModel sharedModel] decorationWithName:decName];
            
            CGRect displayRect = CGRectFromString([decorationDict objectForKey:@"displayrect"]);
            displayRect = CGRectMake(displayRect.origin.x / 2, displayRect.origin.y / 2, displayRect.size.width / 2, displayRect.size.height / 2);
            
            NSString *decorationsFile = bp ? @"DecorationsBlueprint.png" : @"Decorations.png";
            
            CCSprite *decorationSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:decorationsFile] rect:displayRect];
            
            [decorationSprite setPosition: ccp(decX, decY)];
            [decorationSprite setRotation: decRot];
            [decorationSprite setScaleY: -1.0f];
            
            [decorationSprite visit];
        }
    }
}

+ (id)sharedRenderer{
    @synchronized(self){
        if(renderer == nil)
            renderer = [[self alloc] init];
    }
    return renderer;
}

@end
