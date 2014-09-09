//
//  MTMyWebView.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-8-28.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTMyWebView.h"
#import "FuncPublic.h"
@interface MTMyWebView ()<UIWebViewDelegate>
{
    UIWebView *web;
}
@end

@implementation MTMyWebView

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
    [FuncPublic InstanceNavgationBar:@"网页" action:@selector(back) superclass:self isroot:NO];
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 60, 320, DEVH-50-60)];
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:@"file:///Users/mingthink/Desktop/HTMLTEST/0901-2.html"]];
    [web loadRequest:requset];
    web.delegate = self;
    web.userInteractionEnabled = YES;
    
    [self.view addSubview:web];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapweb:)];
   // tap.numberOfTapsRequired = 2;
    
    //[web addGestureRecognizer:tap];
    
    for(UIGestureRecognizer *ges in self.view.gestureRecognizers)
    {
        NSLog(@"ges is:%@",ges);
    }
    // Do any additional setup after loading the view.
}
-(void)tapweb:(UITapGestureRecognizer *)gesture
{
    NSLog(@"come this tap gesture.....");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"myjs" ofType:@"js"];
    NSString *str = [[NSString alloc]initWithContentsOfFile:filePath];
   
     [web stringByEvaluatingJavaScriptFromString:str];
   // NSString *js = [
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
 
  //  NSLog(@"网页的主题:%@",currentURL);
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
