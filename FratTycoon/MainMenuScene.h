//
//  MainMenuScene.h
//  FratTycoon
//
//  Created by Billy Connolly on 4/23/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "cocos2d.h"

@interface MainMenuScene : CCNode {
    
}

+ (CCScene *) scene;

- (void)createNew;
- (void)resume;
- (void)options;

@end
