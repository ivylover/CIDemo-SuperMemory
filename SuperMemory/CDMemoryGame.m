//
//  CDMemoryGame.m
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import "CDMemoryGame.h"
#import "CDImageSquare.h"
#import "CDPosition.h"
#import "CDGameContext.h"

@implementation CDMemoryGame

- (instancetype) initWithDelegate:(id<CDGameDelegate>)delegate {
    if (self = [super init]) {
        squareDelegate = delegate;
    }
    return self;
}

- (void)reset:(int) size {
    if (size % 2 != 0) {
        @throw [NSException exceptionWithName:@"CDMemoryGame" reason:@"游戏的方块数必须是偶数" userInfo:nil];
    }

    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:size * size];
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            [tempArray addObject:[[CDPosition alloc] initWithRow:i andCol:j]];
        }
    }
    NSArray *posArray = [tempArray copy];
    
    if (squares) {
        for (CDImageSquare *square in squares) {
            [square removeFromSuperview];
        }
    }
    squares = [NSMutableArray arrayWithCapacity:size * size];
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            CDImageSquare *square = [[CDImageSquare alloc] initWithRow:i Col:j Value:0 Size:size];
            square.delegate = squareDelegate;
            [squares addObject:square];
        }
    }
    NSMutableArray *mArray = [posArray mutableCopy];
    NSInteger upperBounds = [CDGameContext sharedInstance].imagesDict.count;
    for (int i = 0; i < size * size / 2; i++) {
        int num = arc4random() % upperBounds + 1;
        for (int j = 0; j < 2; j++) {
            int index = arc4random() % mArray.count;
            CDPosition *pos = mArray[index];
            [mArray removeObjectAtIndex:index];
            CDImageSquare *square = squares[pos.row * size +pos.col];
            square.value = num;
        }
    }
    
    CDGameContext *ctx = [CDGameContext sharedInstance];
    
    ctx.totalCoupleCount = size * size / 2;
    ctx.finishedCoupleCount = 0;
    ctx.isFirstHit = YES;
}

- (void)draw:(UIView *)parentView {
    for (CDImageSquare *square in squares) {
        [square draw:parentView];
    }
}

@end
