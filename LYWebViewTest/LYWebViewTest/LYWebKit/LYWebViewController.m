//
//  LYWebViewController.m
//  LYWebViewTest
//
//  Created by 李勇 on 2017/8/29.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYWebViewController.h"

@interface LYWebViewController ()<LYWebViewDelegate>

@property (strong, nonatomic) LYWebView *webView;

//导航栏是否需要隐藏
@property (assign, nonatomic) BOOL navigationBarHidden;
//左导航按钮
@property (strong, nonatomic) UIImage *leftBarItemImg;
@property (copy, nonatomic) void (^leftBarItemBlock)();
//右导航按钮
@property (strong, nonatomic) UIImage *rightBarItemImg;
@property (copy, nonatomic) void(^rightBarItemBlock)();

@end

@implementation LYWebViewController

#pragma mark - overwrite

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"LYWebViewController dealloced");
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.navigationBarHidden];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

/**
 初始化方法
 
 @param navigationBarHidden 是否隐藏导航栏
 @return 初始化的对象
 */
- (id)initWithNavigationBarHidden:(BOOL)navigationBarHidden
{
    if (self = [self init])
    {
        self.navigationBarHidden = navigationBarHidden;
        self.automaticallyAdjustsScrollViewInsets = self.navigationBarHidden ? NO : YES;
    }
    
    return self;
}

#pragma mark - lazyLoading

- (LYWebView *)webView
{
    if (!_webView)
    {
        _webView = [[LYWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

#pragma mark - func

/**
 注册brigde(前端映射变量名为默认的brigdeIosValue)
 
 @param bridge iOS原生中与前端映射的桥接对象
 */
- (void)registerBridge:(id<JSExport>)bridge
{
    [self.webView registerBridge:bridge];
}

/**
 注册bridge桥接对象

 @param bridge iOS原生中与前端映射的桥接对象
 @param bridgeValue 前端中与原生桥接对象映射的变量名
 */
- (void)registerBridge:(id<JSExport>)bridge forBridgeValue:(NSString *)bridgeValue
{
//    NSLog(@"CFGetRetainCount((__bridge CFTypeRef)(manager)):%ld", CFGetRetainCount((__bridge CFTypeRef)(bridge)));
    [self.webView registerBridge:bridge forBridgeValue:bridgeValue];
}

/**
 加载url
 
 @param urlString url字符串
 @param navigationTitle 导航栏标题
 @param shouldShow 是否显示loading框
 */
- (void)loadURLString:(NSString *)urlString navigationTitle:(NSString *)navigationTitle shouldShowActivityIndicator:(BOOL)shouldShow
{
    self.navigationItem.title = navigationTitle.length > 0 ? navigationTitle : @"标题";
    [self.webView loadURLString:urlString shouldShowActivityIndicator:shouldShow];
}

/**
 加载本地html文件
 
 @param urlString 本地html文件路径
 @param navigationTitle 导航栏标题
 @param shouldShow 是否显示loading框
 */
- (void)loadLocalURLString:(NSString *)urlString navigationTitle:(NSString *)navigationTitle shouldShowActivityIndicator:(BOOL)shouldShow
{
    self.navigationItem.title = navigationTitle.length > 0 ? navigationTitle : @"标题";
    [self.webView loadLocalURLString:urlString shouldShowActivityIndicator:shouldShow];
}

/**
 加载javascript字符串
 
 @param javaScriptString javascript字符串
 */
- (void)loadJavaScriptString:(NSString *)javaScriptString shouldShowActivityIndicator:(BOOL)shouldShow
{
    [self.webView loadJavaScriptString:javaScriptString shouldShowActivityIndicator:shouldShow];
}

#pragma mark - LYWebViewDelegate

- (void)webViewDidStartLoad:(LYWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webViewDidStartLoad:)])
    {
        [self.delegate webViewController:self webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(LYWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webViewDidFinishLoad:)])
    {
        [self.delegate webViewController:self webViewDidFinishLoad:webView];
    }
}

- (void)webView:(LYWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webViewController:webView:didFailLoadWithError:)])
    {
        [self.delegate webViewController:self webView:webView didFailLoadWithError:error];
    }
}

@end
