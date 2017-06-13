//
//  CDRefreshDelegate.h
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import <Foundation/Foundation.h>

/**记忆力游戏协议*/
@protocol CDGameDelegate <NSObject>

/**刷新用户界面*/
- (void) refreshUI;

/**授权进入下一轮*/
- (void) allowNextRound;

@end
