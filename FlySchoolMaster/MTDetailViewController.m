//
//  MTDetailViewController.m
//  FlySchoolMaster
//
//  Created by huxg on 14-9-12.
//  Copyright (c) 2014年 MingThink. All rights reserved.
// 123

#import "MTDetailViewController.h"

@interface MTDetailViewController ()

@end

@implementation MTDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization萨萨说sssss说Assad 啊
        //12222
        //llihhvcbcbvcddd
    }
    return self;
}

- (void)viewDidLoad
{
    [FuncPublic InstanceNavgationBar:@"通知公告 " action:@selector(back) superclass:self isroot:NO];    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
