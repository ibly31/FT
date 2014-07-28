//
//  FTHouseNode.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/12/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTHouseNode.h"
#import "FTStructureNode.h"
#import "FTModel.h"

@implementation FTHouseNode
@synthesize peopleNode;
@synthesize decorationNode;
@synthesize structureNode;
@synthesize trashNode;
@synthesize floorMapNode;
@synthesize currentRooms;
@synthesize gameScene;
@synthesize width;
@synthesize height;

- (id)initWithGameScene:(GameScene *)gs{
    self = [super init];
    if(self){
        self.gameScene = gs;
        
        background = [[CCNodeColor alloc] initWithColor:[CCColor grayColor] width:HOUSELOT_WIDTH * 24 height:HOUSELOT_HEIGHT * 24];
        [self addChild:background z:0];
        
        self.structureNode = [[FTStructureNode alloc] initWithWidth:HOUSELOT_WIDTH * 2 height:HOUSELOT_HEIGHT * 2 blueprint:NO];
        
        self.width = HOUSELOT_WIDTH;
        self.height = HOUSELOT_HEIGHT;
        self.floorMapNode = [[FTStructureNode alloc] initWithWidth:HOUSELOT_WIDTH height:HOUSELOT_HEIGHT range:NSRangeFromString(@"60-4")];
        self.decorationNode = [[FTDecorationNode alloc] init];
        
        currentLevel = 0;
        self.currentRooms = nil;
        [self readHouseData: [[FTModel sharedModel] currentHouseData]];
        
        self.peopleNode = [[FTPeopleNode alloc] init];
        [peopleNode setHouseNode: self];
        [peopleNode setDecorationNode: decorationNode];
        [peopleNode createPhysicsBounds];
        
        self.trashNode = [[FTTrashNode alloc] initWithChipmunkSpace: [peopleNode space]];
        
        [self addChild: floorMapNode];
        [self addChild: trashNode];
        [self addChild: structureNode];
        [self addChild: decorationNode];
        [self addChild: peopleNode];
    }
    return self;
}

- (void)resetHouseData{
    [floorMapNode clearAllTiles];
    [floorMapNode fillWithRange: NSRangeFromString(@"60-4")];
    [structureNode clearAllTiles];
    [decorationNode clearDecorations];
}

