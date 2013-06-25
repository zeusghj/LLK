//
//  SceneManager.m
//  LLK
//
//  Created by guohongjun on 12-12-21.
//
//

#import "SceneManager.h"
#import "IntroLayer.h"
#import "LLK_Choose_Level_Layer.h"
#import "LLK_Game_Layer.h"

@interface SceneManager ()
+ (void)go: (CCLayer *)layer;
+ (CCScene *)wrap: (CCLayer *)layer;
@end

@implementation SceneManager

+(void)goChooseLevel
{
    CCLayer *layer = [LLK_Choose_Level_Layer node];
    [SceneManager go:layer];
}

+(void)goMainPage
{
    CCLayer *layer = [IntroLayer node];
    [SceneManager go:layer];
}

+(void)goGameLayer
{
    CCLayer *layer = [LLK_Game_Layer node];
    [SceneManager go:layer];
}

+(void)go:(CCLayer *)layer
{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        [director replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:newScene]];
    }
    else{
        [director runWithScene:newScene];
    }
}

+(CCScene *)wrap:(CCLayer *)layer
{
    CCScene *newScene = [CCScene node];
    [newScene addChild:layer];
    return newScene;
}

@end
