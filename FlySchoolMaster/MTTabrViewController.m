
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
    NSString *fielpath = [fiel stringByAppendingString:@"/FileDocuments/NuserINFo.txt"];
    NSDictionary * ddict = [[NSDictionary alloc]initWithContentsOfFile:fielpath];
    MAAry = [ddict objectForKey:@"data"];
//   // NSLog(@"本地存储数据%@",dict);
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
                [ FuncPublic saveDataToLocal:response toFileName:@"NuserINFo.txt"];
                NSArray *arrar = [response objectForKey:@"data"];
                [self layoutMoudel:arrar];
                MAAry = [response objectForKey:@"data"];
                
               // NSLog(@"返回数据%@",[[response objectForKey:@"data"]objectForKey:@"Modules"]);
              //  NSLog(@"第一块功能数据:%@",[[[response objectForKey:@"data"]objectForKey:@"Modules"]objectAtIndex:0]);
       
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
        
        UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(wid*(num-1)+20, 5, 40, 20)];
        imag.contentMode = UIViewContentModeScaleAspectFit;
        imag.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[[Marry objectAtIndex:i]objectForKey:@"icon"]]];
        [image addSubview:imag];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(wid*(num-1)+20, 25, 40, 25)];
        label.text = [NSString stringWithFormat:@"%@",[[Marry objectAtIndex:i]objectForKey:@"name"]];
        [image addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(wid*(num-1)+20, 0, wid, 49)];
        btn.tag = num-1;
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [image addSubview:btn];
    }

  //主功能模块配置
    MTAdAndFuncView *AdvFun = [[MTAdAndFuncView alloc]init];
    MTFuncListView *Funlist = [[MTFuncListView alloc]init];
    MTWebView *Webview = [[MTWebView alloc]init];
    MTBulitinView *Bulitin = [[MTBulitinView alloc]init];
    for(int i=0;i<Marry.count;i++)
    {
        NSString *mode = [[Marry objectAtIndex:i]objectForKey:@"mode"];
        if([mode isEqualToString:@"adAndFunctionList"])
        {
            AdvFun.MoudelDic = [Marry objectAtIndex:i];
        }
        if([mode isEqualToString:@"functionList"])
        {
             Funlist.MoudelDic = [Marry objectAtIndex:i];
        }
        if([mode isEqualToString:@"webview"])
        {
             Webview.MoudelDic = [Marry objectAtIndex:i];
        }
        if([mode isEqualToString:@"builtin"])
        {
             Bulitin.MoudelDic = [Marry objectAtIndex:i];
        }
    }
  //  self.viewControllers = [NSArray arrayWithObjects:AdvFun,Funlist,Webview,Bulitin, nil];
    //AdvFunCClass
   // MTMainViewController *mainview = [[MTMainViewController alloc]init];
    mainv.Mudic = [Marry objectAtIndex:0];
    self.nav = [[UINavigationController alloc]initWithRootViewController:mainv];
    //FuncListclass
    MTZiYuanViewController  *ziyuanview = [[MTZiYuanViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:ziyuanview];
  //  ziyuanview.MouDic = [Marry objectAtIndex:1];
   // ziyuanview.timr = @"tabar";
    //WebviewClass
    MTWebView *searchview = [[MTWebView alloc]init];
   // searchview.MoudelDic = [Marry objectAtIndex:2];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:searchview];
  //  searchview.backbutton.hidden = YES;
  //  searchview.time = @"tabar";
    //BulitinClass
    MTSetViewController *setview = [[MTSetViewController alloc]init];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:setview];
   // self.viewControllers = [NSArray arrayWithObject:self.nav,ziyuanview];
    self.viewControllers = [NSArray arrayWithObjects:self.nav, nil];
    commenmoud = [NSArray arrayWithObjects:self.nav,nav,nav1,nav3, nil];
//    //
    
//    NSArray *arr = [NSArray arrayWithObjects:@"main_home.png",@"main_source.png",@"main_search.png",@"main_setting.png", nil];
//    NSArray *titlearr = [NSArray arrayWithObjects:@"主页",@"资源",@"查询",@"设置", nil];
    
}
-(void)getvision
{
    NSDictionary *dic = [FuncPublic GetDefaultInfo:@"APPVersion"] ;
    // NSLog(@"----版本信息是:%@",dic);
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
    NSLog(@"进入选择点击.....");
    NSDictionary *modic = [MAAry objectAtIndex:sendre.tag];
    NSString *mode = [modic objectForKey:@"mode"];
    if([mode isEqualToString:@"adAndFunctionList"])
    {
      //  MTMainViewController *main = [[MTMainViewController alloc]init];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chageindex" object:modic];
       // mainv.Mudic = modic;
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:0];
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"functionList"])
    {
        MTZiYuanViewController  *ziyuanview = [[MTZiYuanViewController alloc]init];
         ziyuanview.MouDic = modic;
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:1];
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"webview"])
    {
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:2];
        self.viewControllers = [NSArray arrayWithObject:nav];
    }
    if([mode isEqualToString:@"builtin"])
    {
        UINavigationController *nav = (UINavigationController *)[commenmoud objectAtIndex:3];
        self.viewControllers = [NSArray arrayWithObject:nav];
    }

    
   // MTZiYuanViewController  *ziyuanview = [[MTZiYuanViewController alloc]init];
   // ziyuanview.MouDic = [Marry objectAtIndex:1];
    // ziyuanview.timr = @"tabar";
  //  MTWebView *searchview = [[MTWebView alloc]init];
   // searchview.MoudelDic = [Marry objectAtIndex:2];
   // UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:searchview];
    //  searchview.backbutton.hidden = YES;
    //  searchview.time = @"tabar";
  //  MTSetViewController *setview = [[MTSetViewController alloc]init];
  //  UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:setview];
    int wid = DEVW/MAAry.count;
    selectimage.frame =CGRectMake(sendre.tag*wid, 0, wid, 50);
   // self.selectedIndex = sendre.tag;
   // self.viewControllers = [NSArray arrayWithObject:searchview];
//    if(sendre.tag==2)
//    {
//        MTGKZSViewController *zsview = [[MTGKZSViewController alloc]init];
//        zsview.backbutton.hidden = YES;
//        [self.navigationController pushViewController:zsview animated:NO];
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
