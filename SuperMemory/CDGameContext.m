//
//  CDGameContext.m
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import "CDGameContext.h"

@implementation CDGameContext

- (instancetype)init {
    @throw [NSException exceptionWithName:@"CDGameContext" reason:@"不允许创建CDGameContext类的对象" userInfo:nil];
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        self.isFirstHit = YES;
        // 用一个键值对映射存储图片
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        for (int i = 1; i <= 12; i++) {
            NSString *str = [NSString stringWithFormat:@"%d", i];
            [mDict setObject:[UIImage imageNamed:str] forKey:str];
        }
        self.imagesDict = [mDict copy];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static CDGameContext *instance = nil;
    // 使用GCD创建单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] initPrivate];
        }
    });
    return instance;
}

+ (UIImage *) keyForImage:(int) key {
    return [[[self sharedInstance] imagesDict] valueForKey:[NSString stringWithFormat:@"%d", key]];
}

+ (void)playSoundEffect:(NSString *)name withCallback:(void (*)(SystemSoundID, void *)) callback {
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID;
    // 在系统中创建一个音效对象并获得其唯一ID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    // 注册在播放完之后执行的回调函数
    // 第二个和第三个参数跟循环播放有关
    // 第五个参数是指向传给回调函数的数据的指针
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, callback, NULL);
    // 播放音效
    // AudioServicesPlaySystemSound(soundID);
    // 播放音效并震动
    AudioServicesPlayAlertSound(soundID);
}

+ (UIColor *) randomLightColor {
    return [self randomLightColorWithAlpha:1];
}

+ (UIColor *) randomLightColorWithAlpha:(double) alpha {
    CGFloat red = (arc4random() % 128 + 128)/ 255.0;
    CGFloat green = (arc4random() % 128 + 128) / 255.0;
    CGFloat blue = (arc4random() % 128 + 128) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end
