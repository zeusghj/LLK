//
//  MusicHandler.h
//  LLK
//
//  Created by guohongjun on 12-12-22.
//
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface MusicHandler : NSObject
{
}

+(void) preload;            //preload the music;
+(void) notify_sprite_connect;
+(void) notify_item_click;
+(void) notify_sprite_click;

+(void) notifyPlayGameBgMusic;

@end
