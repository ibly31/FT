//
//  FTEditorBlueprint.m
//  FratTycoon
//
//  Created by Billy Connolly on 3/16/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTEditorBlueprint.h"
#import "EditorScene.h"

@implementation FTEditorBlueprint

- (id)initWithWidth:(int)w height:(int)h{
    CCRenderTexture *render = [[CCRenderTexture alloc] initWithWidth:w * 24 * EDITOR_SCALE height:h * 24 * EDITOR_SCALE pixelFormat:CCTexturePixelFormat_Default];
    [render beginWithClear:0.0f g:0.43f b:0.87 a:1.0f];
    
    CCDrawNode *drawNode = [[CCDrawNode alloc] init];
    
    [drawNode drawSegmentFrom:ccp(12 * EDITOR_SCALE, 12 * EDITOR_SCALE) to:ccp((w - 0.5f) * 24 * EDITOR_SCALE, 12 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
    [drawNode drawSegmentFrom:ccp(12 * EDITOR_SCALE, 12 * EDITOR_SCALE) to:ccp(12 * EDITOR_SCALE, (h - 0.5f) * 24 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
    [drawNode drawSegmentFrom:ccp((w - 0.5f) * 24 * EDITOR_SCALE, 12 * EDITOR_SCALE) to:ccp((w - 0.5f) * 24 * EDITOR_SCALE, (h - 0.5f) * 24 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
    [drawNode drawSegmentFrom:ccp((w - 0.5f) * 24 * EDITOR_SCALE, (h - 0.5f) * 24 * EDITOR_SCALE) to:ccp(12 * EDITOR_SCALE, (h - 0.5f) * 24 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
    
    [drawNode drawSegmentFrom:ccp(36 * EDITOR_SCALE, 36 * EDITOR_SCALE) to:ccp((w - 1.5f) * 24 * EDITOR_SCALE, 36 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
    [drawNode drawSegmentFrom:ccp(36 * EDITOR_SCALE, 36 * EDITOR_SCALE) to:ccp(36 * EDITOR_SCALE, (h - 1.5f) * 24 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
    [drawNode drawSegmentFrom:ccp((w - 1.5f) * 24 * EDITOR_SCALE, 36 * EDITOR_SCALE) to:ccp((w - 1.5f) * 24 * EDITOR_SCALE, (h - 1.5f) * 24 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
    [drawNode drawSegmentFrom:ccp((w - 1.5f) * 24 * EDITOR_SCALE, (h - 1.5f) * 24 * EDITOR_SCALE) to:ccp(36 * EDITOR_SCALE, (h - 1.5f) * 24 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
   
    CCLabelTTF *number = [CCLabelTTF labelWithString:@"1" fontName:@"Draftsman.ttf" fontSize:10.0f dimensions:CGSizeMake((w - 3) * 24 / 5.0f, 12)];
    [number setHorizontalAlignment: CCTextAlignmentCenter];
    
    int num = 0;
    for(float x = 36 * EDITOR_SCALE; x < ((w - 1.6f) * 24 * EDITOR_SCALE); x += (w - 3) * 24 * EDITOR_SCALE / 5.0f){
        [number setString: [NSString stringWithFormat:@"%i", num]];
        [number setPosition: ccp(x + (w - 3) * 24 * EDITOR_SCALE / 10.0f, 24 * EDITOR_SCALE)];
        [number visit];
        [number setPosition: ccp(x + (w - 3) * 24 * EDITOR_SCALE / 10.0f, (h - 1.0f) * 24 * EDITOR_SCALE)];
        [number visit];
        
        if(num != 0){
            [drawNode drawSegmentFrom:ccp(x, 12 * EDITOR_SCALE) to:ccp(x, 36 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
            [drawNode drawSegmentFrom:ccp(x, (h - 1.5f) * 24 * EDITOR_SCALE) to:ccp(x, (h - 0.5f) * 24 * EDITOR_SCALE) radius:2.0f color:[CCColor whiteColor]];
        }
        
        num++;
    }
    
    num = 0;
    [number setDimensions: CGSizeMake(24, 12)];
    for(float y = 36 * EDITOR_SCALE; y < ((h - 1.6f) * 24 * EDITOR_SCALE); y += (h - 3) * 24 * EDITOR_SCALE / 5.0f){
        if(num < 5){
            [number setString: [@[@"E",@"D",@"C",@"B",@"A"] objectAtIndex: num]];
            [number setPosition: ccp(24 * EDITOR_SCALE, y + (h - 3) * 24 * EDITOR_SCALE / 10.0f)];
            [number visit];
            [number setPosition: ccp((w - 1.0f) * 24 * EDITOR_SCALE, y + (h - 3) * 24 * EDITOR_SCALE / 10.0f)];
            [number visit];
            
        }
        
        if(num != 0){
            [drawNode drawSegmentFrom:ccp(12 * EDITOR_SCALE, y) to:ccp(36 * EDITOR_SCALE, y) radius:2.0f color:[CCColor whiteColor]];
            [drawNode drawSegmentFrom:ccp((w - 1.5f) * 24 * EDITOR_SCALE, y) to:ccp((w - 0.5f) * 24 * EDITOR_SCALE, y) radius:2.0f color:[CCColor whiteColor]];
        }
        
        num++;
    }
    
    for(float x = 48 * EDITOR_SCALE; x < ((w - 1.0f) * 24 * EDITOR_SCALE); x += 24 * EDITOR_SCALE){
        [drawNode drawSegmentFrom:ccp(x, 36 * EDITOR_SCALE) to:ccp(x, (h - 1.5f) * 24 * EDITOR_SCALE) radius:1.0f color:[CCColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5]];
        [drawNode drawSegmentFrom:ccp(36 * EDITOR_SCALE, x) to:ccp((w - 1.5f) * 24 * EDITOR_SCALE, x) radius:1.0f color:[CCColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.5]];

    }
    
    [drawNode visit];
    [render end];
    
    self = [super initWithTexture: render.sprite.texture];
    [self setScaleY: -1.0f];
    return self;

}

@end
