//
//  MTMainViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTMainViewController.h"
#import "SVHTTPRequest.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "UIImageView+webimage.h"
#import "MTGKZXViewController.h"
#import "MTGKZSViewController.h"
#import "FeedbackViewController.h"
#import "MTNOViewController.h"
#import "MTAdvDtViewController.h"
#import "MTLINianGZViewController.h"
#import "AppButton.h"
#import "MyDbHandel.h"
#import "MTMudelDaTa.h"
#import "MTOTerViewController.h"
#define Duration 0.2
#define WIDTH  60
#define HIGHT  60

#define TAGH  10

#define BTNWIDTH  WIDTH - TAGH
#define BTNHIGHT  HIGHT - TAGH
#define userinfor @"userset.list"
@interface MTMainViewController ()<UIScrollViewDelegate>
{
    UIPageControl *mypage;
    NSMutableArray *dataarr;
    NSString *upurl;
    UIImageView *customPage;
   // NSMutableArray *itemarr;
   
    UIView *view;
    UIImageView *deletiamge;
    UITapGestureRecognizer *tap;
    NSMutableArray *itemarr1;
    
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL contain;
    BOOL shake;
    NSMutableArray *itemarr;
    NSMutableArray *delebutarr;
    UIView *backview;
    UIView *doneview;

    

}
@end

@implementation MTMainViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController .navigationBarHidden =YES;
}
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nohandel:) name:@"chageindex" object:nil];
    NSLog(@"come in mainclass......!!!!!");
    NSLog(@"传过来的数组数据:------%@",self.Mudic );

    [self handeldata];
    /*
    itemarr1 = [NSMutableArray array];
    itemarr = [NSMutableArray array];
    btnarr = [NSMutableArray array];
    [self setmainmodele];
    NSString *txtx = [FuncPublic GetDefaultInfo:@"xzxm"];
    NSString *txtx1 = [txtx substringWithRange:NSMakeRange(0, 1)];
    NSString *zxmc = [FuncPublic GetDefaultInfo:@"zxmc"];
   
     */
    NSString *zxmc = [[FuncPublic GetDefaultInfo:@"Newuser"]objectForKey:@"zxmc"];
    NSString *usernam = [[FuncPublic GetDefaultInfo:@"Newuser"]objectForKey:@"djxm"];
    scolllabel.text = [NSString stringWithFormat:@"%@ %@校长",zxmc,usernam];
    
    //广告视图
   // if([[_MudelArr objectAtIndex:0]objectForKey:@"ads"])
    scro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 74, 320, 200)];
    scro.pagingEnabled = YES;
    scro.backgroundColor = [UIColor colorWithRed:86./255 green:255./255 blue:255./255 alpha:1];
    scro.delegate = self;
    scro.showsHorizontalScrollIndicator = NO;
    scro.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scro];
  //  NSDictionary *AdvDic = [_Mudic objectForKey:@"ads"];
   
  //  [self AddImage:arr];
    //功能模块父视图
   // v = [[UIView alloc]initWithFrame:CGRectMake(0, 274, 320, DEVH-274-50)];
  //  [self.view addSubview:v];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(drawUI) name:@"statuschang" object:nil];
    
    
    doneview = [[UIView alloc]initWithFrame:CGRectMake(0, DEVH-80, DEVW, 30)];
    doneview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:doneview];
    
    UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    savebtn.frame = CGRectMake(0, 0, 320, 30);
    [savebtn setTitle:@"点击保存设置" forState:UIControlStateNormal];
    [savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [savebtn addTarget:self action:@selector(chagejson) forControlEvents:UIControlEventTouchUpInside];
    doneview.hidden = YES;
    [doneview addSubview:savebtn];
    
    //[self creatdatabase];
    // [self chagejson];
  //  [self drawUI];
    
    


   //背景图片
    UIImageView *backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, DEVH-274-50)];
    backimage.image = [UIImage imageNamed:@"未标题-1(1).png"];
  //  [v addSubview:backimage];
   //pagecontrol
    mypage = [[UIPageControl alloc]initWithFrame:CGRectMake(100, 0, 100, 20)];
    mypage.currentPageIndicatorTintColor = [UIColor yellowColor];
    [backimage addSubview:mypage];
   // [self loaddata];
    //加载广告
