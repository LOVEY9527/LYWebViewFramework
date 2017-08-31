//
//  LYIOSWebManager.h
//  LYWebViewTest
//
//  Created by 李勇 on 2017/8/28.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol LYIOSWebManagerExport <JSExport>

/**
 初始化接口
 
 @return 初始化字符串
 */
- (NSString *)webInit;

/**
 登录接口
 */
- (void)login;

/**
 分享
 */
- (void)share;

@end

@interface LYIOSWebManager : NSObject<LYIOSWebManagerExport>

@end