- (void)readHouseData:(NSDictionary *)houseData{
    self.currentRooms = [[NSMutableArray alloc] init];
    
    if([houseData objectForKey:@"levels"] != nil){
        NSDictionary *level = [[houseData objectForKey:@"levels"] objectAtIndex: currentLevel];
        for(NSDictionary *room in [level objectForKey:@"rooms"]){
            if([room objectForKey:@"roomName"] != nil){
                int rot = 0;
                if([room objectForKey:@"rot"] != nil)
                    rot = [[room objectForKey:@"rot"] intValue];
                [self addRoom:[room objectForKey:@"roomName"] x:[[room objectForKey:@"x"] intValue] y:[[room objectForKey:@"y"] intValue] rot:rot];
            }
        }
        
        [structureNode removeDoorways: currentRooms];
        [structureNode removeDoubleWalls: currentRooms];
        [structureNode removeSingles];
        [structureNode correctWallOrientations];
        
        for(int x = 0; x < HOUSELOT_WIDTH; x++){
            for(int y = 0; y < HOUSELOT_HEIGHT; y++){
                if([structureNode tileAt:2*x y:2*y]->roomName == nil)
                    [floorMapNode setTileType:0 x:x y:y];
            }
        }
        
        NSMutableSet *closed = [[NSMutableSet alloc] init];
        for(int x = 0; x < HOUSELOT_WIDTH * 2; x++){
            for(int y = 0; y < HOUSELOT_HEIGHT * 2; y++){
                openWeights[y][x] = 0;
                blocked[y][x] = 0;
                
                if([structureNode tileAt:x y:y]->type != 0){
                    blocked[y][x] = 1;
                    [closed addObject: NSStringFromCGPoint(ccp(x,y))];
                }
                if([structureNode tileAt:x y:y]->roomName == nil)
                    blocked[y][x] = 1;
            }
        }
        
        // Build pathfinding information
        for(NSDictionary *dec in [decorationNode decorations]){
            if([dec objectForKey:@"collision"] == nil || ([[dec objectForKey:@"collision"] isEqualToString:@"YES"])){
                if([dec objectForKey:@"collisionrect"] != nil || [dec objectForKey:@"collisioncircle"] != nil){
                    CGRect originalDecRect = [(CCSprite *)[dec objectForKey:@"sprite"] boundingBox];
                    CGRect decRect = originalDecRect;
                    decRect.origin.y = HOUSELOT_HEIGHT * 24 - decRect.origin.y - decRect.size.height;
                    
                    for(int x = decRect.origin.x / 12; x < (decRect.origin.x + decRect.size.width) / 12; x++){
                        for(int y = decRect.origin.y / 12; y < (decRect.origin.y + decRect.size.height) / 12; y++){
                            if(CGRectContainsPoint(originalDecRect, ccp(x * 12 + 6, (HOUSELOT_HEIGHT * 2 - y) * 12 - 6))){
                                blocked[y][x] = 1;
                                [closed addObject: NSStringFromCGPoint(ccp(x,y))];
                            }
                        }
                    }
                }
            }
        }
        
        startingClosedSet = [closed copy];
        
        // Create array of "open" weights, tiles that are more "open" have lower weight
        float distWeight[3] = {15.0f, 6.0f, 1.5f};
        
        for(int x = 0; x < HOUSELOT_WIDTH * 2; x++){
            for(int y = 0; y < HOUSELOT_HEIGHT * 2; y++){
                if(blocked[y][x]){
                    for(int j = 0; j < 3; j++){
                        for(int xx = x - j - 1; xx < x + j + 2; xx++){
                            for(int yy = y - j - 1; yy < y + j + 2; yy++){
                                if(xx >= 0 && xx < HOUSELOT_WIDTH * 2 && yy >= 0 && yy < HOUSELOT_HEIGHT * 2)
                                    openWeights[yy][xx] = max(openWeights[yy][xx], distWeight[j]);
                            }
                        }
                    }
                }
            }
        }

        /*for(int y = 0; y < HOUSELOT_HEIGHT * 2; y++){
            for(int x = 0; x < HOUSELOT_WIDTH * 2; x++){
                int grayscale = 255 - min(openWeights[y][x] * 255 / 30.0f, 255);
                FTTile *tileAt = [structureNode tileAt:x y:y];
                if(tileAt->type == 0)
                    [tileAt->tileSprite setColor: [CCColor colorWithCcColor3b: ccc3(grayscale, grayscale, grayscale)]];
            }
        }*/
        
        /*// Fill top and bottom with fence
        for(int y = 0; y < 1; y++){
            for(int x = 0; x < HOUSELOT_WIDTH; x++){
                int yInd = (y * HOUSELOT_HEIGHT - 1);
                yInd = yInd < 0 ? 0 : yInd;
                [floorMapNode setTileType:41 x:x y:yInd];
            }
        }
        
        // Fill left and right with side fence
        for(int x = 0; x < 1; x++){
            for(int y = 1; y < HOUSELOT_HEIGHT - 1; y++){
                int xInd = (x * HOUSELOT_WIDTH - 1);
                xInd = xInd < 0 ? 0 : xInd;
                
                int type = 42;
                if(xInd != 0)
                    type++;
                [floorMapNode setTileType:type x:xInd y:y];
            }
        }*/
    }
}

