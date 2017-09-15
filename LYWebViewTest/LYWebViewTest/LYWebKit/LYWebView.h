//
//  LYWebView.h
//  LYWebViewTest
//
//  Created by 李勇 on 2017/8/28.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface NSString (Category)

/**
 字符串UTF-8编码
 
 @return 编码后的字符串
 */
- (nullable NSString *)customEncodingString;

@end

@interface NSURL (Category)

/**
 网址字符串转为可加载的url(主要针对有汉字的网址字符串)
 
 @param URLString url字符串
 @return url
 */
+ (nullable NSURL *)customURLWithString:(nonnull NSString *)URLString;

@end

@protocol LYWebViewDelegate;

@interface LYWebView : UIView

@property (assign, nonatomic, nullable) id <LYWebViewDelegate> delegate;

/**
 注册brigde(前端映射变量名为默认的brigdeIosValue)

 @param bridge 桥接对象
 */
- (void)registerBridge:(id <JSExport> _Nonnull)bridge;

/**
 注册brigde
 
 @param bridge iOS原生中与前端映射的桥接对象
 @param bridgeValue 前端中与原生桥接对象映射的变量名
 */
- (void)registerBridge:(id<JSExport> _Nonnull)bridge forBridgeValue:(NSString * _Nonnull)bridgeValue;

/**
 加载url

 @param urlString url字符串
 @param shouldShow 是否显示loading框
 */
- (void)loadURLString:(NSString *_Nonnull)urlString shouldShowActivityIndicator:(BOOL)shouldShow;

/**
 加载本地html文件

 @param urlString 本地html文件路径
 @param shouldShow 是否显示loading框
 */
- (void)loadLocalURLString:(NSString *_Nonnull)urlString shouldShowActivityIndicator:(BOOL)shouldShow;

/**
 加载javascript字符串

 @param javaScriptString javascript字符串
 @param shouldShow 是否显示loading框
 */
- (void)loadJavaScriptString:(NSString *_Nonnull)javaScriptString shouldShowActivityIndicator:(BOOL)shouldShow;

@end

@protocol LYWebViewDelegate <NSObject>

- (void)webViewDidStartLoad:(LYWebView *_Nonnull)webView;
- (void)webViewDidFinishLoad:(LYWebView *_Nonnull)webView;
- (void)webView:(LYWebView *_Nonnull)webView didFailLoadWithError:(NSError *_Nullable)error;

@end
