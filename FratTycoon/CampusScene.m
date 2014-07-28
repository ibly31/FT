//
//  CampusScene.m
//  FratTycoon
//
//  Created by Billy Connolly on 4/25/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "CampusScene.h"
#import "FTConstants.h"
#import "FTModel.h"
#import "CCLabelAtlas.h"

@implementation CampusScene

static NSString *letterLabelName = @"123";
static NSString *letterBackgroundName = @"124";

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	CampusScene *layer = [CampusScene node];
	[scene addChild: layer];
	return scene;
}

- (id)init{
    self = [super init];
    if(self){
        //mainStreet = (CCRANDOM_0_1() * (CAMPUS_BLOCKS_ACROSS - 2)) + 1;
        mainStreet = -2;
        
        backButton = [CCButton buttonWithTitle:@"Back" fontName:@"Palatino" fontSize:28];
        [backButton setHorizontalPadding: 10];
        [backButton setVerticalPadding: 5];
        [backButton setLabelColor:[CCColor blackColor] forState:CCControlStateNormal];
        [backButton setLabelColor:[CCColor blackColor] forState:CCControlStateHighlighted];
        [backButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Button.png"] forState:CCControlStateNormal];
        [backButton setBackgroundColor:[CCColor lightGrayColor] forState:CCControlStateHighlighted];
        [backButton setTarget:self selector:@selector(goBack)];
        [backButton setPosition: ccp(45, [[CCDirector sharedDirector] viewSize].height - 39)];
        [backButton setZoomWhenHighlighted: NO];
        [self addChild: backButton z:2];
        
        houseColors[0] = ccc3(146, 140, 142);
        houseColors[1] = ccc3(110, 76, 83);
        houseColors[2] = ccc3(136, 139, 149);
        houseColors[3] = ccc3(111, 95, 95);
        houseColors[4] = ccc3(188, 147, 128);
        houseColors[5] = ccc3(120, 120, 125);
        houseColors[6] = ccc3(162, 62, 71);
        houseColors[7] = ccc3(133, 137, 144);
        
        fratDefs = [[FTModel sharedModel] organizationListWithName: @"frats"];
        soroDefs = [[FTModel sharedModel] organizationListWithName: @"soros"];
        
        showingLetters = YES;
        
        campus = [[CCNode alloc] init];
        [campus setScale: 0.75f];
        
        frats = [[NSMutableArray alloc] initWithCapacity: NUM_FRATS];
        soros = [[NSMutableArray alloc] initWithCapacity: NUM_SOROS];
        buildings = [[NSMutableArray alloc] initWithCapacity: 48];
        
        [self resetAndPlace];
        [self addChild: campus];
        
        [self scheduleOnce:@selector(flipLabels) delay: 3.0f];
        
        panOffset = [campus position];
        panStartLocation = ccp(0, 0);
        panning = NO;
        
        [self setContentSize: [[CCDirector sharedDirector] viewSize]];
        [self setUserInteractionEnabled: YES];
    }
    return self;
}

- (void)resetStructureNode{
    BOOL suitableSizeFound = NO;
    while(!suitableSizeFound){
        int cumWidth = 1;
        printf("\nW:");
        for(int x = 0; x < CAMPUS_BLOCKS_ACROSS; x++){
            blockWidths[x] = (int)(CCRANDOM_0_1() * 2) + 4;
            cumWidth += blockWidths[x];
            printf("%i ", blockWidths[x]);
        }
        
        printf("\nH:");
        int cumHeight = 1;
        for(int y = 0; y < CAMPUS_BLOCKS_DOWN; y++){
            blockHeights[y] = (int)(CCRANDOM_0_1() * 3) + 6;
            cumHeight += blockHeights[y];
            printf("%i ", blockHeights[y]);
        }
        
        width = cumWidth + CAMPUS_BLOCKS_ACROSS;
        height = cumHeight + CAMPUS_BLOCKS_DOWN;
        
        if(width > 22 && height > 39)
            suitableSizeFound = YES;
    }
    
    NSLog(@"WxH %ix%i", width, height);
    
    structureNode = [[FTStructureNode alloc] initWithWidth:width height:height];
    buildingNode = [[CCSpriteBatchNode alloc] initWithFile:@"CampusSheet.png" capacity:200];

    for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
            //[[structureNode tileAt:x y:y]->tileSprite setScale: 0.97f];
            [structureNode tileAt:x y:y]->roomID = 0;
        }
    }
    
    int x = 0;
    for(int i = 0; i < CAMPUS_BLOCKS_ACROSS + 1; i++){
        for(int y = 0; y < height; y++){
            [structureNode setTileType:1 x:x y:y];
            [structureNode tileAt:x y:y]->roomID = 1;
        }
        x += blockWidths[i] + 1;
    }
    
    int y = 0;
    for(int i = 0; i < CAMPUS_BLOCKS_DOWN + 1; i++){
        for(int x = 0; x < width; x++){
            [structureNode setTileType:2 x:x y:y];
            [structureNode tileAt:x y:y]->roomID = 1;
        }
        y += blockHeights[i] + 1;
    }
    
    x = 0;
    for(int i = 0; i < CAMPUS_BLOCKS_ACROSS + 1; i++){
        y = 0;
        for(int j = 0; j < CAMPUS_BLOCKS_DOWN + 1; j++){
            [structureNode setTileType:7 x:x y:y];
            [structureNode tileAt:x y:y]->roomID = 1;
            
            y += blockHeights[j] + 1;
        }
        
        x += blockWidths[i] + 1;
    }
    
    [campus addChild: structureNode z:1];
    [campus addChild: buildingNode z:2];
}

