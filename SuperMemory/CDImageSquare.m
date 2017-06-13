//
//  CDSquare.m
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import "CDImageSquare.h"
#import "CDGameContext.h"

#define UNIT_MARGIN 4
#define LEFT_MARGIN 20
#define RIGHT_MARGIN 20

@implementation CDImageSquare

- (instancetype)initWithRow:(int)row Col:(int)col Value:(int)value Size:(int)size {
    // 创建视图对象并设置位置和尺寸(位置和尺寸通过size属性动态计算)
    if (self = [super init]) {
        self.value = value;
        CGRect rect = [UIScreen mainScreen].bounds;
        int unitSizeWithMargin = (rect.size.width - LEFT_MARGIN - RIGHT_MARGIN) / size;
        int unitSize = unitSizeWithMargin - UNIT_MARGIN;
        int top = (rect.size.height - unitSizeWithMargin * size) / 2;
        int left = LEFT_MARGIN + UNIT_MARGIN;
        
        self.frame = CGRectMake(left + unitSizeWithMargin * col, top + unitSizeWithMargin * row, unitSize, unitSize);
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)turnOver {
    self.isTurnedOver = YES;
    // 当有方块翻转的时候通过委托刷新界面
    [self.delegate refreshUI];
    
    CDGameContext *ctx = [CDGameContext sharedInstance];
    if (!ctx.turnedOne) {
        ctx.turnedOne = self;
    }
    else {
        ctx.turnedTwo = self;
        // 如果两个方块值相同则消掉
        if(ctx.turnedOne.value == ctx.turnedTwo.value) {
            ctx.turnedOne.isErased = YES;
            ctx.turnedTwo.isErased = YES;
            ctx.finishedCoupleCount += 1;
            if (ctx.totalCoupleCount == ctx.finishedCoupleCount) {
                ctx.endTime = [NSDate date];
                ctx.interval = [ctx.endTime timeIntervalSinceDate:ctx.startTime];
                [self.delegate allowNextRound];
            }
            // 延迟0.31秒播放声音
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                usleep(310000);
                [CDGameContext playSoundEffect:@"couple.caf" withCallback:nil];
            });
        }
        else {  // 如果两个方块值不同就翻转回去
            ctx.turnedOne.isTurnedOver = NO;
            ctx.turnedTwo.isTurnedOver = NO;
            // 延迟0.62秒显示两个方块翻转回去之后的效果
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                usleep(620000);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate refreshUI];
                });
            });
        }
        ctx.turnedOne = nil;
        ctx.turnedTwo = nil;
    }
}

// 点中方块
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.isTurnedOver) {
        CDGameContext *ctx = [CDGameContext sharedInstance];
        // 如果是第一次点击就记录下时间(游戏开始时间)
        if (ctx.isFirstHit) {
            ctx.startTime = [NSDate date];
            ctx.isFirstHit = NO;
        }
        // 设置3D翻转方块的动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
        [UIView commitAnimations];
        // 将方块翻转过来
        [self turnOver];
    }
}

// 将ImageView从当前视图上移除
- (void) clearImageView {
    UIImageView *imageView = [[self subviews] lastObject];
    if(imageView) {
        [imageView removeFromSuperview];
    }
}

- (void)draw:(UIView *)parentView {
    if(!self.isErased) {    // 如果方块没有消掉就要清除上面的图(显示背面)
        [self clearImageView];
    }
    if (self.isTurnedOver) {    // 翻转的方块要画图(显示正面)
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.bounds;
        imageView.image = [CDGameContext keyForImage:self.value];;
        // 将图画在方块对应的视图上
        [self addSubview:imageView];
    }
    // 将方块添加到父视图中
    [parentView addSubview:self];
}

@end
