//
//  MTGKZSViewController.m
//  FlySchoolMaster
//
//  Created by huxg on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTGKZSViewController.h"
#import "SVHTTPRequest.h"
#import "WToast.h"
#import "FuncPublic.h"
#import "MTLoginViewController.h"
#import "MTStuListViewController.h"
#import "MTLQQKViewController.h"
@interface MTGKZSViewController ()<UITextFieldDelegate>

@end

@implementation MTGKZSViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loaddata) name:@"KCFNetChange" object:nil];
    self.view.backgroundColor = [UIColor colorWithRed:86./255 green:255./255 blue:255./255 alpha:1];
    KsTf.delegate = self;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnlcik:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:nil size:18];
    [button setBackgroundImage:[UIImage imageNamed:@"未标题-29.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 21, 66, 32);
    [self.view addSubview:button];
   if([_time isEqualToString:@"tabar"])
   {
       button.hidden = YES;
       self.navigationController.navigationBarHidden = YES;
   }
    else
    {
        button.hidden = NO;
    }
    zxmcLb.text = [FuncPublic GetDefaultInfo:@"zxmc"];
    [self loaddata];
    // Do any additional setup after loading the view from its nib.
}
-(void)btnlcik:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)loaddata
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if([FuncPublic GetDefaultInfo:@"zxdm"]==NULL)
    {
        [dic setObject:@"" forKey:@"zxdm"];
        MTLoginViewController *login = [[MTLoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
    else
    {
    [dic setObject:[FuncPublic GetDefaultInfo:@"zxdm"] forKey:@"zxdm"];
    }
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [SVHTTPRequest GET:@"/api/examinee/getLQInfo.html"
                   parameters:dic
                   completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                       if(error!=nil)
                       {
                           [WToast showWithText:kMessage];
                           return;
                       }
                       else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
                       {
                           NSString *total = [[response objectForKey:@"data"]objectForKey:@"total"];
                           NSString *luqu = [[response objectForKey:@"data"]objectForKey:@"luqu"];
                           NSString *toud = [[response objectForKey:@"data"]objectForKey:@"toudang"];
                           alllabel.text = [NSString stringWithFormat:@"%@人",total];
                           luqLB.text = [NSString stringWithFormat:@"%@人",luqu];
                           toudLb.text = [NSString stringWithFormat:@"%@人",toud];
//                           Slabel.text = [NSString stringWithFormat:@"总共：%@人，其中投档：%@人，已录取：%@人",total,toud,luqu];
                       }
                   }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [KsTf resignFirstResponder];
    [NameTf resignFirstResponder];
   
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int lengthe = 0;
    if(textField==KsTf)
    {
        lengthe = 14;
    }
//    if(textField==YanzTf)
//    {
//        lengthe=6;
//    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length >= lengthe && range.length!=1){
        textField.text = [toBeString substringToIndex:lengthe];
        return NO;
        
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)select:(UIButton *)sender {
   // NSLog(@"comr iiii");
    [KsTf resignFirstResponder];
    [NameTf resignFirstResponder];
    if([KsTf.text isEqualToString:@""]&&[NameTf.text isEqualToString:@""])
    {
        [WToast showWithText:@"考生号和姓名不能同时为空"];
        return;
    }
    else
    {
    MTStuListViewController *list = [[MTStuListViewController alloc]init];
    list.name = NameTf.text;
    list.ksh = KsTf.text;
    [self.navigationController pushViewController:list animated:NO];
    }
}

- (IBAction)Lqselect:(id)sender {
    MTLQQKViewController *luqu = [[MTLQQKViewController alloc]init];
    [self.navigationController pushViewController:luqu animated:NO];
}
@end
