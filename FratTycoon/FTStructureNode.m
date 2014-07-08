//
//  FTStructureNode.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/12/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTStructureNode.h"

@implementation FTStructureNode
@synthesize width;
@synthesize height;

- (id)initWithWidth:(int)w height:(int)h blueprint:(BOOL)bp{
    self = [super initWithFile:@"WallPieces.png" capacity:w*h];
    if(self){
        self.width = w;
        self.height = h;
        
        tileSize = 12;
        sheetWidth = 11;
        
        tileSprites = [[NSMutableArray alloc] init];
        
        if(bp)
            blueprintOffset = 26;
        else
            blueprintOffset = 0;
        
        for(int y = 0; y < height; y++){
            for(int x = 0; x < width; x++){
                levelData[(y * width) + x].type = 0;
                levelData[(y * width) + x].roomName = nil;
                
                CCSprite *sprite = [[CCSprite alloc] initWithTexture:[self texture] rect:CGRectMake(0, blueprintOffset, tileSize, tileSize)];
                [sprite setPosition: ccp(x * tileSize + tileSize / 2, (tileSize * height) - (y * tileSize) - tileSize / 2)];
                
                [tileSprites addObject: sprite];
                [self addChild: sprite];
            }
        }
    }
    return self;
}

- (id)initWithWidth:(int)w height:(int)h range:(NSRange)range{
    self = [super initWithFile:@"TextureMap.png" capacity:w*h];
    if(self){
        self.width = w;
        self.height = h;
        
        tileSize = 24;
        sheetWidth = 20;
        
        tileSprites = [[NSMutableArray alloc] init];
        
        for(int y = 0; y < height; y++){
            for(int x = 0; x < width; x++){
                int type = range.location + rand() % (range.length);
                
                levelData[(y * width) + x].type = type;
                levelData[(y * width) + x].roomName = nil;
                
                CCSprite *sprite = [[CCSprite alloc] initWithTexture:[self texture] rect:CGRectMake((tileSize + 1) * (type % sheetWidth), (tileSize + 1) * (type / sheetWidth), tileSize, tileSize)];
                [sprite setPosition: ccp(x * tileSize + tileSize / 2, (tileSize * height) - (y * tileSize) - tileSize / 2)];
                [sprite setRotation: (rand() % 4) * 90.0f];
                
                [tileSprites addObject: sprite];
                [self addChild: sprite];
            }
        }
        
    }
    return self;
}

- (void)fillWithRange:(NSRange)range{
    for(int y = 0; y < height; y++){
        for(int x = 0; x < width; x++){
            int type = range.location + rand() % (range.length);
            
            [self setTileType:type x:x y:y];
        }
    }
}

- (id)initWithWidth:(int)w height:(int)h{
    self = [super initWithFile:@"CampusSheet.png" capacity:w*h];
    if(self){
        self.width = w;
        self.height = h;
        
        tileSize = 16;
        sheetWidth = 10;
        
        tileSprites = [[NSMutableArray alloc] init];
        
        for(int y = 0; y < height; y++){
            for(int x = 0; x < width; x++){
                int type = 0;
                levelData[(y * width) + x].type = type;
                levelData[(y * width) + x].roomName = nil;
                
                CCSprite *sprite = [[CCSprite alloc] initWithTexture:[self texture] rect:CGRectMake((tileSize + 1) * (type % sheetWidth), (tileSize + 1) * (type / sheetWidth), tileSize, tileSize)];
                [sprite setPosition: ccp(x * tileSize + tileSize / 2, (tileSize * height) - (y * tileSize) - tileSize / 2)];
                [tileSprites addObject: sprite];
                [self addChild: sprite];
            }
        }
    }
    return self;
}