- (void)resetAndPlace{
    [self resetStructureNode];
    [self placeBuildingsOfType:@"frat" count:NUM_FRATS tileID:2 needsCorner: YES];
    [self placeBuildingsOfType:@"soro" count:NUM_SOROS tileID:3 needsCorner: YES];
    //[self placeBuildingsOfType:@"baseballfield" count:2 tileID:4 needsCorner:YES];
    [self placeBuildingsOfType:@"apartment" count:20 tileID:5 needsCorner:NO];
    [self placeBuildingsOfType:@"parkinglot" count:20 tileID:6 needsCorner:NO];
    [self placeBuildingsOfType:@"house" count:40 tileID:7 needsCorner:NO];
    [self placeTrees];
}

- (int)sumRoomIdsInRect:(int)x y:(int)y w:(int)w h:(int)h{
    if(x >= 0 && (x+w) < width && y >= 0 && (y+h) < height){
        int total = 0;
        for(int xx = x; xx < x + w; xx++){
            for(int yy = y; yy < y + h; yy++){
                total += [structureNode tileAt:xx y:yy]->roomID;
            }
        }
        return total;
    }
    return -1;
}

- (void)placeBuildingsOfType:(NSString *)type count:(int)count tileID:(int)tileID needsCorner:(BOOL)needsCorner{
    NSMutableArray *defsCopy = nil;
    
    if([type isEqualToString: @"frat"])
        defsCopy = [fratDefs mutableCopy];
    else if([type isEqualToString: @"soro"])
        defsCopy = [soroDefs mutableCopy];
    
    for(int i = 0; i < count; i++){
        int whichBlock;
        if([type isEqualToString: @"frat"])
            whichBlock = CCRANDOM_0_1() * CAMPUS_BLOCKS_ACROSS * 3 + (CAMPUS_BLOCKS_ACROSS * 2);
        else if([type isEqualToString: @"soro"])
            whichBlock = CCRANDOM_0_1() * CAMPUS_BLOCKS_ACROSS * 3;
        else
            whichBlock = CCRANDOM_0_1() * CAMPUS_BLOCKS_ACROSS * CAMPUS_BLOCKS_DOWN;
        
        int blockWidth = blockWidths[whichBlock % CAMPUS_BLOCKS_ACROSS];
        int blockHeight = blockHeights[whichBlock / CAMPUS_BLOCKS_ACROSS];
        
        int xx = 1;
        for(int i = 0; i < (whichBlock % CAMPUS_BLOCKS_ACROSS); i++){
            xx += blockWidths[i] + 1;
        }
        
        int yy = 1;
        for(int i = 0; i < (whichBlock / CAMPUS_BLOCKS_ACROSS); i++){
            yy += blockHeights[i] + 1;
        }
        
        int styleCount = [[FTModel sharedModel] buildingCountWithName: type];
        
        if(styleCount == 0){
            NSLog(@"Building type %@ invalid.", type);
            return;
        }
        
        int whichStyle = CCRANDOM_0_1() * styleCount + 1;
        
        NSDictionary *buildingDef = [[FTModel sharedModel] buildingWithName:[NSString stringWithFormat:@"%@%i", type, whichStyle]];
        
        int buildingWidth = [[buildingDef objectForKey: @"width"] intValue];
        int buildingHeight = [[buildingDef objectForKey: @"height"] intValue];
        
        int buildingXOffset = 0;
        int buildingYOffset = 0;
        
        if(needsCorner){
            int whichCorner = CCRANDOM_0_1() * 4;
            int lastTry = whichCorner + 3;
            
            BOOL canPlace = NO;
            
            for(; whichCorner < lastTry; whichCorner++){
                int upperLeftCornerX = 0;
                int upperLeftCornerY = 0;
                
                if((whichCorner % 4) == 0 || (whichCorner % 4) == 3){
                    if(mainStreet == (whichBlock % CAMPUS_BLOCKS_ACROSS))
                        continue;
                }else{
                    if(mainStreet == (whichBlock % CAMPUS_BLOCKS_ACROSS) + 1)
                        continue;
                }
                
                if((whichCorner % 4) == 0){
                    upperLeftCornerX = xx;
                    upperLeftCornerY = yy;
                }else if((whichCorner % 4) == 1){
                    upperLeftCornerX = xx + blockWidth - buildingWidth;
                    upperLeftCornerY = yy;
                }else if((whichCorner % 4) == 2){
                    upperLeftCornerX = xx + blockWidth - buildingWidth;
                    upperLeftCornerY = yy + blockHeight - buildingHeight;
                }else{
                    upperLeftCornerX = xx;
                    upperLeftCornerY = yy + blockHeight - buildingHeight;
                }
                
                int total = 0;
                for(int x = upperLeftCornerX; x < upperLeftCornerX + buildingWidth; x++){
                    for(int y = upperLeftCornerY; y < upperLeftCornerY + buildingHeight; y++){
                        total += [structureNode tileAt:x y:y]->roomID;
                    }
                }
                
                if([self sumRoomIdsInRect:upperLeftCornerX y:upperLeftCornerY w:buildingWidth h:buildingHeight] == 0){
                    canPlace = YES;
                    break;
                }
            }
            
            if(canPlace == NO){
                i--;
                continue;
            }
            
            switch(whichCorner % 4){
                case 1:
                    buildingXOffset = blockWidth - buildingWidth;
                    break;
                case 2:
                    buildingXOffset = blockWidth - buildingWidth;
                    buildingYOffset = blockHeight - buildingHeight;
                    break;
                case 3:
                    buildingYOffset = blockHeight - buildingHeight;
                    break;
            }
        }else{
            int whichSide = CCRANDOM_0_1() * 4;
            int lastTry = whichSide + 3;
            
            BOOL canPlace = NO;
            for(; whichSide < lastTry; whichSide++){
                if(whichSide == 0 || whichSide == 2){
                    int y = yy;
                    if(whichSide == 2)
                        y = yy + blockHeight - buildingHeight;
                    for(int x = xx; x < xx + blockWidth - buildingWidth; x++){
                        if([self sumRoomIdsInRect:x y:y w:buildingWidth h:buildingHeight] == 0){
                            buildingXOffset = x - xx;
                            buildingYOffset = y - yy;
                            canPlace = YES;
                            break;
                        }
                    }
                }else if(whichSide == 1 || whichSide == 3){
                    int x = xx;
                    if(whichSide == 1)
                        x = xx + blockWidth - buildingWidth;
                    for(int y = yy; y < yy + blockHeight - buildingHeight; y++){
                        if([self sumRoomIdsInRect:x y:y w:buildingWidth h:buildingHeight] == 0){
                            buildingXOffset = x - xx;
                            buildingYOffset = y - yy;
                            canPlace = YES;
                            break;
                        }
                    }
                }
            }
            
            if(canPlace == NO){
                i--;
                continue;
            }
        }
        
        NSString *letters = nil;
        NSString *nickname = nil;
        NSMutableArray *buildingArray = buildings;
        
        if([type isEqualToString:@"frat"]){
            buildingArray = frats;
            
            int index = (int)(CCRANDOM_0_1() * [defsCopy count]);
            letters = [[defsCopy objectAtIndex: index] objectForKey:@"letters"];
            nickname = [[defsCopy objectAtIndex: index] objectForKey:@"nickname"];
            [defsCopy removeObjectAtIndex: index];
            
            /*int letInd0 = CCRANDOM_0_1() * 24;
             int letInd1 = CCRANDOM_0_1() * 24;
             int letInd2 = CCRANDOM_0_1() * 24;
             //NSString *alphabet = @"ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ";
             letters = [NSString stringWithFormat:@"%c%c%c", 'a' + letInd0, 'a' + letInd1, 'a' + letInd2, nil];*/
        }else if([type isEqualToString:@"soro"]){
            buildingArray = soros;
            
            int index = (int)(CCRANDOM_0_1() * [defsCopy count]);
            letters = [[defsCopy objectAtIndex: index] objectForKey:@"letters"];
            nickname = [[defsCopy objectAtIndex: index] objectForKey:@"nickname"];
            [defsCopy removeObjectAtIndex: index];
        }
        
        for(int x = xx + buildingXOffset; x < xx + buildingXOffset + buildingWidth; x++){
            for(int y = yy + buildingYOffset; y < yy + buildingYOffset + buildingHeight; y++){
                [structureNode tileAt:x y:y]->roomID = tileID;
            }
        }
        
        CGRect displayRect = CGRectFromString([buildingDef objectForKey:@"displayrect"]);
        displayRect = CGRectMake(displayRect.origin.x / 2, displayRect.origin.y / 2, displayRect.size.width / 2, displayRect.size.height / 2);
        
        CCSprite *buildingSprite = [[CCSprite alloc] initWithTexture:[buildingNode texture] rect:displayRect];
        [buildingSprite setPosition: ccp((xx + buildingXOffset) * 16 + buildingWidth * 8, (height - yy - buildingYOffset) * 16 - buildingHeight * 8)];
        
        if(buildingWidth == buildingHeight)
            [buildingSprite setRotation: (int)(CCRANDOM_0_1() * 4) * 90];
        
        if([type isEqualToString:@"apt"] || [type isEqualToString:@"parkinglot"]){
            if(CCRANDOM_0_1() > 0.5)
                [buildingSprite setScaleX: -1.0f];
            if(CCRANDOM_0_1() > 0.5)
                [buildingSprite setScaleY: -1.0f];
        }else if([type isEqualToString:@"house"]){
            [buildingSprite setColor: [CCColor colorWithCcColor3b: houseColors[(int)(CCRANDOM_0_1() * 8)]]];
        }
        
        [buildingNode addChild: buildingSprite];
        
        NSMutableDictionary *building = [buildingDef mutableCopy];
        
        [building setObject:[NSNumber numberWithInt:xx + buildingXOffset] forKey:@"x"];
        [building setObject:[NSNumber numberWithInt:yy + buildingYOffset] forKey:@"y"];
        [building setObject:buildingSprite forKey:@"sprite"];
        
        if(letters != nil){
            [building setObject:letters forKey:@"letters"];
            if(nickname != nil)
                [building setObject:nickname forKey:@"nickname"];
            
            CCNode *lettersNode = [[CCNode alloc] init];
            
            CCLabelAtlas *lettersLabel = [CCLabelAtlas labelWithString: letters charMapFile:@"LettersAtlas.png" itemWidth:20 itemHeight: 20 startCharMap:'a'];
            [lettersLabel setAnchorPoint: ccp(0.5f, 0.5f)];
            
            if([type isEqualToString:@"frat"])
                [lettersLabel setColor: [CCColor colorWithCcColor3b: ccc3(0, 125, 255)]];
            else if([type isEqualToString:@"soro"])
                [lettersLabel setColor: [CCColor colorWithCcColor3b: ccc3(255, 125, 255)]];
            
            CCSprite *letterPointer = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"LettersAtlas.png"] rect:CGRectMake(61, 100, 40, 20)];
            [letterPointer setPosition: ccp(0, -19)];

            CCSprite *letterBackground = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"LettersAtlas.png"] rect:CGRectMake(0, 100, 40, 20)];
            [letterBackground setScaleX: [letters length] / 2.0f];
            [letterBackground setOpacity: 0.7f];
            [lettersNode addChild: letterBackground z:0 name:letterBackgroundName];
            [lettersNode addChild: letterPointer];
            [lettersNode addChild: lettersLabel z:0 name:letterLabelName];
            [lettersNode setPosition: ccp([buildingSprite position].x, [buildingSprite position].y + 20)];
            [campus addChild: lettersNode z:4];
            
            //[lettersNode runAction: [CCRepeatForever actionWithAction: [CCSequence actionOne:[CCScaleTo actionWithDuration:0.5 scale:1.0f] two:[CCScaleTo actionWithDuration:0.5 scale:1.1f]]]];
            
            [building setObject:lettersNode forKey:@"lettersNode"];
        }
        
        [buildingArray addObject: building];
    }
}

