//
//  FTDecorationNode.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/13/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTDecorationNode.h"

@implementation FTDecorationNode
@synthesize width;
@synthesize height;
@synthesize decorations;

- (id)init{
    self = [super init];
    if(self){
        sprites = [[CCSpriteBatchNode alloc] initWithFile:@"Decorations.png" capacity:MAX_DECORATIONS];
        [self addChild: sprites z:1];
        
        self.decorations = [[NSMutableArray alloc] init];
        [self schedule:@selector(updateNumUsers) interval:0.1f];
    }
    return self;
}

- (NSMutableDictionary *)decorationFromSequentialLink:(NSDictionary *)decDict{
    NSString *startDecName = [decDict objectForKey: @"name"];
    
    int indexOfFirstNumber = -1;
    for(int i = 0; i < [startDecName length] && indexOfFirstNumber == -1; i++){
        if(isnumber([startDecName characterAtIndex: i]))
            indexOfFirstNumber = i;
    }
        
    if(indexOfFirstNumber != -1){
        int currentNumber = atoi([[startDecName substringFromIndex: indexOfFirstNumber] UTF8String]);
        NSString *searchDecName = [NSString stringWithFormat:@"%@%i", [startDecName substringToIndex: [startDecName length] - 1], currentNumber + 1];
        
        CGPoint houseLoc = [(CCSprite *)[decDict objectForKey:@"sprite"] position];
        NSMutableDictionary *closestSearchDecDict = nil;
        float closestSearchDist = INFINITY;
        
        for(NSMutableDictionary *searchDecDict in self.decorations){
            if([[searchDecDict objectForKey:@"name"] isEqualToString: searchDecName]){
                CGPoint decHouseLoc = [(CCSprite *)[searchDecDict objectForKey:@"sprite"] position];
                float searchDist = ccpDistance(decHouseLoc, houseLoc);
                if(searchDist < closestSearchDist){
                    closestSearchDecDict = searchDecDict;
                    closestSearchDist = searchDist;
                }
                    
            }
        }
        
        return closestSearchDecDict;
    }
    
    return nil;
}

- (NSMutableDictionary *)decorationFromName:(NSString *)name adjacentTo:(NSDictionary *)decDict{
    CGPoint houseLoc = [(CCSprite *)[decDict objectForKey:@"sprite"] position];
    NSMutableDictionary *closestSearchDecDict = nil;
    float closestSearchDist = INFINITY;
    
    for(NSMutableDictionary *searchDecDict in self.decorations){
        if([[searchDecDict objectForKey:@"name"] isEqualToString: name]){
            CGPoint decHouseLoc = [(CCSprite *)[searchDecDict objectForKey:@"sprite"] position];
            float searchDist = ccpDistance(decHouseLoc, houseLoc);
            if(searchDist < closestSearchDist){
                closestSearchDecDict = searchDecDict;
                closestSearchDist = searchDist;
            }
            
        }
    }
    
    return closestSearchDecDict;
}

- (void)updateNumUsers{
    for(NSMutableDictionary *decDict in decorations){
        if([decDict objectForKey: @"use"] != nil){
            int numUsers = [[decDict objectForKey: @"numusers"] intValue];
            CCLabelTTF *numUsersLabel = [decDict objectForKey: @"numUsersLabel"];
            
            [numUsersLabel setString: [NSString stringWithFormat: @"%i", numUsers]];
        }
    }
}

- (void)clearDecorations{
    [self removeAllChildren];
    decorations = [[NSMutableArray alloc] init];
}

- (void)addDecoration:(NSDictionary *)decoration x:(int)x y:(int)y rot:(int)rot flipVertical:(BOOL)flipVertical flipHorizontal:(BOOL)flipHorizontal{
    CGRect displayRect = CGRectFromString([decoration objectForKey:@"displayrect"]);
    displayRect = CGRectMake(displayRect.origin.x / 2, displayRect.origin.y / 2, displayRect.size.width / 2, displayRect.size.height / 2);
    
    NSMutableDictionary *decDict = [decoration mutableCopy];

    CCSprite *decorationSprite = [[CCSprite alloc] initWithTexture:[sprites texture] rect:displayRect];
    if(rot == 90 || rot == -90 || rot == 270){
        if(flipVertical){
            [decorationSprite setScaleX: -1.0f];
        }
        if(flipHorizontal){
            [decorationSprite setScaleY: -1.0f];
        }
    }else{
        if(flipVertical){
            [decorationSprite setScaleY: -1.0f];
        }
        if(flipHorizontal){
            [decorationSprite setScaleX: -1.0f];
        }
    }
    
    [decorationSprite setPosition: ccp(x, y)];
    [decorationSprite setRotation: rot];
    
    [sprites addChild: decorationSprite];
    [decDict setObject:decorationSprite forKey:@"sprite"];
    
    if([decDict objectForKey: @"use"]){
        CCLabelTTF *numUsersLabel = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"Palatino" fontSize:18];
        [numUsersLabel setColor: [CCColor yellowColor]];
        [numUsersLabel setPosition: ccp(x, y)];
        [self addChild: numUsersLabel z: 2];
        [decDict setObject:numUsersLabel forKey:@"numUsersLabel"];
        
        [decDict setObject:@(0) forKey:@"numusers"];
    }
        
    [decorations addObject: decDict];
}

@end
