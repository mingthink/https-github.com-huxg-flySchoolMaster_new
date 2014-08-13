//
//  MTAboutViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-12.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTAboutViewController.h"
#import "FuncPublic.h"
#import "MTPageModel.h"
@interface MTAboutViewController ()
{
    NSString *phone;
}
@end

@implementation MTAboutViewController

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
    [FuncPublic InstanceNavgationBar:@"关于我们" action:@selector(back:) superclass:self isroot:NO];
    MTPageModel *model = [MTPageModel getPageModel];
    NSString *backimastr = [model.backgroud objectForKey:@"otherBg"];
    backimage.image = [UIImage imageNamed:backimastr];
    
    NSString *str = [[FuncPublic GetDefaultInfo:@"APPVersion"]objectForKey:@"versionCode"];
   // CGRectMake(<#CGFloat x#>, <#CGFloat y#>, CGFloat width, <#CGFloat height#>)
    //[ FuncPublic InstanceLabel:@"应用名称：高考小秘书校长端" RECT: CGRectMake(0, 70, 300, 40) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:self.view Lines:1 TAG:1 Ailgnment:1];
    [FuncPublic InstanceLabel:[NSString stringWithFormat: @"当前版本号：%@",str] RECT: CGRectMake(18, 250, 300, 40) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:self.view Lines:1 TAG:1 Ailgnment:1];
    //[FuncPublic InstanceLabel:@"开发团队：铭信科技有限公司" RECT: CGRectMake(20, 160, 300, 40) FontName:nil Red:0 green:0 blue:0 FontSize:14 Target:self.view Lines:1 TAG:1 Ailgnment:1];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makecall:(UIButton *)sender {
    
    NSString *number = sender.titleLabel.text;// 此处读入电话号码
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:num]];
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
