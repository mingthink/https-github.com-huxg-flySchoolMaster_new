//
//  MTZiYuanViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTZiYuanViewController.h"
#import "MyDbHandel.h"
#import "MTMudelDaTa.h"
#import "FuncPublic.h"
#import "SVHTTPRequest.h"
#import "WToast.h"
#import "MTWebView.h"
#import "MTPageModel.h"
#import "UIImageView+webimage.h"
@interface MTZiYuanViewController ()
{
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL contain;
    BOOL shake;
    NSMutableArray *itemarr;
    NSMutableArray *delebutarr;
    UIView *backview;
    UIView *doneview;
    UILabel *labels;
    MTPageModel *model;
    
}
@end

@implementation MTZiYuanViewController

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
    //此界面为功能列表模式
    
    [super viewDidLoad];
    
    //当模块改变时监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notihandel:) name:@"chageindex" object:nil];
    
    //自定义导航条视图
    
    //    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 60)];
    //    vi.backgroundColor = [UIColor darkGrayColor];
    //    labels = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, 100, 40)];
    //
    //    [vi addSubview:labels];
    //    [self.view addSubview:vi];
    
    
    
    
    [self handeldata];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)notihandel:(NSNotification *)no
{
    NSLog(@"收到通知......");
    NSDictionary *dicc = no.object;
    
    NSString *mode = [dicc objectForKey:@"mode"];
    
    if(![mode isEqualToString:@"functionList"])
        return;
    self.MouDic = no.object;
    
    [self handeldata];
}
-(void)handeldata
{
    [[MyDbHandel defaultDBManager]openDb:DBName];
    NSArray *arr = [_MouDic objectForKey:@"functions"];
    
    NSString *mouname = [_MouDic objectForKey:@"name"];
    
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
        [insarr addObject:mouname];
        // [insarr addObject:[NSNumber numberWithInt:2]];
        /*
         //                         NSArray *insarr = [NSArray arrayWithObjects:[[arr objectAtIndex:i]objectForKey:@"createDatetime"],[[arr objectAtIndex:i]objectForKey:@"id"],[[arr objectAtIndex:i]objectForKey:@"moduleFlag"],[[arr objectAtIndex:i]objectForKey:@"moduleImage"], [[arr objectAtIndex:i]objectForKey:@"moduleName"], [[arr objectAtIndex:i]objectForKey:@"moduleUrl"], [[[arr objectAtIndex:i]objectForKey:@"sortNumber"]integerValue], [[arr objectAtIndex:i]objectForKey:@"status"],nil];
         //                         */
        //   NSLog(@"插入的数组:%@",insarr);
        [self insert:insarr];
        [insarr removeAllObjects];
    }
    
    [self DrawUI];
}
-(void)insert:(NSArray *)arr
{
    
    if( [[MyDbHandel defaultDBManager]insertdata:arr])
    {
        //  NSLog(@"插入成功数据");
    };
}
-(void)DrawUI
{
    NSString *mouname = [_MouDic objectForKey:@"name"];
    
    //自定义导航条
    [FuncPublic InstanceNavgationBar:mouname action:nil superclass:self isroot:YES];
    
    model = [MTPageModel getPageModel];
    
    itemarr = [NSMutableArray array];
    delebutarr = [NSMutableArray array];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, 60, DEVW, DEVH-60-50)];
    UIImageView *backimag = [[UIImageView alloc]initWithFrame:backview.bounds];
    NSString *backimastr = [model.backgroud objectForKey:@"otherBg"];
    backimag.image = [UIImage imageNamed:backimastr];
    
    //  self.view.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:105.0/255 blue:210.0/255 alpha:1.0];
   // backview.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:105.0/255 blue:210.0/255 alpha:1.0];
    [self.view addSubview:backview];
    for(UIView *v in [backview subviews])
    {
        [v removeFromSuperview];
    }
    
    
    [backview addSubview:backimag];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where mouname = '%@' order by num asc ",NAME,mouname];
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
            UIImageView *imageview = [[UIImageView alloc]init];
            NSString *urlstr = [NSString stringWithFormat:@"%@%@",SERVER,data.icon];
            [imageview setImageWithURL:[NSURL URLWithString:urlstr]];
           // UIImage *imagee = [self getImageFromURL:[NSString stringWithFormat:@"%@%@",SERVER,data.icon]];
            [btn setBackgroundImage:imageview.image forState:UIControlStateNormal];
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
#pragma mark -longpress action
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    NSString *mouname = [_MouDic objectForKey:@"name"];
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
       long int index = [self indexOfPoint:btn.center withButton:btn];
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
                [[MyDbHandel defaultDBManager]openDb:DBName];
                // [self creatdatabase];
                NSString *sql = [NSString stringWithFormat:@"update %@ set num=%d where num = %d and  mouname = '%@'",NAME,0,btn.tag,mouname];
                [[MyDbHandel defaultDBManager]updata:sql];
                //  [self creatdatabase];
                [[MyDbHandel defaultDBManager]openDb:DBName];
                NSString *sql1 = [NSString stringWithFormat:@"update %@ set num =%d where num = %ld and  mouname = '%@'",NAME,btn.tag,index+1,mouname];
                [[MyDbHandel defaultDBManager]updata:sql1];
                //  [self creatdatabase];
                [[MyDbHandel defaultDBManager]openDb:DBName];
                NSString *sql2 = [NSString stringWithFormat:@"update %@ set num =%ld where num = %d and  mouname = '%@'",NAME,index+1,0,mouname];
                [[MyDbHandel defaultDBManager]updata:sql2];
                [self performSelector:@selector(DrawUI) withObject:nil afterDelay:.7];
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
//button点击动作
-(void)selectitem:(UIButton *)btm
{
    NSString *mouname = [_MouDic objectForKey:@"name"];
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
    [[MyDbHandel defaultDBManager]openDb:DBName];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where num = %d and  mouname = '%@'",NAME,btm.tag,mouname];
    
    MTMudelDaTa *data =  [[[MyDbHandel defaultDBManager]select:sql]objectAtIndex:0];
    if([data.mode isEqualToString:@"webview"])
    {
        MTWebView *webv = [[MTWebView alloc]init];
        webv.urlstr = data.param;
        webv.titlestr = data.name;
        [self.navigationController pushViewController:webv animated:NO];
    }
    
}
//删除某个功能操作
-(void)deletebtn:(UIButton *)btn
{
    NSString *mouname = [_MouDic objectForKey:@"name"];
    // NSLog(@"删除的编号:%d",btn.tag-1001);
    //  [self EndWobble];
    // [self creatdatabase];
    [[MyDbHandel defaultDBManager]openDb:DBName];
    NSString *sql = [NSString stringWithFormat:@"update %@ set status = '0' where num=%d and  mouname ='%@'",NAME,btn.tag-1001,mouname];
    [[MyDbHandel defaultDBManager]updata:sql];
    doneview.hidden = NO;
    [self performSelector:@selector(missview:) withObject:doneview afterDelay:2.4];
    [self DrawUI];
}
//保存当前设置并上传至服务器
-(void)chagejson
{
    NSString *mouname = [_MouDic objectForKey:@"name"];
    doneview.hidden = YES;
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
    [SVHTTPRequest POST:@"/action/test.ashx" parameters:dic completion:
     ^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
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
             [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|
              UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
