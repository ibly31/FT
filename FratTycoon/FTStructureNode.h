//
//  FTStructureNode
//  FratTycoon
//
//  Created by Billy Connolly on 2/12/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"

typedef struct FTTile{
    int type;
    int roomID;
    char *roomName;
}FTTile;

typedef struct FTNeighbors{
    int ul,um,ur;
    int ml,mm,mr;
    int ll,lm,lr;
}FTNeighbors;

#define MAX_TILES 15000

@interface FTStructureNode : CCSpriteBatchNode{
    struct FTTile levelData[MAX_TILES];
    
    NSMutableArray *tileSprites;
    
    float blueprintOffset;
    
    int tileSize;
    int sheetWidth;
}

- (id)initWithWidth:(int)w height:(int)h range:(NSRange)range;
- (id)initWithWidth:(int)w height:(int)h blueprint:(BOOL)bp;
- (id)initWithWidth:(int)w height:(int)h;

@property int width;
@property int height;

- (void)fillWithRange:(NSRange)range;

- (void)removeDoorways:(NSArray *)rooms;
- (void)removeDoubleWalls:(NSArray *)rooms;
- (void)removeSingles;
- (void)correctWallOrientations;
- (void)clearAllTiles;
- (void)fadeTilesInAndOut;
- (void)createWallRectangle:(int)xx y:(int)yy width:(int)w height:(int)h roomID:(int)roomID roomName:(NSString *)roomName;
- (void)setTileType:(int)type x:(int)x y:(int)y;
- (void)setTileRoom:(NSString *)roomName roomID:(int)roomID x:(int)x y:(int)y;
- (FTTile *)tileAt:(int)x y:(int)y;
- (FTNeighbors)neighborsAt:(int)x y:(int)y;

@end
