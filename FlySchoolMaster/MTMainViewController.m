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
#import "MTWebView.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "MTStrToColor.h"
#import "MTPageModel.h"
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
    NSMutableArray *pageimagearr;
    NSTimer *times;
    
    
    
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
    //此模块为广告功能模式
    [super viewDidLoad];
    //当模块改变时监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notihandel:) name:@"chageindex" object:nil];
    //导航栏上的配置
    
    
    
   
    
    
    
    mypage = [[UIPageControl alloc]init];
    mypage.currentPageIndicatorTintColor = [UIColor yellowColor];
   // mypage.numberOfPages = 3;
    
    
   // [self.view addSubview:mypage];
   
    
    
    //提示用户保存设置的视图
    doneview = [[UIView alloc]initWithFrame:CGRectMake(0, DEVH-80, DEVW, 30)];
    doneview.backgroundColor = [UIColor blackColor];
    doneview.alpha = .6;
    
    UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    savebtn.frame = CGRectMake(0, 0, 320, 30);
    [savebtn setTitle:@"点击保存设置" forState:UIControlStateNormal];
    [savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [savebtn addTarget:self action:@selector(chagejson) forControlEvents:UIControlEventTouchUpInside];
    doneview.hidden = YES;
    [doneview addSubview:savebtn];
    
    
    //布局完成后才请求数据，防止白屏
    if([_Mudic count]!=0)
    {
        
        // [self AddImage:AdvDic];
        [self handeldata];
    }
    else
        return;
    
    
    
}
-(void)notihandel:(NSNotification *)no
{
    NSLog(@"收到通知......");
    NSDictionary *dicc = no.object;
    NSString *mode = [dicc objectForKey:@"mode"];
    if(![mode isEqualToString:@"adAndFunctionList"])
        return;
    self.Mudic = no.object;
    //  NSLog(@"收到的字典长度:%d")
    [self handeldata];
    
}
//处理主功能数据
-(void)handeldata
{
    NSArray *arr = [_Mudic objectForKey:@"functions"];
    NSString *moudname = [_Mudic objectForKey:@"name"];
    NSString *ids = [_Mudic objectForKey:@"id"];
    //导航栏配置
    UIView *bakview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 74)];
    MTPageModel *model = [MTPageModel getPageModel];
    NSString *colostr = [model.backgroud objectForKey:@"titleBg"];
    UIColor *colr = [MTStrToColor hexStringToColor:colostr];
    bakview.backgroundColor = colr;
    //主页的配置和普通页面不同
    if([ids isEqualToString:model.mainid])
    {
        //logo
        UIImageView *logoimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 55, 35)];
        logoimage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_110",model.logo]];
        [bakview addSubview:logoimage];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(85, 20, 180, 35)];
        UIColor *comcolor = [UIColor whiteColor];
        label.text = @"移动校园校长端";
        label.textAlignment = 0;
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = comcolor;
        [bakview addSubview:label];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(85, 55, 180, 17)];
        NSString *autoname = [[FuncPublic GetDefaultInfo:@"Newuser"]objectForKey:@"djxm"];
        NSString *substr = [autoname substringWithRange:NSMakeRange(0, 1)];
        NSString *authcode = [[FuncPublic GetDefaultInfo:@"Newuser"]objectForKey:@"notice"];
        NSString *schoolname = [[FuncPublic GetDefaultInfo:@"Newuser"]objectForKey:@"zxmc"];
        label1.text = [NSString stringWithFormat:@"%@ %@%@",schoolname, substr,authcode];
        [bakview addSubview:label1];
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = comcolor;
        
        
        
        //右边反馈按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(270, 27, 45, 30);
        btn.layer.cornerRadius = 5;
        NSString *coclostr = [model.button objectForKey:@"background"];
        UIColor *colrr = [MTStrToColor hexStringToColor:coclostr];
        NSString *btntile = [model.button objectForKey:@"name"];
        [btn setTitle:btntile forState:UIControlStateNormal];
        [btn setBackgroundColor:colrr];
        
        [btn addTarget:self action:@selector(feedback:) forControlEvents:UIControlEventTouchUpInside];
        [bakview addSubview:btn];
    }
    else
    {
        UILabel *label2 = [[UILabel alloc]initWithFrame:bakview.bounds];
        label2.text = moudname;
        label2.textAlignment = 1;
        [bakview addSubview:label2];
    }
    
    [self.view addSubview:bakview];

    //广告视图
    // if([[_MudelArr objectAtIndex:0]objectForKey:@"ads"])
    scro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 74, 320, 200)];
    scro.pagingEnabled = YES;
    scro.backgroundColor = [UIColor colorWithRed:86./255 green:255./255 blue:255./255 alpha:1];
    scro.delegate = self;
    scro.showsHorizontalScrollIndicator = NO;
    scro.showsVerticalScrollIndicator = NO;
    scro.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:scro];
    NSDictionary *AdvDic = [[_Mudic objectForKey:@"ads"]JSONValue];
    
    [self handelAdvData:AdvDic];
    
    //主功能区域背景图片
    UIImageView *backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, scro.frame.size.height+74, 320, DEVH-50-scro.frame.size.height-74)];
    NSString *strimge = [model.backgroud objectForKey:@"mainBg"];
    backimage.image = [UIImage imageNamed:strimge];
    //  [backimage addSubview:mypage];
    [self.view addSubview:backimage];

    if(arr.count==0)
    {
        for(UIView *v in backview.subviews)
        {
            [v removeFromSuperview];
        }
        return;
        
    }
    
    [self creatdatabase];
    NSMutableArray *insarr = [NSMutableArray array];
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
        [insarr addObject:moudname];
        
        [self insert:insarr];
        [insarr removeAllObjects];
    }
    
    [self drawUI];
    
    
}
//创建表
-(void)creatdatabase
{
    [[MyDbHandel defaultDBManager]openDb:DBName];
    NSString *sql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(icon TEXT, id TEXT PRIMARY KEY,  mode TEXT,name TEXT,num INTEGER , param TEXT,status TEXT,ver TEXT,mouname TEXT )",NAME];
    [[MyDbHandel defaultDBManager]creatTab:sql];
    
    
}
//插入数据到数据库
-(BOOL)insert:(NSArray *)arr
{
    [[MyDbHandel defaultDBManager]openDb:DBName];
    // [self creatdatabase];
    if( [[MyDbHandel defaultDBManager]insertdata:arr])
    {
        return YES;
    }
    else
        return NO;
}
//主功能视图
-(void)drawUI
{
    //  [[MyDbHandel defaultDBManager]openDb:DBName];
    NSString *moudname = [_Mudic objectForKey:@"name"];
    
    [self creatdatabase];
    [itemarr removeAllObjects];
    [delebutarr removeAllObjects];
    itemarr = [NSMutableArray array];
    delebutarr = [NSMutableArray array];
    [backview removeFromSuperview];
    backview = nil;
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, scro.frame.size.height+74, 320, DEVH-50-scro.frame.size.height-74)];
    backview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backview];
    [self.view addSubview:doneview];
    
    
    
    
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where mouname = '%@' order by num asc ",NAME,moudname];
    NSArray *arrr = [[MyDbHandel defaultDBManager]select:sql];
    
    NSMutableArray *mutaarr = [NSMutableArray array];
    for(MTMudelDaTa *datas in arrr)
    {
        if(![datas.status isEqualToString:@"0" ])
        {
            [mutaarr addObject:datas];
        }
    }
    int widd = DEVW/4;
    int hei = backview.frame.size.height/2;
    // int hhei = hei-30>widd
    for(int i =0;i<mutaarr.count;i++)
    {
        
        
        
        int row = i/4;
        int dow = i%4;
        MTMudelDaTa *data = [mutaarr objectAtIndex:i];
        UIView *vi = [[UIView alloc]init];
        
        vi.frame = CGRectMake(dow*widd, row *hei, widd, hei);
        vi.tag = data.num;
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(DEVH>480)
            
            btn.frame = CGRectMake(10, 10, 60, 60);
        
        else
            btn.frame = CGRectMake(10, 10, 50, 50);
        if([data.icon hasSuffix:@".png"])
        {
            UIImageView *imageview = [[UIImageView alloc]init];
            NSString *urlstr = [NSString stringWithFormat:@"%@%@",SERVER,data.icon];
            [imageview setImageWithURL:[NSURL URLWithString:urlstr]];
            // UIImage *imagee = [self getImageFromURL:[NSString stringWithFormat:@"%@%@",SERVER,data.icon]];
            [btn setBackgroundImage:imageview.image forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_118",data.icon]] forState:UIControlStateNormal];
        }
        btn.tag = data.num;
        [btn addTarget:self action:@selector(selectitem:) forControlEvents:UIControlEventTouchUpInside];
        [vi addSubview:btn];
        [backview addSubview:vi];
        
        
        
        UILabel *label = [[UILabel alloc]init];
        if(DEVH>480)
            label.frame = CGRectMake(10, 75, 60, 20);
        else
            label.frame = CGRectMake(10, 60, 50, 20);
        label.text = data.name;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = 1;
        [vi addSubview:label];
        
        
        UIButton *delebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        delebtn.frame = CGRectMake(0, 0, 25, 25);
        
        [delebtn setBackgroundImage:[UIImage imageNamed:@"album_delete@2x.png"] forState:UIControlStateNormal];
        
        delebtn.hidden = YES;
        [delebtn addTarget:self action:@selector(deletebtn:) forControlEvents:UIControlEventTouchUpInside];
        delebtn.tag  = data.num+1001;
        // [btn1 addTarget:self action:@selector(deleteaction:) forControlEvents:UIControlEventTouchUpInside];
        [delebutarr addObject:delebtn];
        if([data.status isEqualToString:@"1"])
        {
        [vi addSubview:delebtn];
        }
        
        
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(buttonLongPressed:)];
        [vi addGestureRecognizer:gesture];
        [itemarr addObject:vi];
        
    }
    
}

