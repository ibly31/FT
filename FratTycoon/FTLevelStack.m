//
//  FTLevelStack.m
//  FratTycoon
//
//  Created by Billy Connolly on 5/26/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTLevelStack.h"

@implementation FTLevelStack
@synthesize delegate;

- (id)initWithLevels:(NSArray *)l{
    self = [super init];
    if(self){
        CCLayoutBox *layout = [[CCLayoutBox alloc] init];
        [layout setDirection: CCLayoutBoxDirectionVertical];
        [layout setAnchorPoint: ccp(0.5, 0.5)];
        
        for(int i = 0; i < [l count]; i++){
            CCButton *levelButton = [CCButton buttonWithTitle:[NSString stringWithFormat:@"L%i", i + 1] fontName:@"Palatino" fontSize:24];
            [levelButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Button.png"] forState:CCControlStateNormal];
            [levelButton setName: [NSString stringWithFormat: @"%i", i + kMenuTagOffset]];
            [levelButton setTarget:self selector:@selector(changeLevel:)];
            [levelButton setLabelColor:[CCColor blackColor] forState:CCControlStateNormal];
            [levelButton setLabelColor:[CCColor blackColor] forState:CCControlStateHighlighted];
            [levelButton setBackgroundColor:[CCColor lightGrayColor] forState:CCControlStateHighlighted];
            [levelButton setHorizontalPadding: 5];
            [levelButton setVerticalPadding: 5];
            [levelButton setZoomWhenHighlighted: NO];
            [layout addChild: levelButton];
            
            /*CCSprite *levelSprite = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(i * 80, 260, 80, 40)];
             CCSprite *levelSpriteSelected = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"GUI.png"] rect:CGRectMake(i * 80, 260, 80, 40)];
             [levelSpriteSelected setColor: [CCColor colorWithCcColor3b: ccc3(255, 50, 50)]];
             
             CCMenuItemImage *menuItem = [[CCMenuItemImage alloc] initWithNormalSprite:levelSprite selectedSprite:levelSpriteSelected disabledSprite:nil target:self selector:@selector(changeLevel:)];
             [menuItem setPosition: ccp(0, i * 25)];
             [menuItem setTag: kMenuTagOffset + i];
             [menuItems addObject: menuItem];*/
            
            
        }
        [layout setSpacing: 10];
        [layout layout];
        [self addChild: layout];
    }
    return self;
}

- (void)changeLevel:(CCNode *)sender{
    if([sender.name intValue] - kMenuTagOffset != currentLevel){
        [self setCurrentLevel: [sender.name intValue] - kMenuTagOffset];
        [delegate changeLevel: [sender.name intValue] - kMenuTagOffset];
    }
}

- (void)setCurrentLevel:(int)level{
    //[[[self children] objectAtIndex: currentLevel] stopAllActions];
    //[(CCSprite *)[[self children] objectAtIndex: currentLevel] setScale: 1.0f];
    //[(CCNode *)[[self children] objectAtIndex: currentLevel] setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 255)]];
    
    currentLevel = level;
    //CCActionSequence *scaleSequence = [CCActionSequence actionOne:[CCActionScaleTo actionWithDuration:0.4f scale:1.1f] two:[CCActionScaleTo actionWithDuration:0.4f scale:1.0f]];
    //[[[self children] objectAtIndex: currentLevel] runAction: [CCActionRepeatForever actionWithAction: scaleSequence]];
    //[(CCNode *)[[self children] objectAtIndex: currentLevel] setColor: [CCColor colorWithCcColor3b: ccc3(255, 255, 0)]];
}

@end
