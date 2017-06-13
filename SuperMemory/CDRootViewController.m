//
//  CDRootViewController.m
//  day082001
//
//  Created by LUOHao on 15/8/20.
//  Copyright (c) 2015年 jackfrued. All rights reserved.
//

#import "CDRootViewController.h"
#import "CDMemoryGame.h"
#import "CDGameDelegate.h"
#import "CDGameContext.h"
#import "CDRecordViewController.h"
#import "CDRecord.h"

#ifndef W_H_
#define W_H_
#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#endif

@interface CDRootViewController () <CDGameDelegate> {
    UIButton *nextRoundButton;  // 下一关按钮
    BOOL isNextRoundLocked;     // 下一关是否被锁定
    CDMemoryGame *game;         // 记忆力游戏对象
    int round;                  // 第几关
    int totalTime;              // 总共花费的时间
    NSMutableArray *recordsArray;   // 保存游戏记录的数组
}

@end

@implementation CDRootViewController

// 实现协议中的刷新用户界面的方法
- (void) refreshUI {
    [game draw:self.view];
}

// 实现协议中的允许进入下一关的方法
- (void)allowNextRound {
    totalTime += [CDGameContext sharedInstance].interval;
    if (round < 4) {
        isNextRoundLocked = NO;
    }
    else {
        // 判断是否创造新纪录并显示排行榜
        if ([self judgeForNewRecord]) {
            UIAlertController *inputAlertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"总时间: %d秒!\n您打破了记录, 名字将载入记忆英雄榜!", totalTime] preferredStyle:UIAlertControllerStyleAlert];
            [inputAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"请输入您的名字";
                textField.returnKeyType = UIReturnKeyDone;
            }];
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                UITextField *nameField = [inputAlertController.textFields firstObject];
                NSString *name = [nameField.text isEqualToString:@""]? @"佚名" : nameField.text;
                CDRecord *newRecord = [[CDRecord alloc] initWithName:name andScore:totalTime];
                [recordsArray removeLastObject];
                [recordsArray addObject:newRecord];
                [recordsArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    CDRecord *record1 = obj1;
                    CDRecord *record2 = obj2;
                    return record1.score > record2.score;
                }];
                [self saveRecords];
            }];
            [inputAlertController addAction:doneAction];
            [self presentViewController:inputAlertController animated:YES completion:nil];
        }
        else {
            [self showAlertWithInfo:[NSString stringWithFormat:@"总时间: %d秒!", totalTime]];
        }
        SEL selectors[2] = { @selector(nextRoundButtonClicked:), @selector(restartGameButtonClicked:) };
        [self resetButton:nextRoundButton WithTitle:@"重新开始" andSelectors:selectors];
    }
}

// 判断是否创造新纪录
- (BOOL) judgeForNewRecord {
    CDRecord *lastRecord = [recordsArray lastObject];
    return totalTime < lastRecord.score;
}

// 开始新的游戏
- (void) startNewGame {
    // 关卡从第一关开始
    round = 1;
    // 下一关锁定(完成本关之后才能进入下一关)
    isNextRoundLocked = YES;
    // 总时间归零
    totalTime = 0;
    // 加载关卡
    [self loadNextRoundGame];
}

// 点击下一关按钮的回调方法
- (void) nextRoundButtonClicked:(UIButton *) sender {
    if (isNextRoundLocked) {
        [self showAlertWithInfo:@"请先完成当前关卡"];
    }
    else {
        round += 1;
        [self loadNextRoundGame];
    }
}

// 点击排行榜按钮的回调方法
- (void) recordButtonClicked:(UIButton *) sender {
    CDRecordViewController *recordVC = [[CDRecordViewController alloc] init];
    recordVC.records = recordsArray;
    [self presentViewController:recordVC animated:YES completion:nil];
}

// 点击重新开始按钮的回调方法
- (void) restartGameButtonClicked:(UIButton *) sender {
    [self startNewGame];
    SEL selectors[2] = {@selector(restartGameButtonClicked:), @selector(nextRoundButtonClicked:)};
    [self resetButton:sender WithTitle:@"下一关" andSelectors:selectors];
}

// 改变按钮的状态
- (void) resetButton:(UIButton *) button WithTitle:(NSString *) title andSelectors:(SEL[]) selectors {
    [button setTitle:title forState:UIControlStateNormal];
    [button removeTarget:self action:selectors[0] forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:selectors[1] forControlEvents:UIControlEventTouchUpInside];
}

// 显示警告消息
- (void) showAlertWithInfo:(NSString *) info {
    // 判断iOS系统的版本
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:info preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.delegate = self;
        [alertView show];
    }
}

// 加载新关卡
- (void) loadNextRoundGame {
    isNextRoundLocked = YES;
    [game reset:round * 2];
    [self refreshUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    BOOL hasRecords = [userDef boolForKey:@"has_records"];
    
    recordsArray = [NSMutableArray array];
    
    if (!hasRecords) {
        for (int i = 0; i < 5; i++) {
            CDRecord *record = [[CDRecord alloc] initWithName:@"佚名" andScore:999];
            [recordsArray addObject:record];
        }
        [self saveRecords];
        [userDef setBool:YES forKey:@"has_records"];
    }
    else {
        [self loadRecords];
    }
    
    self.view.backgroundColor = [CDGameContext randomLightColor];
    
    nextRoundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextRoundButton.frame = CGRectMake(0, 0, WIDTH / 2, 40);
    nextRoundButton.center = CGPointMake(WIDTH / 2, HEIGHT - 80);
    nextRoundButton.layer.borderColor = [UIColor blackColor].CGColor;
    nextRoundButton.layer.borderWidth = 1;
    nextRoundButton.layer.cornerRadius = 5;
    [nextRoundButton setTitle:@"下一关" forState:UIControlStateNormal];
    [nextRoundButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextRoundButton.titleLabel.font = [UIFont systemFontOfSize:28];
    [nextRoundButton addTarget:self action:@selector(nextRoundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextRoundButton];
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame = CGRectMake(0, 0, WIDTH / 2, 40);
    recordButton.center = CGPointMake(WIDTH / 2, HEIGHT - 30);
    recordButton.layer.borderColor = [UIColor blackColor].CGColor;
    recordButton.layer.borderWidth = 1;
    recordButton.layer.cornerRadius = 5;
    [recordButton setTitle:@"排行榜" forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    recordButton.titleLabel.font = [UIFont systemFontOfSize:28];
    [recordButton addTarget:self action:@selector(recordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordButton];
    
    // 由于视图控制器遵循协议所以可以作为每个方块对象的委托
    // 负责在方块翻转的时候刷新用户界面显示方块翻转后的效果
    game = [[CDMemoryGame alloc] initWithDelegate:self];
    
    [self startNewGame];
}

- (void) saveRecords {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < recordsArray.count; i++) {
        CDRecord *record = recordsArray[i];
        [userDef setObject:record.name forKey:[NSString stringWithFormat:@"name%d", i]];
        [userDef setInteger:record.score forKey:[NSString stringWithFormat:@"score%d", i]];
    }
}

- (void) loadRecords {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < 5; i++) {
        NSString *name = [userDef objectForKey:[NSString stringWithFormat:@"name%d", i]];
        NSInteger score = [userDef integerForKey:[NSString stringWithFormat:@"score%d", i]];
        [recordsArray addObject:[[CDRecord alloc] initWithName:name andScore:score]];
    }
}

// 不允许自动旋转屏幕
- (BOOL)shouldAutorotate {
    return NO;
}

@end
