//
//  MTAdvDtViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-17.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTAdvDtViewController.h"
#import "FuncPublic.h"

@interface MTAdvDtViewController ()<UIWebViewDelegate>

@end

@implementation MTAdvDtViewController

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
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, 320, DEVH-64-50)];
    web.delegate = self;
    [web loadRequest:requset];
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