//button点击动作
-(void)selectitem:(UIButton *)btm
{
    
    NSString *mouname = [_Mudic objectForKey:@"name"];
    if(shake)
    {
        
        [self EndWobble];
        for(UIButton *btnw in delebutarr)
        {
            btnw.hidden = YES;
        }
        return;
    }
    
    [[MyDbHandel defaultDBManager]openDb:DBName];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where num = %d and  mouname = '%@'",NAME,btm.tag,mouname];
    
    MTMudelDaTa *data =  [[[MyDbHandel defaultDBManager]select:sql]objectAtIndex:0];
    if([data.name isEqualToString:@"教育动态"])
    {
        MTGKZXViewController * vii = [[MTGKZXViewController alloc]init];
        [self.navigationController pushViewController:vii animated:NO];
    }
    if([data.name isEqualToString:@"高考招生"])
    {
        MTGKZSViewController * vii = [[MTGKZSViewController alloc]init];
        [self.navigationController pushViewController:vii animated:NO];
    }
    if([data.name isEqualToString:@"历年高招"])
    {    MTLINianGZViewController * vii = [[MTLINianGZViewController alloc]init];
        [self.navigationController pushViewController:vii animated:NO];
    }
    if([data.mode isEqualToString:@"webview"])
    {
        MTWebView *webview = [[MTWebView alloc]init];
        webview.urlstr = [NSString stringWithFormat:@"%@%@",SERVER,data.param];
        webview.titlestr = data.name;
        [self.navigationController pushViewController:webview animated:NO];
    }
    
}
//删除某个功能操作
-(void)deletebtn:(UIButton *)btn
{
    NSString *mouname = [_Mudic objectForKey:@"name"];
    
    
    [self creatdatabase];
    // [[MyDbHandel defaultDBManager]openDb:DBName];
    NSString *sql = [NSString stringWithFormat:@"update %@ set status = '0' where num=%d and mouname = '%@'",NAME,btn.tag-1001,mouname];
    [[MyDbHandel defaultDBManager]updata:sql];
    
    doneview.hidden = NO;
    [self performSelector:@selector(missview:) withObject:doneview afterDelay:2.4];
    [self drawUI];
}
//保存当前设置并上传至服务器
-(void)chagejson
{
    NSString *mouname = [_Mudic objectForKey:@"name"];
    doneview.hidden = YES;
    [self creatdatabase];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where mouname = '%@' order by num asc ",NAME,mouname];
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
        
        if(error!=nil)
        {
            [WToast showWithText:kMessage];
            return ;
        }
        else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
        {
            [WToast showWithText:@"上传成功！"];
        }
        
    }];
    
    
}
#pragma mark -longpress action
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    NSString *mouname = [_Mudic objectForKey:@"name"];
    UIView *btn = (UIView *)sender.view;
    
    // NSLog(@"change view tag = %d",sender.view.tag);
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        
        [self BeginWobble];
        for(UIButton *btn in delebutarr)
        {
//            NSString *sql = [NSString stringWithFormat: @"select * from %@ where num = %d",NAME,btn.tag];
//            [[MyDbHandel defaultDBManager]openDb:DBName];
//            
            btn.hidden = NO;
        }
        startPoint = [sender locationInView:sender.view];
        // NSLog(@"qishi坐标:-----%@", NSStringFromCGPoint(startPoint));
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
        
        // NSLog(@"移动坐标:-----%@", NSStringFromCGPoint(newPoint));
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        // btn.center = CGPointMake(newPoint.x, newPoint.y);
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        //   CGPoint newPoint = [sender locationInView:sender.view];
       long int index = [self indexOfPoint:btn.center withButton:btn];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        //
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
                //  [[MyDbHandel defaultDBManager]openDb:DBName];
                NSString *sql = [NSString stringWithFormat:@"update %@ set num=%d where num = %d and mouname = '%@'",NAME,0,btn.tag,mouname];
                
                [[MyDbHandel defaultDBManager]updata:sql];
                [self creatdatabase];
                //   [[MyDbHandel defaultDBManager]openDb:DBName];
                NSString *sql1 = [NSString stringWithFormat:@"update %@ set num =%d where num = %ld and mouname = '%@'",NAME,btn.tag,index+1,mouname];
                [[MyDbHandel defaultDBManager]updata:sql1];
                [self creatdatabase];
                // [[MyDbHandel defaultDBManager]openDb:DBName];
                NSString *sql2 = [NSString stringWithFormat:@"update %@ set num =%ld where num = %d and mouname = '%@'",NAME,index+1,0,mouname];
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
             [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat
              |UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
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
        [UIView animateWithDuration:.1 delay:1 options:UIViewAnimationOptionAllowUserInteraction
         |UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             viewe.transform=CGAffineTransformIdentity;
         } completion:^(BOOL finished) {}
         ];
    }
    
}
-(void)missview:(UIView *)vi
{
    doneview.hidden = YES;
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
#pragma mark- Advaction
//处理广告数据
-(void)handelAdvData:(NSDictionary *)AdvDiction
{
    NSString *MName = [_Mudic objectForKey:@"id"];
    NSLog(@"模块的id:%@",MName);
   // [FuncPublic SaveDefaultInfo:nil Key:MName];
    [FuncPublic SaveDefaultInfo:AdvDiction Key:MName];

    NSLog(@"广告的数据:%@",AdvDiction);
    NSString *mmname = [_Mudic objectForKey:@"name"];
    if([FuncPublic GetDefaultInfo:mmname]!=nil)
    {
        
        
        NSArray *advarrr = [FuncPublic GetDefaultInfo:mmname];
        
        [self AddImage:advarrr];
        return;
    }
    NSString *str = [AdvDiction objectForKey:@"url"];
    [SVHTTPRequest GET:str parameters:nil completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(error!=nil)
        {
            [WToast showWithText:kMessage];
        }
        else if([[response objectForKey:@"status"]isEqualToString:@"true"])
        {
            NSArray *advarr = [response objectForKey:@"data"];
            
            [FuncPublic SaveDefaultInfo:advarr Key:mmname];
            [self AddImage:advarr];
        }
    }];
    
}