- (void)placeTrees{
    CCRenderTexture *treeRender = [CCRenderTexture renderTextureWithWidth:width * 16 height:height * 16 pixelFormat:CCTexturePixelFormat_Default];
    [treeRender beginWithClear:0 g:0 b:0 a:0];
    
    CCSprite *treeSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"CampusSheet.png"] rect:CGRectMake(136, 0, 16, 16)];
    CCSprite *shadowSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"CampusSheet.png"] rect:CGRectMake(136, 17, 16, 16)];
    [shadowSprite setOpacity: 125];
    
    for(int i = 0; i < 4000; i++){
        CGPoint treePoint = ccp(CCRANDOM_0_1() * width * 16, CCRANDOM_0_1() * height * 16);
        if([structureNode tileAt:(treePoint.x / 16) y:(treePoint.y / 16)]->roomID == 0){
            [treeSprite setColor: [CCColor colorWithCcColor3b: ccc3(CCRANDOM_0_1() * 55 + 200, CCRANDOM_0_1() * 55 + 200, CCRANDOM_0_1() * 55 + 200)]];
            [treeSprite setRotation: CCRANDOM_0_1() * 360];
            [treeSprite setScale: CCRANDOM_MINUS1_1() * 0.2f + 0.5f];
            [treeSprite setPosition: treePoint];
            [treeSprite visit];
            
            [shadowSprite setPosition: treePoint];
            [shadowSprite setScale: [treeSprite scale]];
            [shadowSprite visit];
        }else{
            i--;
            continue;
        }
    }
    
    [treeRender end];
    
    CCSprite *actualTrees = [[CCSprite alloc] initWithTexture: [[treeRender sprite] texture]];
    [actualTrees setAnchorPoint: ccp(0, 0)];
    [campus addChild: actualTrees z:3];
}

