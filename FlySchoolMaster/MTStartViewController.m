//
//  MTStartViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTStartViewController.h"
#import "SVHTTPRequest.h"
#import "UIImageView+webimage.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "MTLoginViewController.h"
#import "MTAppDelegate.h"
@interface MTStartViewController ()
{
    UIImageView *image;
}
@end

@implementation MTStartViewController

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
    
    [self getvision];
    
    image = [[UIImageView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:image];
    
    if(![FuncPublic GetDefaultInfo:@"startimage"])
    {
        
        [self loaddata];
        
    }
    else
    {
        NSDictionary *dic = [FuncPublic GetDefaultInfo:@"startimage"];
        
        NSString *url = [dic objectForKey:@"url"];
        
        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.1.1:91%@",url]]];
        
    }
    [self performSelector:@selector(pushnext) withObject:nil afterDelay:2];
    
}
//启动画面数据请求
-(void)loaddata
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    
    NSString *url = @"/api/startup/";
    
    [SVHTTPRequest GET:url parameters:dic completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if(error!=nil)
        {
            
            [WToast showWithText:kMessage];
            return ;
        }
        if([[response objectForKey:@"status"]isEqualToString:@"true"])
        {
            [FuncPublic SaveDefaultInfo:[response objectForKey:@"data"] Key:@"startimage"];
            
            NSString *url = [[response objectForKey:@"data"]objectForKey:@"url"];
            
            [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.1.1:91%@",url]]];
            
            
        }
    }];
    
    
    
}
-(void)pushnext
{
    
    if([[FuncPublic GetDefaultInfo:@"Newuser"]count]==0)
    {
        NSLog(@"进入登录界面");
        MTLoginViewController *login = [[MTLoginViewController alloc]init];
        
        [self presentViewController:login animated:YES completion:nil];
    }
    else
    {
        MTAppDelegate *app = [[UIApplication sharedApplication]delegate];
        
        [app changeroot];
    }
}
//判断各个接口版本
-(void)getvision
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:[FuncPublic createUUID] forKey:@"r"];//uuid
    
    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    [param setObject:[userdic objectForKey:@"id"] forKey:@"uid"];
    
    [param setObject:[userdic objectForKey:@"rid"] forKey:@"rid"];
    
    [SVHTTPRequest GET:@"/api/module/version.html"
            parameters:param
            completion:^(NSMutableDictionary *response, NSHTTPURLResponse *urlResponse, NSError *error) {
                if(error!=nil)
                    return ;
                
                if([[response objectForKey:@"status"]isEqualToString:@"false"])
                    return;
                
                NSString *status = [FuncPublic tryObject:response Key:@"status" Kind:1]  ;
                
                if ([status isEqualToString:@"true"]) {
                    NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
                    
                    NSString *fielpath = nil;
                    
                  //  NSString *fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",CachePath]];
                    
                    NSFileManager *filemanger = [NSFileManager defaultManager];
                    
                    if([[FuncPublic GetDefaultInfo:@"APPVersions"]count]!=0)
                    {
                        //整个框架的版本
                        NSString *vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"iosVerCode"];
                        
                        NSString *nowvision = [[response objectForKey:@"data"]objectForKey:@"iosVerCode"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            
                        }
                        //模块定义接口的版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"modulesVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"modulesVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"freshMoudledata" object:nil];
                            
                           fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",CachePath]];
                           
                        }
                        //界面定义接口的版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"baseVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"baseVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"freshPageModel" object:nil];
                            fielpath =  [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",PaGeCtrlCache]];
                            
                        }
                        //应用中心的接口版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"applicationsVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"applicationsVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"freshAppcenterData" object:nil];
                        }
                        
                        //消息提示接口的版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"noticeMsgVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"noticeMsgVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"freshnoticedata" object:nil];
                            
                            fielpath =  [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",UserAletInfo]];

                        }
                        
                         [filemanger removeItemAtPath:fielpath error:nil];
                        

                        NSDictionary *dic = [response objectForKey:@"data"];
                        
                        [FuncPublic SaveDefaultInfo:dic Key:@"APPVersions"];


                    }
                    else{
                        NSDictionary *dic = [response objectForKey:@"data"];
                        
                        [FuncPublic SaveDefaultInfo:dic Key:@"APPVersions"];
                    }
                }
            }];
    
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
