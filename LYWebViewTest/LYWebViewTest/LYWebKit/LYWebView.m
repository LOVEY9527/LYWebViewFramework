//
//  LYWebView.m
//  LYWebViewTest
//
//  Created by 李勇 on 2017/8/28.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface NSString (Category)

@end

@implementation NSString (Category)

/**
 字符串UTF-8编码

 @return 编码后的字符串
 */
- (nullable NSString *)customEncodingString
{
    if (self.length > 0)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
        {
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:self];
            return [self stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
        }else{
            return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    return nil;
}

@end

@interface NSURL (Category)

@end

@implementation NSURL (Category)

/**
 网址字符串转为可加载的url(主要针对有汉字的网址字符串)
 
 @param URLString url字符串
 @return url
 */
+ (nullable NSURL *)customURLWithString:(nonnull NSString *)URLString
{
    if ([URLString length] > 0)
    {
        return [NSURL URLWithString:[URLString customEncodingString]];
    }
    
    return nil;
}

@end

//前端中默认的与iOS原生桥接对象映射的变量名
static NSString * const kLYWVDefineBridgeValue = @"brigdeIosValue";

@interface LYWebView()<UIWebViewDelegate>

//webView
@property (strong, nonatomic) UIWebView *webView;

//默认活动指示器
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
//活动指示器是否显示
@property (assign, nonatomic) BOOL shouldShowActivityIndicator;

//iOS原生中与前端映射的桥接对象
@property (strong, nonatomic) id<JSExport> bridge;
//前端中与原生桥接对象映射的变量名
@property (copy, nonatomic) NSString *bridgeValue;

@end

@implementation LYWebView

#pragma mark - overwrite

/**
 初始化接口

 @param frame 尺寸大小
 @return 对象
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
#ifdef DEBUG
        [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
#endif
        
        [self buildView];
    }
    
    return self;
}

#pragma mark - func

/**
 构建界面
 */
- (void)buildView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.webView.delegate = self;
    [self addSubview:self.webView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.activityIndicatorView.bounds = CGRectMake(0, 0, 50, 50);
    self.activityIndicatorView.hidesWhenStopped = YES;
    [self addSubview:self.activityIndicatorView];
}

/**
 注册brigde(前端映射变量名为默认的brigdeIosValue)
 
 @param bridge 桥联对象
 */
- (void)registerBridge:(id<JSExport>)bridge
{
    [self registerBridge:bridge forBridgeValue:kLYWVDefineBridgeValue];
}

/**
 注册brigde
 
 @param bridge iOS原生中与前端映射的桥接对象
 @param bridgeValue 前端中与原生桥接对象映射的变量名
 */
- (void)registerBridge:(id<JSExport> _Nonnull)bridge forBridgeValue:(NSString * _Nonnull)bridgeValue
{
    self.bridge = bridge;
    self.bridgeValue = bridgeValue;
}

/**
 加载url
 
 @param urlString url字符串
 */
- (void)loadURLString:(NSString *)urlString shouldShowActivityIndicator:(BOOL)shouldShow
{
    if ([urlString length] > 0)
    {
        self.shouldShowActivityIndicator = shouldShow;
        if (!([urlString containsString:@"http://"] || [urlString containsString:@"https://"]))
        {
            urlString = [NSString stringWithFormat:@"http://%@",urlString];
        }
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL customURLWithString:urlString]];
        [self.webView loadRequest:urlRequest];
    }
#ifdef DEBUG
    else
    {
        NSLog(@"LY->url为空，加载失败！");
    }
#endif
}

/**
 加载本地html文件
 
 @param urlString 本地html文件路径
 */
- (void)loadLocalURLString:(NSString *)urlString shouldShowActivityIndicator:(BOOL)shouldShow
{
    self.shouldShowActivityIndicator = shouldShow;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL customURLWithString:urlString]];
    [self.webView loadRequest:urlRequest];
}

/**
 加载javascript字符串
 
 @param javaScriptString javascript字符串
 */
- (void)loadJavaScriptString:(NSString *)javaScriptString shouldShowActivityIndicator:(BOOL)shouldShow
{
    self.shouldShowActivityIndicator = shouldShow;
    [self.webView stringByEvaluatingJavaScriptFromString:[javaScriptString customEncodingString]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (self.shouldShowActivityIndicator)
    {
        [self.activityIndicatorView startAnimating];
    }
    
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)])
    {
        [self.delegate webViewDidStartLoad:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
    
    //建立原生和h5交互联系
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    if (([self.bridgeValue length] > 0) &&
        (self.bridge != nil))
    {
        context[self.bridgeValue] = self.bridge;
    }    
    
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)])
    {
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
    
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
    {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

@end
