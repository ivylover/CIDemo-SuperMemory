//
//  CDMemoryGame.h
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CDGameDelegate.h"

@class CDImageSquare;

@interface CDMemoryGame : NSObject {
    NSMutableArray *squares;
    id<CDGameDelegate> squareDelegate;
}

- (instancetype) initWithDelegate:(id<CDGameDelegate>) delegate;

/**重置游戏*/
- (void) reset:(int) size;

/**绘制游戏场景*/
- (void) draw:(UIView *)parentView;


@end
