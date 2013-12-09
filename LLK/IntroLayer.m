//
//  IntroLayer.m
//  LLK
//
//  Created by hongjun guo on 12-12-18.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "MusicHandler.h"
#import "SceneManager.h"
#import "LLK_Choose_Level_Layer.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

    // 得到当前屏幕的尺寸：
    //CGRect rect_screen = [[UIScreen mainScreen]bounds];
    //CGSize size_screen = rect_screen.size;
    
    // 获得设备的scale：
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"Default.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"llk_hd_bg.jpg"];
        background.scale = scale_screen;
	}
	background.position = ccp(size.width/2, size.height/2);

	// add the label as a child to this Layer
	[self addChild: background];
    
    //add the logosprite as a child to this layer
    CCSprite *logo;
    
    logo = [CCSprite spriteWithFile:@"llk_hd_logo.png"];
    //logo.scale = scale_screen;
    
    logo.position = ccp(size.width/2, 809.0f);
    
    [self addChild:logo];
    
    //add the description label as a child of this label
    
    CCLabelTTF *lbDescrip = [CCLabelTTF labelWithString:NSLocalizedString(@"GOOD_DESCRIPTION", nil) fontName:@"Marker Felt" fontSize:20];
    
    lbDescrip.position =  ccp(size.width /2 , 634.0f);
	[self addChild: lbDescrip];
    
    [lbDescrip setColor:ccGREEN];
    
    //add menuItems to this layer...
    [CCMenuItemFont setFontSize:40];
    [CCMenuItemFont setFontName:@"Marker Felt"];
    
    CCMenuItemFont *primaryItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"BEGIN", nil) target:self selector:@selector(primaryAction:)];
    //    CCMenuItemFont *newgameItem = [CCMenuItemFont itemWithString:@"New game"];
    CCMenuItemFont *juniorItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"JUNIOR", nil) target:self selector:@selector(juniorAction:)];
    CCMenuItemFont *seniorItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"SENIOR", nil) target:self selector:@selector(seniorAction:)];
    
    CCMenu *menu_level = [CCMenu menuWithItems:primaryItem,juniorItem,seniorItem, nil];
    menu_level.position = ccp(size.width/2, 400.0f);
    [menu_level alignItemsVerticallyWithPadding:50];
    
    for( CCNode *child in [menu_level children] ) {
        NSAssert([child isKindOfClass:[CCMenuItemFont class]],@"child is not CCMenuItemFontClass");
        [(CCMenuItemFont *)child setColor:ccc3(255, 0, 0)];
    }
    
    int i=0;
    for( CCNode *child in [menu_level children] ) {
        CGPoint dstPoint = child.position;
        int offset = size.width/2 + 100;
        if( i % 2 == 0)
            offset = -offset;
        child.position = ccp( dstPoint.x + offset, dstPoint.y);//first set the position
        [child runAction:
         [CCEaseElasticOut actionWithAction:
          [CCMoveBy actionWithDuration:2 position:ccp(dstPoint.x - offset,0)]
                                     period: 0.25f]
         ]; // next change the position;
        
        i++;
    }
    
    [self addChild:menu_level];
    
    //another menuItems...
    
    CCMenuItemToggle *volumeItem = [CCMenuItemToggle itemWithTarget:self selector:@selector(volumeAction:) items:[CCMenuItemImage itemWithNormalImage:@"llk_hd_volume_on.png" selectedImage:@"llk_hd_volume_on.png"],[CCMenuItemImage itemWithNormalImage:@"llk_hd_volume_off.png" selectedImage:@"llk_hd_volume_off.png"], nil];
    volumeItem.selectedIndex = 0;
    CCMenuItemFont *highScoreItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"HIGHSCORE", nil) target:self selector:@selector(highestScoreAction:)];
    CCMenuItemFont *helpItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"HELP", nil) target:self selector:@selector(helpAction:)];
    CCMenuItemFont *exitItem = [CCMenuItemFont itemWithString:NSLocalizedString(@"EXIT", nil) target:self selector:@selector(exitAction:)];
    
    CCMenu *menu_setting = [CCMenu menuWithItems:volumeItem,highScoreItem,helpItem,exitItem, nil];
    menu_setting.position = ccp(size.width/2, 100.0f);
    [menu_setting alignItemsHorizontallyWithPadding:65];
    
    for( CCNode *child in [menu_setting children] ) {
        //NSAssert([child isKindOfClass:[CCMenuItemFont class]],@"child is not CCMenuItemFontClass");
        if([child isKindOfClass:[CCMenuItemFont class]])
        {
            [(CCMenuItemFont *)child setColor:ccc3(255, 0, 0)];
        }
    }
    
    [self addChild:menu_setting];
    
}

- (void)primaryAction:(id)sender
{
    CCLOG(@"%s",__FUNCTION__);
    [MusicHandler notify_item_click];
    
    [SceneManager goChooseLevel];
}

- (void)juniorAction:(id)sender
{
    CCLOG(@"%s",__FUNCTION__);
    [MusicHandler notify_item_click];
    [SceneManager goChooseLevel];

}

- (void)seniorAction:(id)sender
{
    CCLOG(@"%s",__FUNCTION__);
    [MusicHandler notify_item_click];
    [SceneManager goChooseLevel];

}

- (void)volumeAction:(id)sender
{
    CCLOG(@"%s",__FUNCTION__);
}

- (void)highestScoreAction:(id)sender
{
    CCLOG(@"%s",__FUNCTION__);
    [MusicHandler notify_item_click];  //后边可以分出来 ，看是不是已经设定没有声音了，如果是这样就不发通知了。
}

- (void)helpAction:(id)sender
{
    CCLOG(@"%s",__FUNCTION__);
    [MusicHandler notify_item_click];
}

-(void)exitAction:(id)sender
{
    CCLOG(@"%s",__FUNCTION__);
    [MusicHandler notify_item_click];
    CCLOG(@"你真的要退出么？");
}

@end
