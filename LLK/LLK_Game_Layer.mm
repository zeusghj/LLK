//
//  LLK_Game_Layer.m
//  LLK
//
//  Created by guohongjun on 12-12-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LLK_Game_Layer.h"
#import "MusicHandler.h"
#import "SceneManager.h"
#include "DataCenter.h"


extern CELL_LIST g_list[NUMBER];

extern PERF g_perf_s;


@interface LLK_Game_Layer ()
{
    CGFloat scale_screen;
    CGSize size;
}

@end

@implementation LLK_Game_Layer

- (id)init
{
    if (self = [super init]) {
        [self loadTexture];
        [self initMenuItem];
        [self initData];
    }
    return self;
}

- (void)loadTexture
{
    // 获得设备的scale：
    scale_screen = [UIScreen mainScreen].scale;
    
	// ask director for the window size
	size = [[CCDirector sharedDirector] winSize];
    
    CCSprite *bg = [CCSprite spriteWithFile:@"llk_hd_game_bg.jpg"];
    bg.position = ccp(size.width/2, size.height/2);
    bg.scale = scale_screen;
    [self addChild:bg];
}

- (void)initMenuItem
{
    //返回按钮。。
    CCMenuItemFont *item_back = [CCMenuItemFont itemWithString:@"goBack" target:self selector:@selector(returnLastPage)];
    CCMenu *menu_back = [CCMenu menuWithItems:item_back, nil];
    menu_back.position = ccp(size.width/2, 100);
    [self addChild:menu_back];
}

- (void)initData
{
    int column1,row1;
    int column2,row2;
    int ret;
    int check_flag = 1;
    
    int die_life = 0;
    int scenario;
    
    int total_resolve = 0;
    
    CELL_NODE *hint_first, *hint_second;
    PATH hint_path;
    
    CELL_NODE *in_first, *in_second;
    PATH in_path;

    PATH *temp_path;
    
    
    
    
    
    DataCenter *center = new DataCenter;
    
    CELL_NODE *g_cell = center->g_cell;
    
    g_cell = (CELL_NODE *)calloc((WIDTH+2)*(HEIGHT+2), sizeof(CELL_NODE));
    
    scenario = 0;
    
    while (scenario < 9) {
        center->init_rand_seed();
        center->init_new_game(scenario);
        center->refresh_game_scene(NULL, NULL);
        total_resolve = 0;
        check_flag = 1;
        die_life = 0;
        
        while (1) {
            while (check_flag) {  //让此时的状态是不死锁的。    
                ret = center->check_die(&hint_path); //在检查死锁的时候就已经生成了路径。
                if (ret == NO_CONNECT) {  //此时已经无法连接了,表明死锁了。
                    printf("\n Deadlock , need reproduce_game \n");
                    center->reproduce_game();
                    center->refresh_game_scene(NULL, NULL);
                    die_life++;
                }else{
                    check_flag = 0;
                }
            }
            
            hint_first = hint_path.start;
            hint_second = hint_path.end;
            
            
        }
    }
    
}

- (void)returnLastPage
{
    [MusicHandler notify_item_click];
    [SceneManager goChooseLevel];
}

@end
