//
//  MTNEwsDetailViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-11.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTNEwsDetailViewController.h"
#import "FuncPublic.h"
@interface MTNEwsDetailViewController ()<UIWebViewDelegate>

@end

@implementation MTNEwsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER,_urlstr]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, 320, DEVH-64-50)];
    web.delegate = self;
    [web loadRequest:request];
    [self.view addSubview:web];
    // Do any additional setup after loading the view from its nib.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[FuncPublic SharedFuncPublic]StartActivityAnimation:self];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[FuncPublic SharedFuncPublic]StopActivityAnimation];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
