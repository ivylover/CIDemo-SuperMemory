//
//  CDRecord.h
//  day082001
//
//  Created by LUOHao on 15/10/24.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import <Foundation/Foundation.h>

/**游戏记录*/
@interface CDRecord : NSObject

/**创造纪录的人*/
@property (nonatomic, copy) NSString *name;
/**成绩*/
@property (nonatomic, assign) NSUInteger score;

- (instancetype) initWithName:(NSString *)name andScore:(NSUInteger) score;

@end