- (void)flipLabels{
    NSMutableArray *compositeArray = [frats mutableCopy];
    [compositeArray addObjectsFromArray: soros];
    
    for(NSDictionary *org in compositeArray){
        if([org objectForKey: @"nickname"] != nil){
            CCNode *lettersNode = [org objectForKey:@"lettersNode"];
            CCNode<CCLabelProtocol> *lettersNodeLabel = (CCNode<CCLabelProtocol> *)[lettersNode getChildByName: letterLabelName recursively: NO];
            
            if(showingLetters){
                CCLabelTTF *nicknameLabel = [[CCLabelTTF alloc] initWithString:[org objectForKey:@"nickname"] fontName:@"Palatino-Bold" fontSize:18.0f];
                CCSprite *lettersBackground = (CCSprite *)[lettersNode getChildByName: letterBackgroundName recursively: NO];
                float newScale = 1.15f * [nicknameLabel contentSize].width / [lettersNodeLabel contentSize].width;
                [lettersBackground runAction: [CCActionScaleTo actionWithDuration:0.3f scaleX:[[org objectForKey:@"letters"] length] / 2.0f * newScale scaleY:1.0f]];
                [lettersBackground runAction: [CCActionFadeTo actionWithDuration:0.3f opacity:1.0f]];
                [lettersNodeLabel runAction: [CCActionScaleTo actionWithDuration:0.3f scaleX:newScale scaleY:-1.0f]];
            }else{
                CCLabelAtlas *lettersLabel = [[CCLabelAtlas alloc] initWithString:[org objectForKey:@"letters"] charMapFile:@"LettersAtlas.png" itemWidth:20 itemHeight:20 startCharMap:'a'];
                CCSprite *lettersBackground = (CCSprite *)[lettersNode getChildByName: letterBackgroundName recursively: NO];
                [lettersBackground runAction: [CCActionScaleTo actionWithDuration:0.3f scaleX:[[org objectForKey:@"letters"] length] / 2.0f scaleY:1.0f]];
                [lettersBackground runAction: [CCActionFadeTo actionWithDuration:0.3f opacity:0.7f]];
                [lettersNodeLabel runAction: [CCActionScaleTo actionWithDuration:0.3f scaleX:[lettersLabel contentSize].width / [lettersNodeLabel contentSize].width scaleY:-1.0f]];
            }
        }
    }
    
    [self scheduleOnce:@selector(actuallyFlipLabels) delay:0.15f];
}