//显示广告
-(void)AddImage:(NSArray *)arr
{
    mypage.numberOfPages = arr.count;
    pageimagearr = [NSMutableArray array];
    // NSLog(@"广告的数据:%@",arr);
    NSString *Mnam = [_Mudic objectForKey:@"id"];
    NSDictionary *dcico = [FuncPublic GetDefaultInfo:Mnam];
    float heighht = [[dcico objectForKey:@"height"]floatValue];
    heighht = heighht>200?200:heighht;
    int AdvTime = [[dcico objectForKey:@"stay"]integerValue];
    
    scro.contentSize = CGSizeMake(320*arr.count, heighht);
    scro.frame = CGRectMake(scro.frame.origin.x, scro.frame.origin.y, scro.frame.size.width, heighht);
    for(int i =0 ;i<arr.count;i++)
    {
        //自定义pagecontrol
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(130+20*i, scro.frame.size.height+74-20, 10, 10)];
        image1.image = [UIImage imageNamed:@"focus_a@2x"];
        [self.view addSubview:image1];
        UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(125+20*i, scro.frame.size.height+74-24, 17, 17)];
        image2.image = [UIImage imageNamed:@"focus_b@2x"];
        image2.tag = 12345+i;
        [self.view addSubview:image2];
        if(i>0)
            image2.hidden = YES;
        [pageimagearr addObject:image2];
        
        
        //scrollview上面的button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(320*i, 0, 320, heighht);
        [btn addTarget:self action:@selector(advdetail:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        
        //广告图片
        UIImageView *imagevie = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320,heighht)];
        NSString *url = [[arr objectAtIndex:i]objectForKey:@"url"];
        if([url isEqualToString:@""])
        imagevie.image = [UIImage imageNamed:@"start.jpg"];
        [imagevie setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER,url]]];
        [scro addSubview:btn];
        [scro addSubview:imagevie];
    }
    if(times)
    {
    [times invalidate];
    }
  times =  [NSTimer scheduledTimerWithTimeInterval:AdvTime target:self selector:@selector(flashadr) userInfo:nil repeats:YES];
    
}
//点击某张广告
-(void)advdetail:(UIButton *)btn
{
    NSString *nanna = [_Mudic objectForKey:@"name"];
    NSArray *arr = [FuncPublic GetDefaultInfo:nanna];
    NSString *urlstrr = [[arr objectAtIndex:btn.tag]objectForKey:@"detailUrl"];
    
    MTWebView *web = [[MTWebView alloc]init];
    web.titlestr = @"广告详细";
    web.urlstr = [NSString stringWithFormat:@"%@%@",SERVER,urlstrr];
    
    [self.navigationController pushViewController:web animated:NO];
}
//广告跳动
-(void)flashadr
{
    
    float current = scro.contentOffset.x+320;
    if(current>scro.contentSize.width-320)
        current = 0;
    
    scro.contentOffset = CGPointMake(current, 0);
    
}
- (void) setCurrentPage:(NSInteger)secondPage {
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x>scrollView.contentSize.width-280)
        
    scrollView.contentOffset = CGPointMake(0, 0);
    mypage.currentPage = scrollView.contentOffset.x/320;
    for(UIImageView *ima in pageimagearr)
    {
        if(ima.tag==mypage.currentPage+12345)
            ima.hidden = NO;
        else
            ima.hidden = YES;
    }
}
//反馈
- (IBAction)feedback:(UIButton *)sender {
    FeedbackViewController *feedback = [[FeedbackViewController alloc]init];
    
    [self.navigationController pushViewController:feedback animated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)dealloc
{
    
}
@end
