//
//  CDPosition.m
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import "CDPosition.h"

@implementation CDPosition

- (instancetype)initWithRow:(int)row andCol:(int)col {
    if (self = [super init]) {
        self.row = row;
        self.col = col;
    }
    return self;
}

@end