- (void)actuallyFlipLabels{
    NSMutableArray *compositeArray = [frats mutableCopy];
    [compositeArray addObjectsFromArray: soros];
    
    int i = 0;
    
    for(NSDictionary *org in compositeArray){
        if([org objectForKey: @"nickname"] != nil){
            CCNode *lettersNode = [org objectForKey:@"lettersNode"];
            
            float oldWidth = [[lettersNode getChildByName: letterLabelName recursively:NO] boundingBox].size.width;
            
            if(showingLetters){
                [lettersNode removeChildByName: letterLabelName];
                CCLabelTTF *nicknameLabel = [[CCLabelTTF alloc] initWithString:[org objectForKey:@"nickname"] fontName:@"Palatino-Bold" fontSize:18.0f];
                if(i < [frats count])
                    [nicknameLabel setColor: [CCColor colorWithCcColor3b: ccc3(0, 125, 255)]];
                else
                    [nicknameLabel setColor: [CCColor colorWithCcColor3b: ccc3(200, 100, 200)]];
                [nicknameLabel setAnchorPoint: ccp(0.5f, 0.5f)];
                [lettersNode addChild: nicknameLabel z:0 name:letterLabelName];
            }else{
                [lettersNode removeChildByName: letterLabelName];
                CCLabelAtlas *lettersLabel = [[CCLabelAtlas alloc] initWithString:[org objectForKey:@"letters"] charMapFile:@"LettersAtlas.png" itemWidth:20 itemHeight:20 startCharMap:'a'];
                if(i < [frats count])
                    [lettersLabel setColor: [CCColor colorWithCcColor3b: ccc3(0, 125, 255)]];
                else
                    [lettersLabel setColor: [CCColor colorWithCcColor3b: ccc3(255, 125, 255)]];
                [lettersLabel setAnchorPoint: ccp(0.5f, 0.5f)];
                [lettersNode addChild: lettersLabel z:0 name:letterLabelName];
            }
            
            CCNode<CCLabelProtocol> *lettersLabel = (CCNode<CCLabelProtocol> *)[lettersNode getChildByName: letterLabelName recursively:NO];
            float newScale = oldWidth / [lettersLabel contentSize].width;
            
            [lettersLabel setScaleX: newScale];
            [lettersLabel setScaleY: 0.0f];
            [lettersLabel runAction: [CCActionScaleTo actionWithDuration:0.15f scaleX:1.0f scaleY:1.0f]];
        }
        i++;
    }
    
    showingLetters = !showingLetters;
    
    [self scheduleOnce:@selector(flipLabels) delay:3.5f];
}

- (void)goBack{
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    tapTime = CFAbsoluteTimeGetCurrent();
    
    panStartLocation = loc;
    
    panning = YES;
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if(panning){
        if(ccpDistance(loc, panStartLocation) > 10.0f){
            [campus setPosition: ccpAdd(panOffset, ccpSub(loc, panStartLocation))];
        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint loc = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
    
    if(CFAbsoluteTimeGetCurrent() - tapTime < 0.25 && ccpLength(ccpSub(loc, panStartLocation)) < 10){
        NSLog(@"Tap at %@", NSStringFromCGPoint(loc));
    
        [buildingNode removeAllChildren];
        [structureNode removeAllChildren];
        [campus removeAllChildren];
        
        frats = [[NSMutableArray alloc] initWithCapacity: NUM_FRATS];
        soros = [[NSMutableArray alloc] initWithCapacity: NUM_SOROS];
        buildings = [[NSMutableArray alloc] initWithCapacity: 48];
        
        [self resetAndPlace];
    }
    
    panOffset = [campus position];
    panning = NO;
}

@end