//    if([FuncPublic GetDefaultInfo:@"advimage"]==nil)
//    {
//    [self loaddata];
//    }
//    else
//    {
//        NSArray *arre = [FuncPublic GetDefaultInfo:@"advimage"];
//      //  NSLog(@"缓存数据室：%@",arre);
//      //  NSLog(@"come cache....");
//        [self AddImage:arre];
//    }
    [self getdata];
    // Do any additional setup after loading the view from its nib.
}
-(void)nohandel:(NSNotification *)no
{
    NSLog(@"收到通知......");
    self.Mudic = no.object;
  //  NSLog(@"收到的字典长度:%d")
    [self handeldata];
}
-(void)handeldata
{
    NSArray *arr = [_Mudic objectForKey:@"functions"];
    if(arr.count==0)
    {
        NSLog(@"没东西.....!!!!!!!!!!!!!!");
        for(UIView *v in backview.subviews)
        {
            [v removeFromSuperview];
        }
        return;
    }

    [self creatdatabase];
        NSMutableArray *insarr = [NSMutableArray array];
//    if(insarr.count==0)
//    {
//        
//        for(UIView *v in backview.subviews)
//        {
//            [v removeFromSuperview];
//        }
//        return;
//    }
   for(int i =0;i<arr.count;i++)
 {
     [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"icon"]];
     [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"id"]];
     
     [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"mode"]];
     [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"name"]];
     [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"num"]];
     [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"param"]];
     [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"status"]];
     [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"ver"]];
     [insarr addObject:[NSNumber numberWithInt:1]];
                         /*
    //                         NSArray *insarr = [NSArray arrayWithObjects:[[arr objectAtIndex:i]objectForKey:@"createDatetime"],[[arr objectAtIndex:i]objectForKey:@"id"],[[arr objectAtIndex:i]objectForKey:@"moduleFlag"],[[arr objectAtIndex:i]objectForKey:@"moduleImage"], [[arr objectAtIndex:i]objectForKey:@"moduleName"], [[arr objectAtIndex:i]objectForKey:@"moduleUrl"], [[[arr objectAtIndex:i]objectForKey:@"sortNumber"]integerValue], [[arr objectAtIndex:i]objectForKey:@"status"],nil];
    //                         */
       NSLog(@"插入的数组:%@",insarr);
                     BOOL ins =      [self insert:insarr];
                          if(ins==NO)
                          {
                              NSLog(@"插入失败.......");
                              
                          return;
                          }
                           [insarr removeAllObjects];
                        }
    
                      [self drawUI];

    
}
//创建表
-(void)creatdatabase
{
    [[MyDbHandel defaultDBManager]openDb:DBName];
    NSString *sql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(icon TEXT, id TEXT PRIMARY KEY,  mode TEXT,name TEXT,num INTEGER , param TEXT,status TEXT,ver TEXT,mounum INTEGER )",NAME];
  //  NSString *sqli = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(icon TEXT, id TEXT, index INTEGER PRIMARY KEY, mode TEXT,name TEXT, param TEXT,status TEXT,ver TEXT",NAME];
  //   NSString *sql = @"CREATE TABLE IF NOT EXISTS USER9(createDatetime TEXT, id TEXT, moduleFlag TEXT, moduleImage TEXT,moduleName TEXT, moduleUrl TEXT,sortNumber INTEGER PRIMARY KEY,status TEXT)";
     if( [[MyDbHandel defaultDBManager]creatTab:sql])
     {
   //  NSLog(@"创建表成功.....");
     
     }
    
}
//功能模块的数据
-(void)getdata
{
    
//    if([[FuncPublic GetDefaultInfo:@"appvision"]isEqualToString:@"1"])
//    {
//       // NSLog(@"本地数据库去除数据");
//        [self drawUI];
//        return;
//    }
//   // NSLog(@"网络请求.....");
//    [self creatdatabase];
//    NSString *sql = [NSString stringWithFormat:@"drop table %@",NAME];
//    [[MyDbHandel defaultDBManager]creatTab:sql];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
//    [dic setObject:[[FuncPublic GetDefaultInfo:@"Newuser"]objectForKey:@"authCode"] forKey:@"authCode"];
//    [SVHTTPRequest GET:@"/api/module/"
//            parameters:dic
//            completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
//                NSLog(@"%@",[response objectForKey:@"data"]);
//                if(error!=nil)
//                {
//                    
//                }
//                else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
//                {
//                    NSArray *arr = [response objectForKey:@"data"];
//                    NSMutableArray *insarr = [NSMutableArray array];
//                    for(int i =0;i<arr.count;i++)
//                    {
//                        [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"createDatetime"]];
//                        [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"id"]];
//                        [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"moduleFlag"]];
//                        [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"moduleImage"]];
//                        [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"moduleName"]];
//                        [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"moduleUrl"]];
//                        [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"sortNumber"]];
//                        [insarr addObject:[[arr objectAtIndex:i]objectForKey:@"status"]];
//                        /*
//                         NSArray *insarr = [NSArray arrayWithObjects:[[arr objectAtIndex:i]objectForKey:@"createDatetime"],[[arr objectAtIndex:i]objectForKey:@"id"],[[arr objectAtIndex:i]objectForKey:@"moduleFlag"],[[arr objectAtIndex:i]objectForKey:@"moduleImage"], [[arr objectAtIndex:i]objectForKey:@"moduleName"], [[arr objectAtIndex:i]objectForKey:@"moduleUrl"], [[[arr objectAtIndex:i]objectForKey:@"sortNumber"]integerValue], [[arr objectAtIndex:i]objectForKey:@"status"],nil];
//                         */
//                     //   NSLog(@"插入的数组:%@",insarr);
//                        [self insert:insarr];
//                        [insarr removeAllObjects];
//                    }
//                    [self drawUI];
//                    
//                    
//                }
//            }];
    
}
-(BOOL)insert:(NSArray *)arr
{
    [self creatdatabase];
    if( [[MyDbHandel defaultDBManager]insertdata:arr])
    {
        return YES;
    }
    else
        return NO;
}
-(void)drawUI
{
    [self creatdatabase];
    itemarr = [NSMutableArray array];
    delebutarr = [NSMutableArray array];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, 274, DEVW, DEVH-274-50)];
    backview.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:backview];
    for(UIView *v in [backview subviews])
    {
        [v removeFromSuperview];
    }
    
    
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where mounum = 1 order by num asc ",NAME];
    NSArray *arrr = [[MyDbHandel defaultDBManager]select:sql];
   
    NSMutableArray *mutaarr = [NSMutableArray array];
    for(MTMudelDaTa *datas in arrr)
    {
        if([datas.status isEqualToString:@"1" ])
        {
            [mutaarr addObject:datas];
        }
    }
   
    for(int i =0;i<mutaarr.count;i++)
    {
        
        
        
        int row = i/4;
        int dow = i%4;
        MTMudelDaTa *data = [mutaarr objectAtIndex:i];
        UIView *vi = [[UIView alloc]init];
        
        vi.frame = CGRectMake(10+dow*75, 10+row *80, 60, 90);
        vi.tag = data.num;
        
        //vi.hidden = NO;

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 10, 60, 60);
        if([data.icon hasSuffix:@".png"])
        {
            UIImage *imagee = [self getImageFromURL:[NSString stringWithFormat:@"%@%@",SERVER,data.icon]];
            [btn setBackgroundImage:imagee forState:UIControlStateNormal];
        }
        else
        {
        [btn setBackgroundImage:[UIImage imageNamed:data.icon] forState:UIControlStateNormal];
        }
        btn.tag = data.num;
        [btn addTarget:self action:@selector(selectitem:) forControlEvents:UIControlEventTouchUpInside];
        [vi addSubview:btn];
        [backview addSubview:vi];
