//
//  MTOTerViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-7-21.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTOTerViewController.h"

@interface MTOTerViewController ()

@end

@implementation MTOTerViewController

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
    if(![_moudelurl isEqualToString:@""])
    {
        NSString *urlstr = [NSString stringWithFormat:@"%@%@",SERVER,_moudelurl];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *reque = [NSURLRequest requestWithURL:url];
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, DEVW, DEVH-64)];
    [web loadRequest:reque];
    [self.view addSubview:web];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backto:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
// [UIView animateWithDuration:.99 animations:^{
//     self.view.clipsToBounds = YES;
//     self.view.transform = CGAffineTransformMakeScale(0.0000001, 0.0000001);
// } completion:^(BOOL finished) {
//     [self.navigationController popViewControllerAnimated:NO];
// }];

}
@end
