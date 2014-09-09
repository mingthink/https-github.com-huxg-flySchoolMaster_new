
//  MTTabrViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTTabrViewController.h"
#import "MTMainViewController.h"
#import "MTZiYuanViewController.h"
#import "MTSearchViewController.h"
#import "MTSetViewController.h"
#import "MTGKZSViewController.h"
#import "MTNOViewController.h"
#import "SVHTTPRequest.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "MTAdAndFuncView.h"
#import "MTFuncListView.h"
#import "MTWebView.h"
#import "MTBulitinView.h"
#import "MyDbHandel.h"
#import "MTStrToColor.h"
@interface MTTabrViewController ()
{
    UIImageView *selectimage;
    NSString *updateurl;
    NSDictionary *dict;
    NSArray *commenmoud;
    NSArray *MAAry;
    MTMainViewController *mainv;
}
@end

@implementation MTTabrViewController

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
    NSLog(@"进入直接面。。。。。。。。。。");
    MAAry = [NSArray array];
    
    mainv = [[MTMainViewController alloc]init];
    
    [self getdata];
    // [self getvision];
    
    
    // Do any additional setup after loading the view from its nib.
}
//从接口获取功能数据
-(void)getdata
{
    
    NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",CachePath]];
    
    NSDictionary * ddict = [[NSDictionary alloc]initWithContentsOfFile:fielpath];
    
    MAAry = [ddict objectForKey:@"data"];
   
    
    if(MAAry!=NULL)
    {
       
        [self layoutMoudel:MAAry];
        
       
    }
    else
    {
        NSLog(@"进入网络请求.......");
        NSDictionary *dicc = [FuncPublic GetDefaultInfo:@"Newuser"];
        
        NSString *uuid = [dicc objectForKey:@"rid"];
        NSString *dvid = [FuncPublic GetDefaultInfo:@"dvid"];
        NSString *ridd = [dicc objectForKey:@"id"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:[FuncPublic createUUID] forKey:@"r"];
        
        [dic setObject:uuid forKey:@"rid"];
        
        [dic setObject:ridd forKey:@"uid"];
        
        [dic setObject:dvid forKey:@"dvid"];
        
        
        [SVHTTPRequest GET:@"/api/module/getModule.html" parameters:dic
                completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                    if(error!=nil)
                    {
                        [WToast showWithText:kMessage];
                        return;
                    }
                    else if([[response objectForKey:@"status"]isEqualToString:@"true"])
                    {
                         NSLog(@"返回的数据信息:%@",response);
                        [ FuncPublic saveDataToLocal:response toFileName:CachePath];
                        
                        NSArray *arrar = [response objectForKey:@"data"];
                        
                        [self layoutMoudel:arrar];
                        
                        MAAry = [response objectForKey:@"data"];
                        
                        [[MyDbHandel defaultDBManager]openDb:DBName];
                        
                        NSString *sql = [NSString stringWithFormat:@"drop table  if  EXISTS %@",NAME];
                        
                        [[MyDbHandel defaultDBManager]creatTab:sql];
                        //同时将数据通过粘贴板共享出去
                        UIPasteboard *pd = [UIPasteboard pasteboardWithName:SharedData create:YES];
                        
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response];
                        
                        [pd setData:data forPasteboardType:@"userinfo"];
                    }
                    
                    
                }];
    }
}
-(void)layoutMoudel:(NSArray *)Marry
{
    NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",PaGeCtrlCache]];
    
    NSFileManager *FM = [NSFileManager defaultManager];
    //如果颜色配置缓存数据没有，则去请求数据
    if(![FM fileExistsAtPath:fielpath isDirectory:NO])
    {
        
    }
    NSDictionary * ddict = [[NSDictionary alloc]initWithContentsOfFile:fielpath];
    
    NSDictionary *dicc = [[ddict objectForKey:@"data"]objectForKey:@"background"];
    //   NSLog(@"传入的数据:%d",Marry.count);
    self.tabBar.hidden = YES;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, DEVH-50, DEVW, 50)];
    
    NSString *barimage = [dicc objectForKey:@"moduleBg"];
    
    NSString *barseleimg = [dicc objectForKey:@"selectedBg"];
    
    image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_640",barimage]];
    
    image.userInteractionEnabled = YES;
    
    [self.view addSubview:image];
    
    int wid = DEVW/Marry.count;
    
    selectimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, 50)];
    // UIColor *col = [UIColor c]
    UIColor *colr = [MTStrToColor hexStringToColor:barseleimg];
    
    
    selectimage.backgroundColor = colr;
    // selectimage.image = [UIImage imageNamed:barseleimg];
    [image addSubview:selectimage];
    
    //tabbar自动配置
    for(int i =0;i<Marry.count;i++)
    {
       // int num = [[[Marry objectAtIndex:i]objectForKey:@"num"]integerValue];
        
        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(wid*i, 5, wid, 20)];
        
        imag.contentMode = UIViewContentModeScaleAspectFit;
        
        imag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[Marry objectAtIndex:i]objectForKey:@"icon"]]];
        
        [image addSubview:imag];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(wid*i, 25, wid, 25)];
        
        label.text = [NSString stringWithFormat:@"%@",[[Marry objectAtIndex:i]objectForKey:@"name"]];
        NSLog(@"功能模块的名字:%@",label.text);
        
        label.textAlignment = 1;
        
        label.font = [UIFont systemFontOfSize:16.0f];
        
        label.textColor = [UIColor whiteColor];
        
        [image addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setFrame:CGRectMake(wid*i, 0, wid, 49)];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [image addSubview:btn];
    }
    
    //主功能模块配置
    
    mainv.Mudic = [Marry objectAtIndex:0];
    
    self.nav = [[UINavigationController alloc]initWithRootViewController:mainv];
    
    
    //FuncListclass
    MTZiYuanViewController  *ziyuanview = [[MTZiYuanViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ziyuanview];
    
    //WebviewClass
    MTWebView *searchview = [[MTWebView alloc]init];
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:searchview];
    
    
    //BulitinClass
    MTSetViewController *setview = [[MTSetViewController alloc]init];
    
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:setview];
    
    // self.viewControllers = [NSArray arrayWithObject:self.nav,ziyuanview];
    self.viewControllers = [NSArray arrayWithObjects:self.nav, nil];
    
    commenmoud = [NSArray arrayWithObjects:self.nav,nav,nav1,nav3, nil];
    
    
    //    NSArray *arr = [NSArray arrayWithObjects:@"main_home.png",@"main_source.png",@"main_search.png",@"main_setting.png", nil];
    //    NSArray *titlearr = [NSArray arrayWithObjects:@"主页",@"资源",@"查询",@"设置", nil];
    
}
-(void)getvision
{
    NSDictionary *dic = [FuncPublic GetDefaultInfo:@"APPVersion"] ;
    
    if (dic !=nil && ![[dic objectForKey:@"versionCode"] isEqualToString:@"1"]) {
        //更新版本
        updateurl = [dic objectForKey:@"file"];
        
        [FuncPublic showMessage:self Msg:[dic objectForKey:@"desc"] BtnTitle:@"立即更新" action:@selector(updateVersion) close:nil];
    }
    
}
-(void)updateVersion
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateurl]];
}