//        if(vi.tag>=9)
//          [ vi removeFromSuperview];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 20)];
        label.text = data.name;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = 1;
        [vi addSubview:label];
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, 25, 25);
        
        [btn1 setBackgroundImage:[UIImage imageNamed:@"deleteTag.png"] forState:UIControlStateNormal];
        
        btn1.hidden = YES;
        [btn1 addTarget:self action:@selector(deletebtn:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag  = data.num+1001;
        // [btn1 addTarget:self action:@selector(deleteaction:) forControlEvents:UIControlEventTouchUpInside];
        [delebutarr addObject:btn1];
        [vi addSubview:btn1];
        
        
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(buttonLongPressed:)];
        [vi addGestureRecognizer:gesture];
        [itemarr addObject:vi];
        
    }
    
}
//网络图片下载
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
//button点击动作
-(void)selectitem:(UIButton *)btm
{
    if(shake)
    {
      //  shake = NO;
        [self EndWobble];
        for(UIButton *btnw in delebutarr)
        {
            btnw.hidden = YES;
        }
        return;
    }
   
        
    
   // UIViewController *vii = nil;
    [self creatdatabase];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where num = %d and  mounum = 1",NAME,btm.tag];
//  NSLog(@"选中的数据:%@",  [[MyDbHandel defaultDBManager]select:sql]);
    MTMudelDaTa *data =  [[[MyDbHandel defaultDBManager]select:sql]objectAtIndex:0];
//    if([data.name isEqualToString:@"教育动态"])
//    {
//     MTGKZXViewController * vii = [[MTGKZXViewController alloc]init];
//         [self.navigationController pushViewController:vii animated:NO];
//    }
//    if([data.moduleName isEqualToString:@"高考招生"])
//    {
//     MTGKZSViewController * vii = [[MTGKZSViewController alloc]init];
//         [self.navigationController pushViewController:vii animated:NO];
//    }
//    if([data.moduleName isEqualToString:@"历年高招"])
//    {
//     MTLINianGZViewController * vii = [[MTLINianGZViewController alloc]init];
//         [self.navigationController pushViewController:vii animated:NO];
//    }
//    if([data.moduleName isEqualToString:@"其他"])
//    {
//    MTOTerViewController * vii = [[MTOTerViewController alloc]init];
//        vii.moudelurl = data.moduleUrl;
//        [self.navigationController pushViewController:vii animated:NO];
//    }
   
 //   UIViewController *view = [UIViewController alloc]initWithNibName:<#(NSString *)#> bundle:<#(NSBundle *)#>
 //   NSLog(@"-----url is %@",data.moduleName);
  //  NSLog(@"点击的功能号:%d",btm.tag);
}
//删除某个功能操作
-(void)deletebtn:(UIButton *)btn
{
   // NSLog(@"删除的编号:%d",btn.tag-1001);
    //  [self EndWobble];
    [self creatdatabase];
    NSString *sql = [NSString stringWithFormat:@"update %@ set status = '0' where num=%d and  mounum = 1",NAME,btn.tag-1001];
    [[MyDbHandel defaultDBManager]updata:sql];
    doneview.hidden = NO;
    [self performSelector:@selector(missview:) withObject:doneview afterDelay:2.4];
    [self drawUI];
}
//保存当前设置并上传至服务器
-(void)chagejson
{
    doneview.hidden = YES;
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where mounum = 1 order by num asc ",NAME];
    NSString *upstr = [[MyDbHandel defaultDBManager]jsonwrite:sql];
   // NSLog(@"上传的str：------%@",upstr);
    //  doneview.hidden = YES;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"" forKey:@"authCode"];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [dic setObject:[[FuncPublic GetDefaultInfo:@"Newuser"]objectForKey:@"authCode"] forKey:@"authUser"];
    [dic setObject:[FuncPublic emptyStr:upstr] forKey:@"data"];
    [dic setObject:@"saveModule" forKey:@"action"];
    [SVHTTPRequest POST:@"/action/test.ashx" parameters:dic completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"come request.....%@",response);
       if(error!=nil)
       {
           [WToast showWithText:kMessage];
           return ;
       }
        else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
        {
            [WToast showWithText:@"上传成功！"];
        }
      //  NSLog(@"上传返回消息:---%@",response);
    }];
    
    //  NSLog(@"json string is %@",  [[MyDbHandel defaultDBManager]jsonwrite:sql]);
}
#pragma mark -longpress action
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    UIView *btn = (UIView *)sender.view;
    
    // NSLog(@"change view tag = %d",sender.view.tag);
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        
        [self BeginWobble];
        for(UIButton *btn in delebutarr)
        {
            btn.hidden = NO;
        }
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        [UIView animateWithDuration:.2 animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
        
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        
        
        //  NSLog(@".........");
        CGPoint newPoint = [sender locationInView:sender.view];
        
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        //   CGPoint newPoint = [sender locationInView:sender.view];
        int index = [self indexOfPoint:btn.center withButton:btn];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        if(index<0)
        {
            [self BeginWobble];
            //  [self EndWobble];
            [UIView animateWithDuration:.2 animations:^{
                
                btn.transform = CGAffineTransformIdentity;
                btn.alpha = 1.0;
                //  NSLog(@"每一栋");
                btn.center = originPoint;
            }];
            //  contain  = NO;
        }
        else
        {
            
            [UIView animateWithDuration:.2 animations:^{
                [self BeginWobble];
                
                btn.transform = CGAffineTransformIdentity;
                btn.alpha = 1.0;
                
                CGPoint temp = CGPointZero;
                UIView *button = itemarr[index];
                
                btn.center = button.center;
                temp = button.center;
                // button.center = originPoint;
                button.center = originPoint;
                doneview.hidden = NO;
                [self creatdatabase];
                NSString *sql = [NSString stringWithFormat:@"update %@ set num=%d where num = %d and  mounum = 1",NAME,0,btn.tag];
                [[MyDbHandel defaultDBManager]updata:sql];
                [self creatdatabase];
                NSString *sql1 = [NSString stringWithFormat:@"update %@ set num =%d where num = %d and  mounum = 1",NAME,btn.tag,index+1];
                [[MyDbHandel defaultDBManager]updata:sql1];
                [self creatdatabase];
                NSString *sql2 = [NSString stringWithFormat:@"update %@ set num =%d where num = %d and  mounum = 1",NAME,index+1,0];
                [[MyDbHandel defaultDBManager]updata:sql2];
                [self performSelector:@selector(drawUI) withObject:nil afterDelay:.7];
                [self performSelector:@selector(missview:) withObject:doneview afterDelay:2.4];
                //  [self creatdatabase];
                //  [self drawUI];
                
            }];
        }
    }
}
- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIView *)btn
{
    
    for (NSInteger i = 0;i<itemarr.count;i++)
    {
        UIButton *button = itemarr[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}
//抖动
-(void)BeginWobble
{
      shake = YES;
    for (UIView *viewe in [backview subviews])
    {
        srand([[NSDate date] timeIntervalSince1970]);
        float rand=(float)random();
        CFTimeInterval t=rand*0.0000000001;
        [UIView animateWithDuration:0.1 delay:t options:0  animations:^
         {
             viewe.transform=CGAffineTransformMakeRotation(-0.05);
         } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
              {
                  
                  
                  viewe.transform=CGAffineTransformMakeRotation(0.05);
              } completion:^(BOOL finished) {}];
         }];
    }
    
}
//结束抖动
-(void)EndWobble
{
    shake = NO;
    for (UIView *viewe in backview.subviews)
    {
        [UIView animateWithDuration:.1 delay:1 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             viewe.transform=CGAffineTransformIdentity;
             //             for(UIButton *btnnn in btnarr)
             //             {
             //                 btnnn.hidden = YES;
             //             }
         } completion:^(BOOL finished) {}
         ];
    }
    
}
-(void)missview:(UIView *)vi
{
    doneview.hidden = YES;
}
-(void)setmainmodele
{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSLog(@"str is ；---%@",str);
    NSString *filepath = [str stringByAppendingPathComponent:userinfor];
    NSArray *arre = [NSArray arrayWithContentsOfFile:filepath];
    NSLog(@"本地数据----%@",arre);
}
#pragma mark button action
-(void)select:(UIButton *)send
{
    UIView *view123 = (UIView *)[view viewWithTag:send.tag];
    UIButton *btn = (UIButton *)[view123 viewWithTag:send.tag];
    UIViewController *action = nil;
    if(btn.tag==0)
    {
            action = [[MTGKZXViewController alloc]init];
    }
    if(btn.tag==3)
    {
            action = [[MTGKZSViewController alloc]init];
    }
    if(btn.tag ==6)
    {
        action = [[MTLINianGZViewController alloc]init];
    }
    else if(btn.tag!=0&&btn.tag!=3&&btn.tag!=6)
    {
        action = [[MTNOViewController alloc]init];
    }
    
    [self.navigationController pushViewController:action animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
       // scro.delegate = self;
    //page.numberOfPages = 3;
   // page.backgroundColor =[UIColor redColor];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Advaction
//广告数据请求
-(void)loaddata
{
    dataarr = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:@"getADUrl" forKey:@"action"];
    //[dic setObject:[FuncPublic GetDefaultInfo:@"mobilenumber"] forKey:@"mobilenumber"];
    //[dic setObject:[FuncPublic GetDefaultInfo:@"authCode"] forKey:@"authCode"];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [dic setObject:[FuncPublic GetDefaultInfo:@"dvid"] forKey:@"dvid"];
   
    [SVHTTPRequest GET:@"/action/common.ashx"
                   parameters:dic
                   completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                      
                       if(error!=nil)
                       {
                           [WToast showWithText:kMessage];
                           NSArray *arraa = [NSArray arrayWithObjects:@"start.jpg",@"start.jpg",@"start.jpg", nil];
                           [self Addimage:arraa];
                           return ;
                       }
                       else if([[response objectForKey:@"status"]isEqualToString:@"true"])
                       {
                           for(NSDictionary *diction in [response objectForKey:@"data"])
                           {
                               [dataarr addObject:diction];
                           }
                           NSLog(@"网络数据是;%@",dataarr);
                           [FuncPublic SaveDefaultInfo:dataarr Key:@"advimage1"];
                           [self AddImage:dataarr];

                       }
                   }];
    
    
}
-(void)Addimage:(NSArray *)arr
{
    scro.contentSize = CGSizeMake(320*arr.count, scro.frame.size.height);
    mypage.numberOfPages = arr.count;
    [self setCurrentPage:mypage.currentPage];
    
    for(int i = 0;i<arr.count;i++)
    {
       
        UIImageView *imagevie = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, scro.frame.size.height)];
        imagevie.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[arr objectAtIndex:i ]]];
    
        [scro addSubview:imagevie];
        
    }
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(flashadr) userInfo:nil repeats:YES];
    
 
}

