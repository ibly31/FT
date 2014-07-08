//
//  FTMinigameScene.m
//  FratTycoon
//
//  Created by Billy Connolly on 2/17/14.
//  Copyright 2014 ibly31apps. All rights reserved.
//

#import "FTMinigameScene.h"

@implementation FTMinigameScene

+(CCScene *)scene{
	CCScene *scene = [CCScene node];
	FTMinigameScene *layer = [FTMinigameScene node];
	[scene addChild: layer];
	return scene;
}

- (id)init{
    self = [super init];
    if(self){
        CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithCcColor4b:ccc4(125, 125, 125, 255)]];
        [self addChild: background];
        
        bpTable = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 0, 230, 350)];
        [bpTable setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2 + 40.0f)];
        [self addChild: bpTable];
        
        topCups = [[NSMutableArray alloc] init];
        bottomCups = [[NSMutableArray alloc] init];
        
        for(int x = 0; x < 6; x++){
            CCSprite *topCup = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 360, 20, 20)];
            CCSprite *bottomCup = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 360, 20, 20)];
            
            topCupsOut[x] = 0;
            bottomCupsOut[x] = 0;
            
            [topCups addObject: topCup];
            [bottomCups addObject: bottomCup];
            
            [self addChild: topCup];
            [self addChild: bottomCup];
        }
        
        [(CCSprite *)[topCups objectAtIndex: 0] setPosition: ccp(bpTable.position.x - 20, bpTable.position.y + 156)];
        [(CCSprite *)[topCups objectAtIndex: 1] setPosition: ccp(bpTable.position.x, bpTable.position.y + 156)];
        [(CCSprite *)[topCups objectAtIndex: 2] setPosition: ccp(bpTable.position.x + 20, bpTable.position.y + 156)];
        [(CCSprite *)[topCups objectAtIndex: 3] setPosition: ccp(bpTable.position.x - 10, bpTable.position.y + 138)];
        [(CCSprite *)[topCups objectAtIndex: 4] setPosition: ccp(bpTable.position.x + 10, bpTable.position.y + 138)];
        [(CCSprite *)[topCups objectAtIndex: 5] setPosition: ccp(bpTable.position.x, bpTable.position.y + 120)];
        
        [(CCSprite *)[bottomCups objectAtIndex: 0] setPosition: ccp(bpTable.position.x - 20, bpTable.position.y - 156)];
        [(CCSprite *)[bottomCups objectAtIndex: 1] setPosition: ccp(bpTable.position.x, bpTable.position.y - 156)];
        [(CCSprite *)[bottomCups objectAtIndex: 2] setPosition: ccp(bpTable.position.x + 20, bpTable.position.y - 156)];
        [(CCSprite *)[bottomCups objectAtIndex: 3] setPosition: ccp(bpTable.position.x - 10, bpTable.position.y - 138)];
        [(CCSprite *)[bottomCups objectAtIndex: 4] setPosition: ccp(bpTable.position.x + 10, bpTable.position.y - 138)];
        [(CCSprite *)[bottomCups objectAtIndex: 5] setPosition: ccp(bpTable.position.x, bpTable.position.y - 120)];
        // 90,16
        
        bpBall1 = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 380, 40, 40)];
        [bpBall1 setVisible: NO];
        [self addChild: bpBall1];
        
        bpBall2 = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 380, 40, 40)];
        [bpBall2 setVisible: NO];
        [self addChild: bpBall2];
        
        backButton = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"TextureMap.png"] rect:CGRectMake(0, 100, 100, 48)];
        [backButton setPosition: ccp([[CCDirector sharedDirector] viewSize].width - 54, [[CCDirector sharedDirector] viewSize].height - 26)];
        [self addChild: backButton];
        
        /*topIndicator = [[CCSprite alloc] initWithFile:@"Minigames.png" rect:CGRectMake(60, 380, 300, 12)];
        [topIndicator setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2, 200)];
        [topIndicator setColor: [CCColor colorWithCcColor3b: ccc3(0, 0, 255)]];
        [self addChild: topIndicator];*/
        
        shotStartIndicator = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 440, 60, 30)];
        [shotStartIndicator setAnchorPoint: ccp(0.5f, 0.0f)];
        [shotStartIndicator setVisible: NO];
        [self addChild: shotStartIndicator];
        
        shotConnector = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 438, 60, 1)];
        [shotConnector.texture setAntialiased: NO];
        [shotConnector setAnchorPoint: ccp(0.5f, 1.0f)];
        [shotConnector setVisible: NO];
        [self addChild: shotConnector];
        
        shotLocIndicator = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"Minigames.png"] rect:CGRectMake(0, 470, 60, 30)];
        [shotStartIndicator setAnchorPoint: ccp(0.5f, 1.0f)];
        [shotLocIndicator setVisible: NO];
        [self addChild: shotLocIndicator];
        
        touchBackButton = NO;
        throwing = NO;
        ballInFlight = NO;
        ballZ = 0.0f;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint loc = [[touches anyObject] locationInView: [[CCDirector sharedDirector] view]];
    loc.y = [[CCDirector sharedDirector] viewSize].height - loc.y;

    if(CGRectContainsPoint([backButton boundingBox], loc)){
        touchBackButton = YES;
    }else if(!movingCup && !throwing && !ballInFlight){
        throwStartLoc = loc;
        [shotStartIndicator setPosition: loc];
        [shotStartIndicator setVisible: YES];
        [shotConnector setVisible: YES];
        [shotConnector setScaleY: 0.0f];
        //[shotLocIndicator setPosition: ccp(loc.x, loc.y - 30)];
        //[shotLocIndicator setVisible: YES];
        
        throwing = YES;
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint loc = [[touches anyObject] locationInView: [[CCDirector sharedDirector] view]];
    loc.y = [[CCDirector sharedDirector] viewSize].height - loc.y;
    
    if(throwing){
        //ballVelZ = sinf(M_PI_4) * ccpLength(averageV);
        
        CGPoint shotOffset = ccpSub(throwStartLoc, loc);
        float color = fabsf(ccpLength(shotOffset) - 255.0f);

        [shotStartIndicator setColor: [CCColor colorWithCcColor3b: ccc3(color, 255 - color, 0)]];
        [shotConnector setColor: [CCColor colorWithCcColor3b: ccc3(color, 255 - color, 0)]];
        
        float angle = 90 + CC_RADIANS_TO_DEGREES(-atan2f(throwStartLoc.y - loc.y, throwStartLoc.x - loc.x));
        
        [shotStartIndicator setRotation: angle];
        [shotConnector setPosition: ccpAdd(throwStartLoc, ccpMult(ccpNormalize(shotOffset), -30.0f))];
        [shotConnector setScaleY: ccpLength(shotOffset)];
        [shotConnector setRotation: angle];
        //[shotLocIndicator setPosition: ccpAdd(throwStartLoc, ccpMult(ccpNormalize(shotOffset), -ccpLength(shotOffset) - 30.0f))];
        //[shotLocIndicator setRotation: angle];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint loc = [[touches anyObject] locationInView: [[CCDirector sharedDirector] view]];
    loc.y = [[CCDirector sharedDirector] viewSize].height - loc.y;
    
    if(touchBackButton && CGRectContainsPoint([backButton boundingBox], loc)){
        [self goBack];
    }
    
    if(throwing){
        throwing = NO;
        
        ballVelocity = ccpSub(throwStartLoc, loc);
        
        ballVelocity = ccpMult(ballVelocity, 2 * sinf(M_PI_4));
        
        [bpBall1 setPosition: ccp([[CCDirector sharedDirector] viewSize].width / 2, 40)];
        [bpBall1 setScale: 0.2f];
        [bpBall1 setVisible: YES];
        [bpBall1 setOpacity: 255];
        ballZ = 0.0f;
        ballVelZ = ccpLength(ballVelocity);
        
        ballInFlight = YES;
        
        [shotStartIndicator setVisible: NO];
        [shotConnector setVisible: NO];
        [shotLocIndicator setVisible: NO];
    }
}

- (void)update:(CCTime)delta{
    /*if(throwing){
        ccColor4F actualColor = ccc4FFromccc3B([topIndicator color]);
        if(!ccc4FEqual(desiredColor, actualColor)){
            ccColor3B newColor = ccc3((desiredColor.r - actualColor.r) * 64 + [topIndicator color].r, (desiredColor.g - actualColor.g) * 64 + [topIndicator color].g, (desiredColor.b - actualColor.b) * 64 + [topIndicator color].b);
            [topIndicator setColor: newColor];
            [bottomIndicator setColor: newColor];
        }
    }*/
    
    if(ballInFlight){
        NSLog(@"BZ: %f", ballZ);
        
        if(ballZ + ballVelZ * delta < 0){
            for(int x = 0; x < 6; x++){
                CCSprite *cup = [topCups objectAtIndex: x];
                if(ccpLength(ccpSub([cup position], [bpBall1 position])) <= 8.0f){
                    // Ball landed in cup
                    [bpBall1 runAction: [CCActionMoveTo actionWithDuration:0.1f position:ccp([cup position].x + (CCRANDOM_MINUS1_1() * 4.0f), [cup position].y + (CCRANDOM_MINUS1_1() * 4.0f))]];
                    ballInFlight = NO;
                    movingCup = YES;
                    
                    [bpBall2 setOpacity: 255];
                    [bpBall2 setVisible: YES];
                    [bpBall2 setScale: [bpBall1 scale]];
                    [bpBall2 setPosition: [bpBall1 position]];
                    
                    topCupsOut[x] = 2;
                    
                    [self scheduleOnce:@selector(moveCup) delay:0.75f];
                    
                    [bpBall1 setVisible: NO];
                    
                    return;
                }else if(ccpLength(ccpSub([cup position], [bpBall1 position])) <= 10.0f){
                    ballVelocity.x *= (-CCRANDOM_0_1() - 0.5f);
                    ballVelocity.y *= (CCRANDOM_0_1() + 0.5f);
                }
            }
            
            if(ballInFlight){ // did not land in a cup
                ballVelZ *= -0.9f; // bounce ball
            }
        
        }else if([bpBall1 position].y + ballVelocity.y * delta > [bpTable position].y + [bpTable boundingBox].size.height + 20){
            ballInFlight = NO;
            [bpBall1 runAction: [CCActionFadeOut actionWithDuration: 0.25f]];
        }
        
        [bpBall1 setPosition: ccpAdd([bpBall1 position], ccpMult(ballVelocity, delta))];
        
        ballZ += ballVelZ * delta;
        ballVelZ -= 600.0f * delta;
        
        [bpBall1 setScale: 0.2f + ballZ / 250.0f];
    }
}
                     
- (void)moveCup{
    int numTopCupsOut = 0;
    int whichCupToMove = -1;
    
    for(int x = 0; x < 6; x++){
        if(topCupsOut[x] == 2){
            whichCupToMove = x;
            topCupsOut[x] = 1;
        }else if(topCupsOut[x]){
            numTopCupsOut++;
        }
    }
    
    if(whichCupToMove != -1){
        CGPoint destination = ccp([bpTable position].x - [bpTable boundingBox].size.width / 2 + 24, [bpTable boundingBox].origin.y + [bpTable boundingBox].size.height - (numTopCupsOut + 2) * 24);
        CGPoint offset = ccpSub(destination, [(CCSprite *)[topCups objectAtIndex: whichCupToMove] position]);
        [[topCups objectAtIndex: whichCupToMove] runAction: [CCActionMoveBy actionWithDuration:0.5f position:offset]];
        [bpBall2 runAction: [CCActionMoveBy actionWithDuration:0.5f position:offset]];
    }
    
    movingCup = NO;
}

- (void)goBack{
    [[CCDirector sharedDirector] popScene];
}

@end