-(void)btnclick:(UIButton *)sendre
{
   // NSLog(@"come this clicked........");
    NSDictionary *modic = [MAAry objectAtIndex:sendre.tag];
    
    NSString *mode = [modic objectForKey:@"mode"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chageindex" object:modic];
    //先判断模块的模式，选择相应模式进入
    if([mode isEqualToString:@"adAndFunctionList"])
    {
        
        
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:0];
        
        [nav popToRootViewControllerAnimated:NO];
        
        MTMainViewController *main = nav.viewControllers[0];
        
        main.Mudic = modic;
        
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"functionList"])
    {

        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:1];
        
        nav.navigationBarHidden = YES;
        
        [nav popToRootViewControllerAnimated:NO];
        
        MTZiYuanViewController  *ziyuanview = nav.viewControllers[0];
        
        ziyuanview.MouDic = modic;
       // NSLog(@"传过去的字典数据:H%@",ziyuanview.MouDic);
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"webview"])
    {
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:2];
        
        nav.navigationBarHidden = YES;
        
        [nav popToRootViewControllerAnimated:NO];
        
        MTWebView *web = nav.viewControllers[0];
        
        web.MoudelDic = modic;
        
        web.isroot = YES;
        
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"builtin"])
    {
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:3];
        nav.navigationBarHidden = YES;
        [nav popToRootViewControllerAnimated:NO];
        
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    int wid = DEVW/MAAry.count;
    selectimage.frame =CGRectMake(sendre.tag*wid, 0, wid, 50);
    
}
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    NSLog(@"点击了barrrr.....");
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