- (void)addRoom:(NSString *)roomName x:(int)xx y:(int)yy rot:(int)rot{
    NSMutableDictionary *roomDef = [[[FTModel sharedModel] roomWithName: roomName] mutableCopy];
    [roomDef setObject:@(xx) forKey:@"x"];
    [roomDef setObject:@(yy) forKey:@"y"];
    [roomDef setObject:@(rot) forKey:@"rot"];
    [roomDef setObject:@(0) forKey:@"numusers"];
    [currentRooms addObject: roomDef];
    
    if(roomDef != nil){
        int roomWidth = [[roomDef objectForKey:@"width"] intValue];
        int roomHeight = [[roomDef objectForKey:@"height"] intValue];
        BOOL subs = ([roomDef objectForKey:@"xsubs"] != nil);
        
        if(rot == 90 || rot == -90 || rot == 270){
            int temp = roomWidth;
            roomWidth = roomHeight;
            roomHeight = temp;
        }
        
        if(subs){
            int modulo = 1;
            if(rot == 90 || rot == 180)
                modulo = 0;
            
            int xsubs = [[roomDef objectForKey: @"xsubs"] intValue];
            int ysubs = [[roomDef objectForKey: @"ysubs"] intValue];
            NSString *subflip = [roomDef objectForKey: @"subflip"];
            
            if(rot == 90 || rot == -90 || rot == 270){
                if([subflip isEqualToString:@"horizontal"])
                    subflip = @"vertical";
                else
                    subflip = @"horizontal";
                
                int temp = xsubs;
                xsubs = ysubs;
                ysubs = temp;
            }
            
            for(int x = 0; x < xsubs; x++){
                for(int y = 0; y < ysubs; y++){
                    if([roomDef objectForKey:@"decorations"] != nil){
                        if([subflip isEqualToString:@"vertical"] && y % 2 == modulo)
                            [self createDecorations:[roomDef objectForKey:@"decorations"] x:xx + (roomWidth * x) y:yy + (roomHeight * y) rot:rot width:roomWidth height:roomHeight subflip:subflip];
                        else if([subflip isEqualToString:@"horizontal"] && x % 2 == modulo)
                            [self createDecorations:[roomDef objectForKey:@"decorations"] x:xx + (roomWidth * x) y:yy + (roomHeight * y) rot:rot width:roomWidth height:roomHeight subflip:subflip];
                        else
                            [self createDecorations:[roomDef objectForKey:@"decorations"] x:xx + (roomWidth * x) y:yy + (roomHeight * y) rot:rot width:roomWidth height:roomHeight subflip:nil];

                    }
                    [structureNode createWallRectangle:xx + x * roomWidth y:yy + y * roomHeight width:roomWidth height:roomHeight roomID:[currentRooms count] roomName:roomName];
                }
            }
        }else{
            if([roomDef objectForKey:@"decorations"] != nil)
                [self createDecorations:[roomDef objectForKey:@"decorations"] x:xx y:yy rot:rot width:roomWidth height:roomHeight subflip:nil];
            [structureNode createWallRectangle:xx y:yy width:roomWidth height:roomHeight roomID:[currentRooms count] roomName:roomName];
        }
    }else{
        NSLog(@"No room found by name %@", roomName);
    }
}

