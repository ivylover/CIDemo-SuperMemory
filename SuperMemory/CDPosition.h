//
//  CDPosition.h
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import <Foundation/Foundation.h>

/**方块的位置*/
@interface CDPosition : NSObject

@property (nonatomic, assign) int row;  // 行
@property (nonatomic, assign) int col;  // 列

- (instancetype)initWithRow:(int) row andCol:(int) col;

@end
