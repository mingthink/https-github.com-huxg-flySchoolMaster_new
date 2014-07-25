//
//  MTSetViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTSetViewController.h"
#import "FuncPublic.h"
#import "MTLoginViewController.h"
#import "WToast.h"
#import "SVHTTPRequest.h"
#import "MTAboutViewController.h"
#import "MTNotiMessageViewController.h"
#import "MTCusetViewController.h"

@interface MTSetViewController ()<UIAlertViewDelegate>

@end

@implementation MTSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)select:(UIButton *)sender {
    if(sender.tag==5)
    {
       MTCusetViewController *cuset = [[MTCusetViewController alloc]
                                   init];
        [self.navigationController pushViewController:cuset animated:NO];
    }
    if(sender.tag==4)
    {
        MTNotiMessageViewController *notimesage = [[MTNotiMessageViewController alloc]initWithNibName:@"MTNotiMessageViewController" bundle:nil];
        [self.navigationController pushViewController:notimesage animated:NO];
    }
    if(sender.tag==1)
    {
        UIAlertView *alet = [[UIAlertView alloc]initWithTitle:@"注销提醒" message:@"确定注销吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alet.delegate = self;
        [alet show];
        
//        MTLoginViewController *login = [[MTLoginViewController alloc]init];
//        [self presentViewController:login animated:YES completion:nil];
    }
    if(sender.tag==2)
    {
        MTAboutViewController *about = [[MTAboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:NO];
        
    }
    if(sender.tag==3)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:[FuncPublic createUUID] forKey:@"r"];
        [SVHTTPRequest GET:@"/api/base/iosUpdate.html"
                      parameters:dic
                      completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                          if(error!=nil)
                          {
                              [WToast showWithText:kMessage];
                              return ;
                          }
                          else if([[response objectForKey:@"status"]isEqualToString:@"true"])
                          {
                              NSString *url = [[response objectForKey:@"data"]objectForKey:@"file"];
                              NSString *versioncode = [[response objectForKey:@"data"]objectForKey:@"versionCode"];
                              NSDictionary *dicc = [FuncPublic GetDefaultInfo:@"APPVersion"] ;
                              NSLog(@"版本信息：%@",versioncode);
                              NSLog(@"版本信息是;%@",[FuncPublic GetDefaultInfo:@"appvision"]);
                              if (dicc !=nil && [[dicc objectForKey:@"versionCode"] isEqualToString:@"1"])
                                  {
                                      UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"已是最新版本" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                      [aler show];
                                      
                                  }
                              else
                              {
                                  [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
                              }
                          }
                      }];
    }
        
}
-(void)close
{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [FuncPublic SaveDefaultInfo:nil Key:@"authCode"];
        MTLoginViewController *login = [[MTLoginViewController alloc]init];
                [self presentViewController:login animated:YES completion:nil];
    }
    
}
@end
