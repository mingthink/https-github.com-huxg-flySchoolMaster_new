
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
    mainv = [[MTMainViewController alloc]init];
    [self getdata];
    // [self getvision];
    
    
    // Do any additional setup after loading the view from its nib.
}
//从接口获取功能数据
-(void)getdata
{
    
    NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *fielpath = [fiel stringByAppendingString:@"/FileDocuments/NewUser.txt"];
    NSDictionary * ddict = [[NSDictionary alloc]initWithContentsOfFile:fielpath];
    NSLog(@"功能整体数据:%@",ddict);
    MAAry = [ddict objectForKey:@"data"];
    
    if(MAAry!=NULL)
    {
        
        [self layoutMoudel:MAAry];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [SVHTTPRequest GET:@"/api/module/getModule.html" parameters:dic
            completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                //  NSLog(@"返回数据%@",response);
                [ FuncPublic saveDataToLocal:response toFileName:@"NuserINFoo.txt"];
                NSArray *arrar = [response objectForKey:@"data"];
                [self layoutMoudel:arrar];
                MAAry = [response objectForKey:@"data"];
                [[MyDbHandel defaultDBManager]openDb:DBName];
                NSString *sql = [NSString stringWithFormat:@"drop table %@",NAME];
                [[MyDbHandel defaultDBManager]creatTab:sql];
                
                
            }];
}
-(void)layoutMoudel:(NSArray *)Marry
{
    
    self.tabBar.hidden = YES;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, DEVH-50, DEVW, 50)];
    image.image = [UIImage imageNamed:@"title_bar_bg_blue.png"];
    image.userInteractionEnabled = YES;
    [self.view addSubview:image];
    int wid = DEVW/Marry.count;
    selectimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wid, 50)];
    selectimage.image = [UIImage imageNamed:@"weibo_detail_buttombar_itembg_on"];
    [image addSubview:selectimage];
    
    //tabbar自动配置
    for(int i =0;i<Marry.count;i++)
    {
        int num = [[[Marry objectAtIndex:i]objectForKey:@"num"]integerValue];
        
        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(wid*(num-1), 5, wid, 20)];
        imag.contentMode = UIViewContentModeScaleAspectFit;
        imag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[Marry objectAtIndex:i]objectForKey:@"icon"]]];
        [image addSubview:imag];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(wid*(num-1), 25, wid, 25)];
        label.text = [NSString stringWithFormat:@"%@",[[Marry objectAtIndex:i]objectForKey:@"name"]];
        label.textAlignment = 1;
        [image addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(wid*(num-1)+20, 0, wid, 49)];
        btn.tag = num-1;
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
    
    NSDictionary *modic = [MAAry objectAtIndex:sendre.tag];
    NSString *mode = [modic objectForKey:@"mode"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"chageindex" object:modic];
    //先判断模块的模式，选择相应模式进入
    if([mode isEqualToString:@"adAndFunctionList"])
    {
        
        
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:0];
        [nav popToRootViewControllerAnimated:NO];
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"functionList"])
    {
        
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:1];
        nav.navigationBarHidden = YES;
        [nav popToRootViewControllerAnimated:NO];
        MTZiYuanViewController  *ziyuanview = nav.viewControllers[0];
        ziyuanview.MouDic = modic;
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"webview"])
    {
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:2];
        nav.navigationBarHidden = YES;
        [nav popToRootViewControllerAnimated:NO];
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"builtin"])
    {
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:3];
        nav.navigationBarHidden = YES;
        
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    int wid = DEVW/MAAry.count;
    selectimage.frame =CGRectMake(sendre.tag*wid, 0, wid, 50);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
