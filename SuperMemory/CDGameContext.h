//
//  CDGameContext.h
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CDImageSquare;

/**游戏上下问环境类(单例类专门保存被翻转的两个方块)*/
@interface CDGameContext : NSObject

@property (nonatomic, strong) NSDictionary *imagesDict;
/**选中的第一个方块*/
@property (nonatomic, strong) CDImageSquare *turnedOne;
/**选中的第二个方块*/
@property (nonatomic, strong) CDImageSquare *turnedTwo;
/**游戏开始时间(点击第一个方块的时刻)*/
@property (nonatomic, strong) NSDate *startTime;
/**游戏结束时间(完成最后一组方块消除的时刻)*/
@property (nonatomic, strong) NSDate *endTime;
/**总共有多少组待消除的方块*/
@property (nonatomic, assign) int totalCoupleCount;
/**当前完成消除了多少组方块*/
@property (nonatomic, assign) int finishedCoupleCount;
/**是不是第一次点击游戏方块*/
@property (nonatomic, assign) BOOL isFirstHit;
/**完成当前关卡花费的时间*/
@property (nonatomic, assign) NSTimeInterval interval;

+ (instancetype) sharedInstance;

/**根据数值获得对应的UIImage对象*/
+ (UIImage *) keyForImage:(int) key;

/**获得随机颜色(偏浅色)*/
+ (UIColor *) randomLightColor;

/**获得指定透明度的随机颜色(偏浅色)*/
+ (UIColor *) randomLightColorWithAlpha:(double) alpha;

/**播放音效*/
+ (void)playSoundEffect:(NSString *)name withCallback:(void (*)(SystemSoundID, void *)) callback;

@end
