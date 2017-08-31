//
//  LYWebViewController.h
//  LYWebViewTest
//
//  Created by 李勇 on 2017/8/29.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYWebView.h"

@protocol LYWebViewControllerDelegate;

@interface LYWebViewController : UIViewController

@property (assign, nonatomic, nullable) id<LYWebViewControllerDelegate> delegate;

/**
 初始化方法

 @param navigationBarHidden 是否隐藏导航栏
 @return 初始化的对象
 */
- (id _Nullable )initWithNavigationBarHidden:(BOOL)navigationBarHidden;

/**
 注册brigde(前端映射变量名为默认的brigdeIosValue)
 
 @param bridge 桥联对象
 */
- (void)registerBridge:(id<JSExport> _Nonnull)bridge;

/**
 注册bridge桥接对象
 
 @param bridge iOS原生中与前端映射的桥接对象
 @param bridgeValue 前端中与原生桥接对象映射的变量名
 */
- (void)registerBridge:(id<JSExport> _Nonnull)bridge forBridgeValue:(NSString * _Nonnull)bridgeValue;

/**
 加载url
 
 @param urlString url字符串
 @param navigationTitle 导航栏标题
 @param shouldShow 是否显示loading框
 */
- (void)loadURLString:(NSString *_Nonnull)urlString navigationTitle:(NSString *_Nullable)navigationTitle shouldShowActivityIndicator:(BOOL)shouldShow;

/**
 加载本地html文件
 
 @param urlString 本地html文件路径
 @param navigationTitle 导航栏标题
 @param shouldShow 是否显示loading框
 */
- (void)loadLocalURLString:(NSString *_Nonnull)urlString navigationTitle:(NSString *_Nullable)navigationTitle shouldShowActivityIndicator:(BOOL)shouldShow;

/**
 加载javascript字符串
 
 @param javaScriptString javascript字符串
 */
- (void)loadJavaScriptString:(NSString *_Nonnull)javaScriptString shouldShowActivityIndicator:(BOOL)shouldShow;

@end

@protocol LYWebViewControllerDelegate <NSObject>

- (void)webViewController:(LYWebViewController *_Nonnull)webViewController webViewDidStartLoad:(LYWebView *_Nonnull)webView;
- (void)webViewController:(LYWebViewController *_Nonnull)webViewController webViewDidFinishLoad:(LYWebView *_Nonnull)webView;
- (void)webViewController:(LYWebViewController *_Nonnull)webViewController webView:(LYWebView *_Nonnull)webView didFailLoadWithError:(NSError *_Nullable)error;

@end
