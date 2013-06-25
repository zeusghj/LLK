//
//  MusicHandler.m
//  LLK
//
//  Created by guohongjun on 12-12-22.
//
//

#import "MusicHandler.h"

//background music
static NSString *GAME_BACKGROUND_EFFECT = @"GameBkMusic.mp3";
static NSString *MENU_BACKGROUND_EFFECT = @"MenuBkMusic.mp3";

//link musics
static NSString *SPRITE_CLICK_EFFECT = @"sprite_click_effect.mp3";
static NSString *SPRITE_CONNECT_EFFECT = @"sprite_connect_effect.mp3";
static NSString *ITEM_CLICK_EFFECT = @"item_click_effect.wav";

@interface MusicHandler()

+(void) playEffect:(NSString *)path;
+ (void)playBackgroundMusic:(NSString *)path;
+ (void)stopBackgroundMusic:(NSString *)path;

@end

@implementation MusicHandler

+ (void)preload{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    if (engine) {
        [engine preloadBackgroundMusic:GAME_BACKGROUND_EFFECT];
        //[engine preloadBackgroundMusic:MENU_BACKGROUND_EFFECT];
        [engine preloadEffect:SPRITE_CONNECT_EFFECT];
		[engine preloadEffect:SPRITE_CLICK_EFFECT];
        [engine preloadEffect:ITEM_CLICK_EFFECT];
    }
}

+(void) notify_sprite_connect
{
    [MusicHandler playEffect:SPRITE_CONNECT_EFFECT];
}
+(void) notify_item_click
{
	[MusicHandler playEffect:ITEM_CLICK_EFFECT];
}

+(void) notify_sprite_click
{
    [MusicHandler playEffect:SPRITE_CLICK_EFFECT];
}

+(void) notifyPlayGameBgMusic
{
    [MusicHandler playBackgroundMusic:GAME_BACKGROUND_EFFECT];
}

+ (void)playEffect:(NSString *)path
{
    [[SimpleAudioEngine sharedEngine]playEffect:path];
}

+ (void)playBackgroundMusic:(NSString *)path
{
    [[SimpleAudioEngine sharedEngine]playBackgroundMusic:path];
}

+ (void)stopBackgroundMusic:(NSString *)path
{
    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
}


@end
