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
@interface MTStartViewController ()<UIScrollViewDelegate>
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
    
   // [self getvision];
    if([FuncPublic GetDefaultInfo:@"SelectServers"]==nil)
    {
    [FuncPublic SaveDefaultInfo:[NSNumber numberWithBool:YES] Key:@"SelectServers"];
    }
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
    [self performSelector:@selector(pushnext:) withObject:nil afterDelay:2];
//    if(![FuncPublic GetDefaultInfo:@"firstLauchss"])
//    {
//    [FuncPublic SaveDefaultInfo:@"No" Key:@"firstLauchss"];
//    [self performSelector:@selector(pushnext:) withObject:nil afterDelay:2];
//    }
//    else
//    {
//        [self performSelector:@selector(pushnext) withObject:nil afterDelay:2];
//    }
   // [self performSelector:@selector(pushnext:) withObject:nil afterDelay:2];
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
//加载新手导航
-(void)pushnext:(id)sender
{
    [image removeFromSuperview];
    NSArray *arr = [NSArray arrayWithObjects:@"http://pic3.apk8.com/big2/1369017292708505.jpg",@"http://img5.anzhi.com/thumb/201211/29/cn.com.tiros.android.navidog4x_15066300_0.jpg",@"http://img3.anzhi.com/thumb/201306/14/com.anzhi.weixin_30715000_0.jpg", nil];
    UIScrollView *dhscro = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    dhscro.delegate =self;
    dhscro.contentSize= CGSizeMake(320*3, DEVH);
    dhscro.tag = 1219;
    for(int i=0;i<3;i++)
    {
        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, DEVH)];
        [imag setContentMode:UIViewContentModeScaleAspectFit];
        //imag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+4]];
        [imag setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i]]]];
        [dhscro addSubview:imag];
    }
    [self.view addSubview:dhscro];
    
    UIButton *skipbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipbutton.frame = CGRectMake(280, DEVH-40, 40, 20);
    [skipbutton setTitle:@"skip" forState:UIControlStateNormal];
    [self.view addSubview:skipbutton];
    [skipbutton addTarget:self action:@selector(pushnext) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x>320*2+30)
    {
        [self pushnext];
    }
}
-(void)pushnext
{
    //push小动画
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:1.0];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    UIViewAnimationTransition transition;
    
    transition = UIViewAnimationTransitionCurlUp;
   // transition = UIViewAnimationTransitionCurlDown;
    
    [UIView setAnimationTransition:transition forView:self.view.superview cache:YES];
    
    [UIView commitAnimations];
    
    /*
    UIScrollView *scro = (UIScrollView *)[self.view viewWithTag:1219];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView animateWithDuration:.8 animations:^{
        scro.alpha = 0;
        self.view.backgroundColor = [UIColor redColor];
       // scro.frame = CGRectZero;
      //  scro.center = CGPointMake(160, 284);
    } completion:^(BOOL finished) { }];
     */   
    
    if([[FuncPublic GetDefaultInfo:@"Newuser"]count]==0)
    {
        NSLog(@"进入登录界面");
        MTLoginViewController *login = [[MTLoginViewController alloc]init];
        
        [self presentViewController:login animated:YES completion:nil];
    }
    else
    {
        [self getvision];
        MTAppDelegate *app = (MTAppDelegate *)[[UIApplication sharedApplication]delegate];
        
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
                            
                           // [[NSNotificationCenter defaultCenter]postNotificationName:@"freshMoudledata" object:nil];
                            
                           fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",CachePath]];
                            
                            [filemanger removeItemAtPath:fielpath error:nil];
                           
                        }
                        //界面定义接口的版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"baseVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"baseVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [self getPageInfo];
                        }
                        //应用中心的接口版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"applicationsVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"applicationsVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [FuncPublic SaveDefaultInfo:nil Key:@"AppList"];
                           // [[NSNotificationCenter defaultCenter]postNotificationName:@"freshAppcenterData" object:nil];
                        }
                        
                        //消息提示接口的版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"noticeMsgVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"noticeMsgVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [self getinfostr];

                        }
                        
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
//得到界面的配置风格数据
-(void)getPageInfo
{
    NSDictionary *dic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    NSMutableDictionary *dci = [NSMutableDictionary dictionary];
    
    [dci setObject:[dic objectForKey:@"rid"] forKey:@"rid"];
    
    [dci setObject:[dic objectForKey:@"id"] forKey:@"id"];
    
    [dci setObject:[FuncPublic createUUID] forKey:@"r"];
    
    [SVHTTPRequest GET:@"/api/module/base.html" parameters:dci completion:
     ^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
       //  NSLog(@"界面定义数据:----->>>>>>%@",response);
         if(error!=nil)
         {
             [WToast showWithText:kMessage];
             return ;
         }
         else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
         {
             [FuncPublic saveDataToLocal:response toFileName:PaGeCtrlCache];
         }
     }];
}
//得到全局的消息提示
-(void)getinfostr
{
   // NSLog(@"进入全局消息提示数据请求......");
    NSDictionary *dic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[FuncPublic createUUID] forKey:@"r"];
    
    [dict setObject:[dic objectForKey:@"id"] forKey:@"dvid"];
    
    [dict setObject:[dic objectForKey:@"rid"] forKey:@"role"];
    
    [SVHTTPRequest GET:@"/api/module/getNoticeMsg.html" parameters:dict completion:
     ^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
         if(error!=nil)
         {
             [WToast showWithText:@"获取提示信息失败"];
             return ;
         }
         else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
         {
             [FuncPublic saveDataToLocal:response toFileName:UserAletInfo];
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
