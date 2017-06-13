//
//  CDRecord.m
//  day082001
//
//  Created by LUOHao on 15/10/24.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import "CDRecord.h"

@implementation CDRecord

- (instancetype)initWithName:(NSString *)name andScore:(NSUInteger)score {
    if (self = [super init]) {
        _name = name;
        _score = score;
    }
    
    return self;
}

@end