- (NSArray *)findPathFrom:(CGPoint)start end:(CGPoint)end{
    int startTileX = (start.x / 12);//18;//46;
    int startTileY = (HOUSELOT_HEIGHT * 2) - (start.y / 12);
    
    int endTileX = (end.x / 12);
    int endTileY = (HOUSELOT_HEIGHT * 2) - (end.y / 12);
    
    CGPoint endTile = ccp(endTileX, endTileY);
    
    NSString *startString = NSStringFromCGPoint(ccp(startTileX, startTileY));
    NSString *goalString = NSStringFromCGPoint(ccp(endTileX, endTileY));
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    if(endTileX >= 0 && endTileX < HOUSELOT_WIDTH * 2 && endTileY >= 0 && endTileY < HOUSELOT_HEIGHT * 2){
        NSMutableSet *closedSet = [startingClosedSet mutableCopy];
        NSMutableSet *openSet = [[NSMutableSet alloc] initWithObjects:startString, nil];
        NSMutableDictionary *cameFrom = [[NSMutableDictionary alloc] init];
        
        float gscores[HOUSELOT_HEIGHT * 2][HOUSELOT_WIDTH * 2];
        float fscores[HOUSELOT_HEIGHT * 2][HOUSELOT_WIDTH * 2];
        float hscores[HOUSELOT_HEIGHT * 2][HOUSELOT_WIDTH * 2];
        
        for(int x = 0; x < HOUSELOT_WIDTH * 2; x++){
            for(int y = 0; y < HOUSELOT_HEIGHT * 2; y++){
                gscores[y][x] = 0;
                fscores[y][x] = 0;
                hscores[y][x] = 4 * ccpLength(ccpSub(ccp(x, y), endTile)) + 2 * openWeights[y][x];
                
                FTTile *tile = [structureNode tileAt:x y:y];
                if(tile->type == 44 || tile->type == 45)
                    [structureNode setTileType:0 x:x y:y];
                
            }
        }
        
        gscores[startTileY][startTileX] = 0;
        fscores[startTileY][startTileX] = hscores[startTileY][startTileX];
        
        int itrCount = 0;
        BOOL foundGoal = NO;
        while([openSet count] != 0 && itrCount < 5000){
            NSString *current = nil;
            float currentLowest = INFINITY;
            for(NSString *tile in openSet){
                CGPoint tileCoords = CGPointFromString(tile);
                float tileFScore = fscores[(int)tileCoords.y][(int)tileCoords.x];
                if(tileFScore < currentLowest){
                    current = tile;
                    currentLowest = tileFScore;
                }
            }
            
            if(current != nil){
                if([current isEqualToString: goalString]){
                    foundGoal = YES;
                    break;
                }else{
                    [openSet removeObject: current];
                    [closedSet addObject: current];
                    
                    int currentX = (int)CGPointFromString(current).x;
                    int currentY = (int)CGPointFromString(current).y;
                    
                    //[structureNode setTileType:44 x:currentX y:currentY];
                    
                    NSMutableSet *neighbors = [[NSMutableSet alloc] init];
                    for(int x = currentX - 1; x < currentX + 2; x++){
                        for(int y = currentY - 1; y < currentY + 2; y++){
                            if(x != currentX || y != currentY){
                                [neighbors addObject: NSStringFromCGPoint(ccp(x, y))];
                            }
                        }
                    }
                    
                    for(NSString *neighbor in neighbors){
                        int neighborX = CGPointFromString(neighbor).x;
                        int neighborY = CGPointFromString(neighbor).y;
                        if(![closedSet member: neighbor]){
                            int tentativeG = gscores[currentY][currentX] + 1; // 1 is distance between current and neighbor
                            if(![openSet member: neighbor] || tentativeG < gscores[neighborY][neighborX]){
                                [cameFrom setObject: current forKey:neighbor];
                                gscores[neighborY][neighborX] = tentativeG;
                                fscores[neighborY][neighborX] = tentativeG + hscores[neighborY][neighborX];
                                if(![openSet member: neighbor])
                                    [openSet addObject: neighbor];
                            }
                        }
                    }
                    
                }
                
                itrCount++;
            }else{
                NSLog(@"Current is nil");
                break;
            }
            
        }
        
        if(foundGoal && itrCount < 5000){
            NSMutableArray *pointArray = [[NSMutableArray alloc] init];
            [pointArray addObject: NSStringFromCGPoint(end)];
            
            NSString *pathback = [cameFrom objectForKey: goalString];
            while(pathback != startString){
                int pathX = CGPointFromString(pathback).x;
                int pathY = CGPointFromString(pathback).y;
                [pointArray addObject: NSStringFromCGPoint(ccp(pathX * 12 + 6, (HOUSELOT_HEIGHT * 2 - pathY) * 12 - 6))];
                //[structureNode setTileType:45 x:pathX y:pathY];
                
                pathback = [cameFrom objectForKey: pathback];
            }
            
            /*NSMutableArray *halvedPointArray = [[NSMutableArray alloc] init];
            
            for(int x = 0; x < [pointArray count] - 1; x+=2){
                CGPoint p1 = CGPointFromString([pointArray objectAtIndex: x]);
                CGPoint p2 = CGPointFromString([pointArray objectAtIndex: x+1]);
                
                [halvedPointArray addObject: NSStringFromCGPoint(ccpMidpoint(p1, p2))];
            }
            
            NSMutableArray *smoothedPoints = [[NSMutableArray alloc] init];
            [smoothedPoints addObject: NSStringFromCGPoint(end)];

            float dt = 16.0f/(float)[halvedPointArray count];
            
            for (int i = 0; i < [halvedPointArray count] - 1; i++) {
                CGPoint y1, y2;
                
                y1 = CGPointFromString([halvedPointArray objectAtIndex: i]);
                y2 = CGPointFromString([halvedPointArray objectAtIndex: i + 1]);
                
                [smoothedPoints addObject: [halvedPointArray objectAtIndex: i]];
                
                for(float mu = dt; mu < 1.0f; mu += dt){
                    float mu2 = (1 - cos(mu * 3.1459f)) / 2.0f;
                    
                    [smoothedPoints addObject: NSStringFromCGPoint(ccp(y1.x*(1.f-mu2)+y2.x*mu2, y1.y*(1.f-mu2)+y2.y*mu2))];
                }
            }
            */
            //NSLog(@"Pathfinding runtime: %f ms, itrcount: %i", (CFAbsoluteTimeGetCurrent() - startTime) * 1000, itrCount);
            
            return [pointArray copy];
        }else{
            NSLog(@"Couldn't find goal in pathfinding");
            for(int x = 0; x < HOUSELOT_WIDTH * 2; x++){
                for(int y = 0; y < HOUSELOT_HEIGHT * 2; y++){
                    FTTile *tile = [structureNode tileAt:x y:y];
                    if(tile->type == 44 || tile->type == 45)
                        [structureNode setTileType:0 x:x y:y];
                    
                }
            }
        }
    }
    
    return nil;
}

