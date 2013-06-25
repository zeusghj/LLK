//
//  LLK_Choose_Level_Layer.m
//  LLK
//
//  Created by guohongjun on 12-12-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LLK_Choose_Level_Layer.h"
#import "SceneManager.h"
#import "MusicHandler.h"

@interface LLK_Choose_Level_Layer(){
    CGFloat scale_screen;
    CGSize size;
}

@end

@implementation LLK_Choose_Level_Layer

- (id)init
{
    if (self = [super init]) {
        [self loadTexture];
        [self initMenuItem];
    }
    return self;
}

- (void)loadTexture
{
    // 获得设备的scale：
    scale_screen = [UIScreen mainScreen].scale;
    
	// ask director for the window size
	size = [[CCDirector sharedDirector] winSize];
    
    CCSprite *bg = [CCSprite spriteWithFile:@"llk_hd_bg.jpg"];
    bg.position = ccp(size.width/2, size.height/2);
    bg.scale = scale_screen;
    [self addChild:bg];
}

- (void)initMenuItem
{
    //返回按钮。。
    CCMenuItemFont *item_back = [CCMenuItemFont itemWithString:@"goBack" target:self selector:@selector(returnMain)];
    CCMenu *menu_back = [CCMenu menuWithItems:item_back, nil];
    menu_back.position = ccp(size.width/2, 100);
    [self addChild:menu_back];
    
    CCMenuItemToggle *item1 = [CCMenuItemToggle itemWithTarget:self selector:@selector(choose:) items:[CCMenuItemImage itemWithNormalImage:@"llk_hd_lv1.png" selectedImage:@"llk_hd_lv1.png"],[CCMenuItemImage itemWithNormalImage:@"llk_hd_lv_lock.png" selectedImage:@"llk_hd_lv_lock.png"], nil];
    item1.scale = scale_screen;
    item1.selectedIndex = 0;
    CCMenu *menu_items = [CCMenu menuWithItems:item1, nil];
    menu_items.position = ccp(size.width/2, size.height*2/3);
    [self addChild:menu_items];
    
}

- (void)choose:(id)sender
{
  
    if ([sender selectedIndex] == 0) {
        [sender setSelectedIndex:1];
    }else{
        [sender setSelectedIndex:0];
        [MusicHandler notify_item_click];
        [SceneManager goGameLayer];
    }
}

- (void)returnMain
{
    [MusicHandler notify_item_click];
    [SceneManager goMainPage];
}

@end
