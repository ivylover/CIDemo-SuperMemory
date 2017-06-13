   //
//  CDRecordViewController.m
//  day082001
//
//  Created by LUOHao on 15/10/23.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import "CDRecordViewController.h"
#import "CDGameContext.h"
#import "CDRecord.h"

#ifndef W_H_
#define W_H_
#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#endif

#define RECORD_NUM 5

@interface CDRecordViewController ()

@end

@implementation CDRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [CDGameContext randomLightColor];
    
    int unitHeight = (HEIGHT - 100) / (RECORD_NUM + 2);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, WIDTH -100, unitHeight)];
    label.text = @"记忆英雄榜";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:36];
    
    [self.view addSubview:label];
    
    // 用5个UIView分别显示1-5名的名字和成绩
    for (int i = 1; i <= 5; i++) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(50, 50 + (unitHeight + 5) * i, WIDTH - 100, unitHeight)];
        topView.backgroundColor = [CDGameContext randomLightColor];
        
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, topView.bounds.size.width, (int)(topView.bounds.size.height / 2))];
        topLabel.text = [NSString stringWithFormat:@"第%d名", i];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.font = [UIFont systemFontOfSize:22];
        [topView addSubview:topLabel];
        UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (int)(topView.bounds.size.height / 2), topView.bounds.size.width, (int)(topView.bounds.size.height / 2))];
        CDRecord *currentRecord = _records[i - 1];
        scoreLabel.text = [NSString stringWithFormat:@"%@: %lu秒", currentRecord.name, (unsigned long)currentRecord.score];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.font = [UIFont systemFontOfSize:20];
        scoreLabel.adjustsFontSizeToFitWidth = YES;
        [topView addSubview:scoreLabel];
        
        [self.view addSubview:topView];
    }
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, WIDTH / 2, 40);
    returnButton.center = CGPointMake(WIDTH / 2, HEIGHT - 50);
    returnButton.layer.borderColor = [UIColor blackColor].CGColor;
    returnButton.layer.borderWidth = 1;
    returnButton.layer.cornerRadius = 5;
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    returnButton.titleLabel.font = [UIFont systemFontOfSize:28];
    [returnButton addTarget:self action:@selector(returnButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton];
}

- (void) returnButtonClicked:(UIButton *) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
