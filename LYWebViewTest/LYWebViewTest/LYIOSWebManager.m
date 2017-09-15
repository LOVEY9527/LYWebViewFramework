//
//  LYIOSWebManager.m
//  LYWebViewTest
//
//  Created by 李勇 on 2017/8/28.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYIOSWebManager.h"

@implementation LYIOSWebManager

- (void)dealloc
{
    NSLog(@"manager dealloc");
}

/**
 初始化接口
 
 @return 初始化字符串
 */
- (NSString *)webInit
{
    return @"webInit";
}

/**
 登录接口
 */
- (void)login
{
    NSLog(@"login");
}

/**
 分享
 */
- (void)share
{
    NSLog(@"分享");
}

@end