- (void)removeDoorways:(NSArray *)rooms{
    // Create bool matrix of doorway zones
    BOOL doorwayZones[height][width];
    for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
            doorwayZones[y][x] = NO;
        }
    }
    
    // Populate doorwayZones matrix
    for(NSDictionary *room in rooms){
        int xsubs = 1, ysubs = 1;
        NSString *subflip = nil;
        int rot = [[room objectForKey: @"rot"] intValue];
        int roomWidth = [[room objectForKey: @"width"] intValue];
        int roomHeight = [[room objectForKey: @"height"] intValue];
        
        int modulo = 1;
        if(rot == 90 || rot == 180)
            modulo = 0;
        
        if([room objectForKey:@"xsubs"] != nil){
            xsubs = [[room objectForKey: @"xsubs"] intValue];
            ysubs = [[room objectForKey: @"ysubs"] intValue];
            subflip = [room objectForKey: @"subflip"];
        }
        
        if(rot == 90 || rot == -90 || rot == 270){
            if([subflip isEqualToString:@"horizontal"])
                subflip = @"vertical";
            else
                subflip = @"horizontal";
            
            int temp = xsubs;
            xsubs = ysubs;
            ysubs = temp;
            
            int temp2 = roomWidth;
            roomWidth = roomHeight;
            roomHeight = temp2;
        }
        
        if([room objectForKey:@"doorwayzones"] != nil){
            for(NSArray *zone in [room objectForKey:@"doorwayzones"]){
                for(int x = 0; x < xsubs; x++){
                    for(int y = 0; y < ysubs; y++){
                        for(NSString *tile in zone){
                            NSArray *components = [tile componentsSeparatedByString:@","];
                            if([components count] == 2){
                                int xInd = [[components objectAtIndex: 0] intValue];
                                int yInd = [[components objectAtIndex: 1] intValue];
                                
                                if(rot == 90){
                                    int temp = xInd;
                                    xInd = roomWidth * 2 - 1 - yInd; // Width because width is original height
                                    yInd = temp;
                                }else if(rot == 180){
                                    xInd = roomWidth * 2 - 1 - xInd;
                                    yInd = roomHeight * 2 - 1 - yInd;
                                }else if(rot == -90 || rot == 270){
                                    int temp = xInd;
                                    xInd = yInd;
                                    yInd = roomHeight * 2 - 1 - temp; // Height because height is original width
                                }
                                
                                if([subflip isEqualToString:@"vertical"] && y % 2 == modulo){
                                    yInd = roomHeight * 2 - yInd - 1;
                                }else if([subflip isEqualToString:@"horizontal"] && x % 2 == modulo){
                                    xInd = roomWidth * 2 - xInd - 1;
                                }
                                
                                xInd += [[room objectForKey:@"x"] intValue] * 2;
                                yInd += [[room objectForKey:@"y"] intValue] * 2;
                                
                                xInd += x * roomWidth * 2;
                                yInd += y * roomHeight * 2;
                                
                                doorwayZones[yInd][xInd] = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    
    // If two doorway zones are in a vertical line, decrement both
    for(int x = 0; x < width; x++){
        for(int y = 1; y < height - 2; y++){
            if(!doorwayZones[y-1][x] && doorwayZones[y][x] && doorwayZones[y+1][x] && !doorwayZones[y+2][x]){
                FTTile *ce = [self tileAt:x y:y];
                FTTile *dn = [self tileAt:x y:y+1];
                [self setTileType:0 x:x y:y];
                [self setTileType:0 x:x y:y+1];
            }
        }
    }
    
    // If two doorway zones are in a horizontal line, decrement both
    for(int y = 0; y < height; y++){
        for(int x = 1; x < width - 2; x++){
            if(!doorwayZones[y][x-1] && doorwayZones[y][x] && doorwayZones[y][x+1] && !doorwayZones[y][x+2]){
                FTTile *ce = [self tileAt:x y:y];
                FTTile *ri = [self tileAt:x+1 y:y];
                [self setTileType:0 x:x y:y];
                [self setTileType:0 x:x+1 y:y];
            }
        }
    }
     
}

- (void)removeDoubleWalls:(NSArray *)rooms{
    // Mark all special corner cases as type 3 to avoid removal
    for(int x = 1; x < width - 1; x++){
        for(int y = 1; y < height - 1; y++){
            FTNeighbors neighbors = [self neighborsAt:x y:y];
            
            if(neighbors.mm && !neighbors.ul && !neighbors.ur && !neighbors.ll && !neighbors.lr){
                if(neighbors.um && neighbors.mr && !neighbors.lm && !neighbors.ml){
                    [self setTileType:3 x:x y:y];
                }else if(neighbors.mr && neighbors.lm && !neighbors.ml && !neighbors.um){
                    [self setTileType:3 x:x y:y];
                }else if(neighbors.lm && neighbors.ml && !neighbors.um && !neighbors.mr){
                    [self setTileType:3 x:x y:y];
                }else if(neighbors.ml && neighbors.um && !neighbors.mr && !neighbors.lm){
                    [self setTileType:3 x:x y:y];
                }
            }
        }
    }

    // Remove all double walls in the vertical direction. Preference to a hallway losing its cinderblock.
    for(int x = 0; x < width; x++){
        for(int y = 0; y < height - 2; y++){
            FTTile *up = [self tileAt:x y:y];
            FTTile *down = [self tileAt:x y:y+1];
            FTTile *down2 = [self tileAt:x y:y+2];
            
            
            NSString *downRoomName = nil;
            if(down->roomName != nil)
                [NSString stringWithCString:down->roomName encoding:NSUTF8StringEncoding];
            
            if(!up->type && down->type && down2->type){
                if(down->roomID != down2->roomID){
                    if([[downRoomName substringToIndex:[downRoomName length] - 1] isEqualToString:@"hallway"]){
                        [self setTileType:down->type - 1 x:x y:y+1];
                    }
                }
            }else if(up->type && down->type && !down2->type){
                if(up->roomID != down->roomID){
                    if([[downRoomName substringToIndex:[downRoomName length] - 1] isEqualToString:@"hallway"]){
                        [self setTileType:down->type - 1 x:x y:y+1];
                    }
                }
            }
        }
    }
    
    // Remove all double walls in the horizontal direction. Preference to a hallway losing its cinderblock.
    for(int y = 0; y < height; y++){
        for(int x = 0; x < width - 2; x++){
            FTTile *left = [self tileAt:x y:y];
            FTTile *right = [self tileAt:x+1 y:y];
            FTTile *right2 = [self tileAt:x+2 y:y];
            
            NSString *rightRoomName = nil;
            if(right->roomName != nil)
                [NSString stringWithCString:right->roomName encoding:NSUTF8StringEncoding];
            
            if(!left->type && right->type && right2->type){
                if(right->roomID != right2->roomID){
                    if([[rightRoomName substringToIndex:[rightRoomName length] - 1] isEqualToString:@"hallway"]){
                        [self setTileType:right->type - 1 x:x+1 y:y];
                    }
                }
            }else if(left->type && right->type && !right2->type){
                if(left->roomID != right->roomID){
                    if([[rightRoomName substringToIndex:[rightRoomName length] - 1] isEqualToString:@"hallway"]){
                        [self setTileType:right->type - 1 x:x+1 y:y];
                    }
                }
            }
        }
    }
}

- (void)removeSingles{
    // Remove all blocks with no neighbors
    for(int x = 1; x < width - 1; x++){
        for(int y = 1; y < height - 1; y++){
            if([self tileAt:x y:y]->type > 0){
                if([self tileAt:x-1 y:y]->type == 0 && [self tileAt:x+1 y:y]->type == 0 && [self tileAt:x y:y-1]->type == 0 && [self tileAt:x y:y+1]->type == 0){
                    [self setTileType:0 x:x y:y];
                }
            }
        }
    }
}

- (void)correctWallOrientations{
    // Flatten the tile types to all 1s
    for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
            if([self tileAt:x y:y]->type){
                [self setTileType:1 x:x y:y];
            }
        }
    }
    
    // For each pattern, set tile type
    for(int x = 1; x < width - 1; x++){
        for(int y = 1; y < height - 1; y++){
            int finalType = 0;
            
            FTNeighbors neighbors = [self neighborsAt:x y:y];
            if(neighbors.mm == 1){
                int numAdj = neighbors.um + neighbors.mr + neighbors.lm + neighbors.ml;
                
                if(numAdj == 1){
                    if(neighbors.um)
                        finalType = 1;
                    else if(neighbors.mr)
                        finalType = 2;
                    else if(neighbors.lm)
                        finalType = 3;
                    else
                        finalType = 4;
                }else if(numAdj == 2){
                    if(neighbors.um && neighbors.lm){
                        finalType = 9;
                    }else if(neighbors.ml && neighbors.mr){
                        finalType = 10;
                    }else if(neighbors.um && neighbors.mr){
                        finalType = 5;
                    }else if(neighbors.mr && neighbors.lm){
                        finalType = 6;
                    }else if(neighbors.lm && neighbors.ml){
                        finalType = 7;
                    }else{
                        finalType = 8;
                    }
                }else if(numAdj == 3){
                    if(neighbors.ml && neighbors.um && neighbors.mr){
                        if(neighbors.ul || neighbors.ur)
                            finalType = 15;
                        else
                            finalType = 11;
                    }else if(neighbors.um && neighbors.mr && neighbors.lm){
                        if(neighbors.ur || neighbors.lr)
                            finalType = 16;
                        else
                            finalType = 12;
                    }else if(neighbors.mr && neighbors.lm && neighbors.ml){
                        if(neighbors.lr || neighbors.ll)
                            finalType = 17;
                        else
                            finalType = 13;
                    }else{
                        if(neighbors.ll || neighbors.ul)
                            finalType = 18;
                        else
                            finalType = 14;
                    }
                }else if(numAdj == 4){
                    if(neighbors.ul && neighbors.ur && neighbors.ll && neighbors.lr)
                        finalType = 20;
                    else
                        finalType = 19;
                }else{
                    finalType = 21; // purple bitch
                }
                
                [self setTileType:finalType x:x y:y];
            }
        }
    }
}

- (void)clearAllTiles{
    for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
            [self setTileType:0 x:x y:y];
            [self setTileRoom:nil roomID:0 x:x y:y];
        }
    }
}

- (void)fadeTilesInAndOut{
    for(CCSprite *tile in tileSprites){
        [tile runAction: [CCActionSequence actionOne:[CCActionFadeOut actionWithDuration:0.4f] two:[CCActionFadeIn actionWithDuration:0.4f]]];
    }
}

- (void)createWallRectangle:(int)xx y:(int)yy width:(int)w height:(int)h roomID:(int)roomID roomName:(NSString *)roomName{
    for(int x = 2 * xx; x < 2 * (xx + w); x++){
        for(int y = 2 * yy; y < 2 * (yy + h); y++){
            [self setTileRoom:roomName roomID:roomID x:x y:y];
        }
    }
    
    for(int x = 2 * xx; x < 2 * (xx + w); x++){
        [self setTileType:1 x:x y:2*yy];
        [self setTileType:1 x:x y:2*(yy+h) - 1];
        [self setTileRoom:roomName roomID:roomID x:x y:2*yy];
        [self setTileRoom:roomName roomID:roomID x:x y:2*(yy + h) - 1];
    }
    for(int y = 2 * yy; y < 2 * (yy + h); y++){
        [self setTileType:1 x:2*xx y:y];
        [self setTileType:1 x:2*(xx + w) - 1 y:y];
        [self setTileRoom:roomName roomID:roomID x:2*xx y:y];
        [self setTileRoom:roomName roomID:roomID x:2*(xx + w) - 1 y:y];
    }
    
}

- (void)setTileType:(int)type x:(int)x y:(int)y{
    type = (type < 0) ? 0 : type;
    FTTile *tileAt = [self tileAt:x y:y];
    if(tileAt && tileAt->type != -1){
        tileAt->type = type;
        CCSprite *sprite = [tileSprites objectAtIndex: (y * width) + x];
        [sprite setTextureRect: CGRectMake((tileSize + 1) * (type % sheetWidth), (tileSize + 1) * (type / sheetWidth) + blueprintOffset, tileSize, tileSize)];
    }else{
        NSLog(@"Couldn't set tile (%i,%i) type to %i", x, y, type);
    }
}
               
- (void)setTileRoom:(NSString *)roomName roomID:(int)roomID x:(int)x y:(int)y{
    FTTile *tileAt = [self tileAt:x y:y];
    if(tileAt && tileAt->type != -1){
        if(roomName != nil){
            char *roomNameMemory = malloc(sizeof(char) * [roomName length]);
            tileAt->roomName = strcpy(roomNameMemory, [roomName cStringUsingEncoding:NSUTF8StringEncoding]);
        }else{
            tileAt->roomName = nil;
        }
        tileAt->roomID = roomID;
    }else
        NSLog(@"Couldn't set tile (%i,%i) to room %@", x, y, roomName);
}

- (FTTile *)tileAt:(int)x y:(int)y{
    if(x >= 0 && x < width && y >= 0 && y < height)
        return &levelData[(y * width) + x];
    return nil;
}

- (FTNeighbors)neighborsAt:(int)x y:(int)y{
    FTNeighbors neighbors;
    neighbors.ul = -1; neighbors.um = -1; neighbors.ur = -1;
    neighbors.ml = -1; neighbors.mm = -1; neighbors.mr = -1;
    neighbors.ll = -1; neighbors.lm = -1; neighbors.lr = -1;
    
    if(x >= 1 && x < width - 1 && y >= 1 && y < height - 1){
        neighbors.ul = levelData[(y-1)*width + (x-1)].type;
        neighbors.um = levelData[(y-1)*width + (x)].type;
        neighbors.ur = levelData[(y-1)*width + (x+1)].type;
        
        neighbors.ml = levelData[(y)*width + (x-1)].type;
        neighbors.mm = levelData[(y)*width + (x)].type;
        neighbors.mr = levelData[(y)*width + (x+1)].type;
        
        neighbors.ll = levelData[(y+1)*width + (x-1)].type;
        neighbors.lm = levelData[(y+1)*width + (x)].type;
        neighbors.lr = levelData[(y+1)*width + (x+1)].type;
        
        neighbors.ul = neighbors.ul ? 1 : 0;
        neighbors.um = neighbors.um ? 1 : 0;
        neighbors.ur = neighbors.ur ? 1 : 0;
        
        neighbors.ml = neighbors.ml ? 1 : 0;
        neighbors.mm = neighbors.mm ? 1 : 0;
        neighbors.mr = neighbors.mr ? 1 : 0;
        
        neighbors.ll = neighbors.ll ? 1 : 0;
        neighbors.lm = neighbors.lm ? 1 : 0;
        neighbors.lr = neighbors.lr ? 1 : 0;
    }
    return neighbors;
}

@end