- (void)changeLevel:(int)level{
    BOOL goingUp = (level - currentLevel) > 0;
    
    CCRenderTexture *currentLevelRender = [CCRenderTexture renderTextureWithWidth:24 * width height:24*height pixelFormat:CCTexturePixelFormat_Default];
    [currentLevelRender begin];
    [floorMapNode visit];
    [structureNode visit];
    [decorationNode visit];
    [peopleNode visit];
    [currentLevelRender end];
    
    CCSprite *currentLevelSprite = [CCSprite spriteWithTexture: currentLevelRender.sprite.texture];
    
    [currentLevelSprite setPosition: ccp(0.5f * 24 * width, 0.5f * 24 * height)];
    [currentLevelSprite setFlipY: YES];
    
    float destScale = (goingUp ? 0.9f : 1.1f);
    [currentLevelSprite runAction: [CCActionScaleTo actionWithDuration:0.4f scale:destScale]];
    [currentLevelSprite runAction: [CCActionFadeOut actionWithDuration: 0.4f]];
    
    currentLevel = level;
    [self resetHouseData];
    [self readHouseData: [[FTModel sharedModel] currentHouseData]];
    CCRenderTexture *nextLevelRender = [CCRenderTexture renderTextureWithWidth:24 * width height:24*height pixelFormat:CCTexturePixelFormat_Default];
    [nextLevelRender begin];
    [floorMapNode visit];
    [structureNode visit];
    [decorationNode visit];
    [peopleNode visit];
    [nextLevelRender end];
    
    CCSprite *nextLevelSprite = [CCSprite spriteWithTexture: nextLevelRender.sprite.texture];
    
    float startScale = (goingUp ? 1.1f : 0.9f);

    [nextLevelSprite setPosition: ccp(0.5f * 24 * width, 0.5f * 24 * height)];
    [nextLevelSprite setFlipY: YES];
    [nextLevelSprite setScale: startScale];
    [nextLevelSprite setOpacity: 0];
    
    if(goingUp){
        [currentLevelSprite runAction: [CCActionTintTo actionWithDuration:0.4f color:[CCColor colorWithCcColor3b:ccc3(150, 150, 150)]]];
        [self addChild: currentLevelSprite];
        [self addChild: nextLevelSprite];
        [nextLevelSprite runAction: [CCActionFadeIn actionWithDuration: 0.2f]];

    }else{
        [nextLevelSprite setColor: [CCColor colorWithCcColor3b: ccc3(150, 150, 150)]];
        [self addChild: nextLevelSprite];
        [self addChild: currentLevelSprite];
        [nextLevelSprite runAction: [CCActionFadeIn actionWithDuration: 0.4f]];

    }
    
    [nextLevelSprite runAction: [CCActionScaleTo actionWithDuration:0.4f scale:1.0f]];
    [nextLevelSprite runAction: [CCActionTintTo actionWithDuration:0.4f color:[CCColor whiteColor]]];
    
    [floorMapNode setVisible: NO];
    [structureNode setVisible: NO];
    [decorationNode setVisible: NO];
    [peopleNode setVisible: NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.4f), dispatch_get_main_queue(), ^{
        [self removeChild: nextLevelSprite];
        [self removeChild: currentLevelSprite];
        
        [floorMapNode setVisible: YES];
        [structureNode setVisible: YES];
        [decorationNode setVisible: YES];
        [peopleNode setVisible: YES];
    });
}

