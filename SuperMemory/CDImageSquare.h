//
//  CDSquare.h
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CDGameDelegate.h"

@class CDSquareView;

/**游戏中的图片方块*/
@interface CDImageSquare : UIView

/**值*/
@property (nonatomic, assign) int value;
/**是否被翻转*/
@property (nonatomic, assign) BOOL isTurnedOver;
/**是否被消除*/
@property (nonatomic, assign) BOOL isErased;

// 通过该指针指向被委托方由被委托方负责刷新用户界面
// 该指针实际上指向了根视图控制器由根视图控制器负责刷新界面
@property (nonatomic, weak) id<CDGameDelegate> delegate;

/**构造方法(初始化方法)*/
- (instancetype)initWithRow:(int) row Col:(int) col Value:(int) value Size:(int)size;

/**翻转*/
- (void) turnOver;

/**绘制*/
- (void) draw:(UIView *) parentView;

@end