//显示广告
-(void)AddImage:(NSArray *)arr
{
   // NSLog(@"传入数组数据室；%@",arr);
  //  float heigh = [arr objectAtIndex:<#(NSUInteger)#>]
    scro.contentSize = CGSizeMake(320*arr.count, scro.frame.size.height);
    mypage.numberOfPages = arr.count;
  //  [self setCurrentPage:mypage.currentPage];
   
//    for(int i = 0;i<arr.count;i++)
//    {
//        float height = [[[arr objectAtIndex:i]objectForKey:@"height"]floatValue];
//        [FuncPublic InstanceButton:nil Ect:nil RECT:CGRectMake(320*i, 0, 320, height) AddView:scro ViewController:self SEL_:@selector(advdetail:) Kind:1 TAG:i+10];
//        UIImageView *imagevie = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, scro.frame.size.height)];
//        NSString *url = [[arr objectAtIndex:i]objectForKey:@"url"];
//        [imagevie setLoadingImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER,url]] placeholderImage:@"start.jpg"];
//       // [imagevie setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER,url]]];
//        [scro addSubview:imagevie];
//        
//    }
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(flashadr) userInfo:nil repeats:YES];

}
//点击某张广告
-(void)advdetail:(UIButton *)btn
{
    MTAdvDtViewController *detail = [[MTAdvDtViewController alloc]init];
    detail.urlstr = [[dataarr objectAtIndex:btn.tag-10]objectForKey:@"detailUrl"];
    [self.navigationController pushViewController:detail animated:NO];
}
//广告跳动
-(void)flashadr
{
    
    float current = scro.contentOffset.x+320;
    if(current>scro.contentSize.width-320)
        current = 0;
    [self setCurrentPage:current];
    scro.contentOffset = CGPointMake(current, 0);
    
}
- (void) setCurrentPage:(NSInteger)secondPage {

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x>scrollView.contentSize.width-280)
       
    scrollView.contentOffset = CGPointMake(0, 0);
    mypage.currentPage = scrollView.contentOffset.x/320;
}
//反馈
- (IBAction)feedback:(UIButton *)sender {
    FeedbackViewController *feedback = [[FeedbackViewController alloc]init];
    [self.navigationController pushViewController:feedback animated:NO];
}
@end