- (BOOL)pointCanSpawnPerson:(CGPoint)pt{
    int ptX = pt.x / 12;
    int ptY = pt.y / 12;
    ptY = HOUSELOT_HEIGHT * 2 - ptY;
    
    if(ptX >= 0 && ptX < HOUSELOT_WIDTH * 2 && ptY >= 0 && ptY < HOUSELOT_HEIGHT * 2){
        if(!blocked[ptY][ptX] && openWeights[ptY][ptX] < 6.1f && [self decorationAtTapLocation: pt] == nil)
            return YES;
    }
    
    return NO;
}

- (NSMutableDictionary *)decorationAtTapLocation:(CGPoint)tap{
    // Search backwards to find decorations on top first
    for(int i = (int)[[decorationNode decorations] count] - 1; i >= 0; i--){
        NSMutableDictionary *decDict = [[decorationNode decorations] objectAtIndex: i];
        if(CGRectContainsPoint([(CCSprite *)[decDict objectForKey:@"sprite"] boundingBox], tap)){
            return decDict;
        }
    }
    return nil;
}

- (void)createDecorations:(NSArray *)decorations x:(int)xx y:(int)yy rot:(int)rot width:(int)w height:(int)h subflip:(NSString *)subflip{
    for(int x = 0; x < [decorations count]; x++){
        NSDictionary *decoration = [decorations objectAtIndex: x];
        if([decoration objectForKey: @"decName"] != nil ){
            NSString *decName = [decoration objectForKey:@"decName"];
            int decX = [[decoration objectForKey:@"x"] intValue];
            int decY = [[decoration objectForKey:@"y"] intValue];
            int decRot = [[decoration objectForKey:@"rot"] intValue];
            decRot += rot;
            
            if(rot == 90){
                int temp2 = decX;
                decX = (w * 24) - decY; // Width because width is original height
                decY = temp2;
            }else if(rot == 180){
                decX = (w * 24) - decX;
                decY = (h * 24) - decY;
            }else if(rot == -90 || rot == 270){
                int temp2 = decX;
                decX = decY;
                decY = (h * 24) - temp2; // Height because height is original width
            }
            
            NSDictionary *decorationDict = [[FTModel sharedModel] decorationWithName:decName];
            
            if([subflip isEqualToString:@"vertical"]){
                [[self decorationNode] addDecoration:decorationDict x:xx * 24 + decX y:(height * 24) - (yy * 24 + (h * 24) - decY) rot:decRot flipVertical:YES flipHorizontal:NO];
            }else if([subflip isEqualToString:@"horizontal"]){
                [[self decorationNode] addDecoration:decorationDict x:xx * 24 + (w * 24) - decX y:(height * 24) - (yy * 24 + decY) rot:decRot flipVertical:NO flipHorizontal:YES];
            }else{
                [[self decorationNode] addDecoration:decorationDict x:xx * 24 + decX y:(height * 24) - (yy * 24 + decY) rot:decRot flipVertical:NO flipHorizontal:NO];
            }
        }
    }
}

@end
