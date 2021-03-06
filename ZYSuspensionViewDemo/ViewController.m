//
//  ViewController.m
//  ZYSuspensionViewDemo
//
//  Created by ripper on 16/8/22.
//  Copyright © 2016年 ripper. All rights reserved.
//

#import "ViewController.h"
#import "ZYSuspensionView.h"
#import "ZYTestManager.h"

@interface ViewController ()<ZYSuspensionViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /** ********** 测试用例1: 悬浮球配合测试工具使用 ********** */
    
    [self suspensionViewWithTestManagerExample];
    
    
    
    
    /** ********** 测试用例2: 仅仅创建一个悬浮球 ********** */
    
    [self suspensionViewExample];
}

#pragma mark - 悬浮球 + 测试组件
- (void)suspensionViewWithTestManagerExample
{
    // ZYTestManager 所有方法，在 release 模式下自动屏蔽，发布上线不会受到影响
    
    // 显示一个默认的悬浮球
    [ZYTestManager showSuspensionView];
    
    // 设置常驻的测试条目
    NSArray *baseArray = @[
                           @{
                               kTestTitleKey: @"item1",
                               kTestAutoCloseKey: @YES,
                               kTestActionKey: ^{
                                   NSLog(@"click item1 : do something ~~~~~");
                               }
                               },
                           @{
                               kTestTitleKey:@"item2",
                               kTestAutoCloseKey: @NO,
                               kTestActionKey:^{
                                   NSLog(@"click item2 : do something ~~~~~");
                               }
                               },
                           ];
    
    [ZYTestManager setupTestItemPermanentArray:baseArray];

    
    // 添加一个测试条目 (注意blcok的引用问题，如果需要在block中使用self，最好传入__weak)
    [ZYTestManager addTestItemWithTitle:@"new item" autoClose:YES action:^{
        NSLog(@"click new item : do something ~~~~~~~~~~");
    }];
    
    [ZYTestManager addTestItemWithTitle:@"new item2" autoClose:NO action:^{
        NSLog(@"click new item2 : do something ~~~~~~~~~~");
        
        Class VCClass = NSClassFromString(@"SomeViewController");
        if (VCClass && [VCClass isSubclassOfClass:[UIViewController class]]) {
            UIViewController *vc = [VCClass new];
            [[ZYTestManager shareInstance].testTableViewController presentViewController:vc animated:YES completion:nil];
        }
    }];
}

#pragma mark - 悬浮球
- (void)suspensionViewExample
{
    // 仅仅创建一个悬浮球，自行实现点击的代理方法
    
    UIColor *color = [UIColor colorWithRed:0.50f green:0.89f blue:0.31f alpha:1.00f];
    ZYSuspensionView *sus2 = [[ZYSuspensionView alloc] initWithFrame:CGRectMake(- 50.0 / 6, 200, 50, 50)
                                                               color:color
                                                            delegate:self];
    sus2.leanType = ZYSuspensionViewLeanTypeEachSide;
    [sus2 setTitle:@"测试2" forState:UIControlStateNormal];
    [sus2 show];
}


#pragma mark - ZYSuspensionViewDelegate
- (void)suspensionViewClick:(ZYSuspensionView *)suspensionView
{
    NSLog(@"click %@",suspensionView.titleLabel.text);
}


@end
