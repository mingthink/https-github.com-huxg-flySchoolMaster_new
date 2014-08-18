//
//  MTNOViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-16.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTNOViewController.h"

@interface MTNOViewController ()

@end

@implementation MTNOViewController

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
    
    [FuncPublic InstanceNavgationBar:@"" action:@selector(btnlcik:) superclass:self isroot:YES];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)btnlcik:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)call:(UIButton *)sender {
    NSString *number = sender.titleLabel.text;// 此处读入电话号码
    
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:num]];

}
@end
