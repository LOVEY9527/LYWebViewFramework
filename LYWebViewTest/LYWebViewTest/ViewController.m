//
//  ViewController.m
//  LYWebViewTest
//
//  Created by 李勇 on 2017/8/28.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "ViewController.h"
#import "LYWebViewController.h"
#import "LYIOSWebManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    LYWebView *webView = [[LYWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 300)];
    LYIOSWebManager *manager = [[LYIOSWebManager alloc] init];
    [webView registerBridge:manager forBridgeValue:@"iOS"];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    [webView loadURLString:@"https://www.baidu.com" shouldShowActivityIndicator:YES];
    [webView loadLocalURLString:sourcePath shouldShowActivityIndicator:NO];
    [self.view addSubview:webView];
}

- (IBAction)pushBtnClick:(id)sender
{
    LYWebViewController *webViewController = [[LYWebViewController alloc] initWithNavigationBarHidden:NO];
    LYIOSWebManager *iosWebManager = [[LYIOSWebManager alloc] init];
    [webViewController registerBridge:iosWebManager];
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [webViewController loadLocalURLString:sourcePath navigationTitle:@"标题" shouldShowActivityIndicator:YES];
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
