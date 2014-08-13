//
//  MTStuDetailViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-16.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTStuDetailViewController.h"
#import "FuncPublic.h"
#import "SVHTTPRequest.h"
#import "WToast.h"

@interface MTStuDetailViewController ()
{
    UIView *backscro1;
    UIView *backscro;
    UIScrollView *scro;
}
@end

@implementation MTStuDetailViewController

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
    [self SetUI];
    [self getscore];
    // Do any additional setup after loading the view from its nib.
}
-(void)SetUI
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 39)];
    v.backgroundColor = [UIColor grayColor];
    // v.backgroundColor = [UIColor colorWithRed:0 green:205. blue:55. alpha:1];
    [self.view addSubview:v];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 160, 40)];
    image.image = [UIImage imageNamed:@"未标题-26.png"];
    image.tag =101;
    [self.view addSubview:image];
    NSArray *arr = [NSArray arrayWithObjects:@"学生成绩",@"录取情况", nil];
    for (int i =0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(160*i, 64, 160, 39);
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        
        [self.view addSubview:btn];
    }
    scro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, 320, DEVH-50-104)];
    // scro.backgroundColor = [UIColor redColor];
    scro.contentSize = CGSizeMake(320, (DEVH-50-104)*2.2);
    [self.view addSubview:scro];
    
    backscro = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, scro.contentSize.height)];
    [scro addSubview:backscro];
    
    backscro1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, scro.contentSize.height)];
    [scro addSubview:backscro1];
    backscro1.hidden = YES;
    //边框图片
    UIImageView *ima = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 300, 80)];
    ima.image = [UIImage imageNamed:@"未标题-33.png"];
    [backscro addSubview:ima];
    
    nameLabel = [FuncPublic InstanceLabel:[NSString stringWithFormat:@"考生姓名：  %@",_name] RECT:CGRectMake(0, 0, 300, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima Lines:1 TAG:1 Ailgnment:2];
    [FuncPublic InstanceImageView:@"未标题-31" Ect:@"png" RECT:CGRectMake(0, 39, 300, 1) Target:ima TAG:1];
    kshLabel = [FuncPublic InstanceLabel:[NSString stringWithFormat:@"考  生  号：  %@",_Ksh] RECT:CGRectMake(0, 40, 300, 40) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima Lines:1 TAG:1 Ailgnment:2];
    
    ////边框图片2
    UIImageView *ima1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 81, 300, 200)];
    ima1.image = [UIImage imageNamed:@"未标题-33.png"];
    [backscro addSubview:ima1];
    for(int i =0;i<4;i++)
    {
        [FuncPublic InstanceImageView:@"未标题-31" Ect:@"png" RECT:CGRectMake(0, 39+40*i, 300, 1) Target:ima1 TAG:1];
        
    }
    BenkeZfLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 0, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:2];
    benkezfsc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 0, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:3];
    //benkezfsc.textColor = [UIColor redColor];
    
    BenkePmLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 40, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:2];
    benkepmsc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 40, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:3];
    
    TongFLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 80, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:2];
    tongfsc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 80, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:3];
    
    
    zhuankeZFLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 120, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:2];
    zhuankezfsc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 120, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:3];
    
    zhuankePMLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 160, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:2];
    zhunkepmsc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 160, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima1 Lines:1 TAG:1 Ailgnment:3];
    //backscro.backgroundColor = [UIColor redColor];
    ////边框图片3
    UIImageView *ima2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 282, 300, 160)];
    ima2.image = [UIImage imageNamed:@"未标题-33.png"];
    [backscro addSubview:ima2];
    for(int i =0;i<3;i++)
    {
        [FuncPublic InstanceImageView:@"未标题-31" Ect:@"png" RECT:CGRectMake(0, 39+40*i, 300, 1) Target:ima2 TAG:1];
        
    }
    yuwenLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 0, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima2 Lines:1 TAG:1 Ailgnment:2];
    yuwensc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 0, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima2 Lines:1 TAG:1 Ailgnment:3];
    
    ShuxueLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 40, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima2 Lines:1 TAG:1 Ailgnment:2];
    shuxuesc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 40, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima2 Lines:1 TAG:1 Ailgnment:3];
    
    waiyuLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 80, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima2 Lines:1 TAG:1 Ailgnment:2];
    waiyusc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 80, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima2 Lines:1 TAG:1 Ailgnment:3];
    
    zonghLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 120, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima2 Lines:1 TAG:1 Ailgnment:2];
    zonghsc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 120, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima2 Lines:1 TAG:1 Ailgnment:3];
    
    //边框图片4
    [FuncPublic InstanceLabel:@"以下成绩只有部分考生有：" RECT:CGRectMake(10,445,300,30) FontName:nil Red:0 green:0 blue:0 FontSize:19 Target:backscro Lines:1 TAG:1 Ailgnment:1];
    UIImageView *ima3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 475, 300, 160)];
    ima3.image = [UIImage imageNamed:@"未标题-33.png"];
    [backscro addSubview:ima3];
    for(int i =0;i<3;i++)
    {
        [FuncPublic InstanceImageView:@"未标题-31" Ect:@"png" RECT:CGRectMake(0, 39+40*i, 300, 1) Target:ima3 TAG:1];
        
    }
    TongYJs = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 0, 200, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima3 Lines:1 TAG:1 Ailgnment:2];
    tongyjssc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 0, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima3 Lines:1 TAG:1 Ailgnment:3];
    
    RuWLB = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 40, 300, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima3 Lines:1 TAG:1 Ailgnment:2];
    ruwsc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 40, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima3 Lines:1 TAG:1 Ailgnment:3];
    
    JiafenLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 80, 300, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima3 Lines:1 TAG:1 Ailgnment:2];
    jiafensc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 80, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima3 Lines:1 TAG:1 Ailgnment:3];
    
    WeiJLB = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 120, 300, 39) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:ima3 Lines:1 TAG:1 Ailgnment:2];
    //weijsc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(200, 120, 80, 39) FontName:nil Red:255. green:0 blue:0 FontSize:18 Target:ima3 Lines:1 TAG:1 Ailgnment:3];
    //提示语
    [FuncPublic InstanceLabel:@"温馨提示：" RECT:CGRectMake(10,640,300,40) FontName:nil Red:0 green:0 blue:0 FontSize:20 Target:backscro Lines:1 TAG:1 Ailgnment:2];
    [FuncPublic InstanceLabel:@"考生成绩及排名以江西省教育考试院正式通知为准，本软件数据仅供参考" RECT:CGRectMake(10,685,300,50) FontName:nil Red:255. green:0 blue:0 FontSize:15 Target:backscro Lines:2 TAG:1 Ailgnment:2];
    //录取情况UI
    //UIImageView *backiii = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, backscro1.frame.size.height)];
    // backiii.image = [UIImage imageNamed:@"未标题-36.png"];
    // [backscro1 addSubview:backiii];
    [FuncPublic InstanceImageView:@"未标题-36" Ect:@"jpg" RECT:CGRectMake(0, 0, 320, scro.contentSize.height) Target:backscro1 TAG:1];
    // [FuncPublic InstanceImageView:@"未标题-37" Ect:@"png" RECT:CGRectMake(0, 0, 320, scro.contentSize.height) Target:backscro1 TAG:1];
    
    
    lqztLb = [FuncPublic InstanceLabel:nil RECT:CGRectMake(0, 20, 300, 30) FontName:nil Red:255. green:0 blue:0 FontSize:20 Target:backscro1 Lines:1 TAG:1 Ailgnment:1];
    nameLabel = [FuncPublic InstanceLabel:[NSString stringWithFormat:@"考生姓名：  %@",_name] RECT:CGRectMake(10, 50, 300, 30) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    kshLabel = [FuncPublic InstanceLabel:[NSString stringWithFormat:@"考  生  号：  %@",_Ksh] RECT:CGRectMake(10, 90, 300, 30) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    
    
    
}
-(void)getscore
{
    [[FuncPublic SharedFuncPublic]StartActivityAnimation:self];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[FuncPublic GetDefaultInfo:@"zxdm"] forKey:@"zxdm"];
    [dic setObject:_Ksh forKey:@"ksh"];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    
    [SVHTTPRequest GET:@"/api/examinee/getResultInfo.html"
            parameters:dic
            completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                [[FuncPublic SharedFuncPublic]StopActivityAnimation];
                NSLog(@"--------->>>>data is :%@",[response objectForKey:@"data"]);
                if(error!=nil)
                {
                    [WToast showWithText:kMessage];
                    return ;
                }
                else if([[response objectForKey:@"status"]isEqualToString:@"true"])
                {
                    NSMutableArray *scrodata = [[NSMutableArray alloc]initWithCapacity:0];
                    for(NSDictionary *dic in [[response objectForKey:@"data"]objectForKey:@"subjects"])
                    {
                        [scrodata addObject:dic];
                    }
                    for(NSDictionary *diction in scrodata)
                    {
                        if([[diction objectForKey:@"detail"]isEqualToString:@"yw"])
                        {
                            yuwenLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            yuwensc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                            
                            
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"sx"])
                        {
                            ShuxueLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            shuxuesc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"wy"])
                        {
                            waiyuLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            waiyusc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"bkpmf"])
                        {
                            BenkeZfLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            benkezfsc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"bkpm"])
                        {
                            BenkePmLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            benkepmsc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"bktfrs"])
                        {
                            TongFLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            tongfsc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"zh"])
                        {
                            zonghLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            zonghsc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"zkpm"])
                        {
                            zhuankePMLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            zhunkepmsc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                            
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"zkpmf"])
                        {
                            zhuankeZFLb.text =[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            zhuankezfsc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"js"])
                        {
                            TongYJs.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            tongyjssc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        
                        if([[diction objectForKey:@"detail"]isEqualToString:@"rw"])
                        {
                            RuWLB.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            ruwsc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        if([[diction objectForKey:@"detail"]isEqualToString:@"jf"])
                        {
                            JiafenLb.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            jiafensc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        {
                            if([[diction objectForKey:@"detail"]isEqualToString:@"wj"])
                                WeiJLB.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]];
                            weijsc.text = [NSString stringWithFormat:@"%@",[diction objectForKey:@"score"]];
                        }
                        
                    }
                }
                
            }];
    
    
    
    UILabel *KeLeiMc = nil;
    UILabel *PiCiMc = nil;
    UILabel *xm = nil;
    UILabel *ksh = nil;
    UILabel *yxmc = nil;
    UILabel *yxdh = nil;
    UILabel *zymc = nil;
    // UILabel *luquzk = nil;
    KeLeiMc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 130, 300, 30) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    PiCiMc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 170, 300, 30) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    
    yxdh = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 210, 300, 30) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    yxmc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 250, 300, 30) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    zymc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 290, 300, 30) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    [FuncPublic InstanceLabel:@"温馨提示：" RECT:CGRectMake(10,330,300,40) FontName:nil Red:0 green:0 blue:0 FontSize:20 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    [FuncPublic InstanceLabel:@"考生成绩及排名以江西省教育考试院正式通知为准，本软件数据仅供参考" RECT:CGRectMake(10,380,300,50) FontName:nil Red:255. green:0 blue:0 FontSize:15 Target:backscro1 Lines:1 TAG:1 Ailgnment:2];
    
    
    
    NSMutableDictionary *diction = [[NSMutableDictionary alloc]initWithCapacity:0];
    [diction setObject:_Ksh forKey:@"ksh"];
    [diction setObject:[FuncPublic createUUID] forKey:@"r"];
    [SVHTTPRequest GET:@"/api/lqzt/" parameters:diction
            completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                if(error!=nil)
                {
                    [WToast showWithText:kMessage];
                    return;
                }
                else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
                {
                    //title.text = [[response objectForKey:@"data"]objectForKey:@"title"];
                    // info.text = [[response objectForKey:@"data"]objectForKey:@"info"];
                    ksh.text = [NSString stringWithFormat:@"考生号：  %@",[[response objectForKey:@"data"]objectForKey:@"ksh"]];
                    xm.text = [NSString stringWithFormat:@"姓名：   %@", [[response objectForKey:@"data"]objectForKey:@"xm"]];
                    yxmc.text = [NSString stringWithFormat:@"院校名称：  %@",[[response objectForKey:@"data"]objectForKey:@"yxmc"]];
                    yxdh.text = [NSString stringWithFormat:@"院校代号：  %@",[[response objectForKey:@"data"]objectForKey:@"yxdh"]];
                    zymc.text = [NSString stringWithFormat:@"专业名称：  %@",[[response objectForKey:@"data"]objectForKey:@"zymc"]];
                    KeLeiMc.text = [NSString stringWithFormat:@"科类名称：  %@",[[response objectForKey:@"data"]objectForKey:@"klmc"]];
                    PiCiMc.text = [NSString stringWithFormat:@"批次名称：  %@",[[response objectForKey:@"data"]objectForKey:@"pcmc"]];
                    if([[[response objectForKey:@"data"]objectForKey:@"lqzt"]isEqualToString:@"luqu"])
                        lqztLb.text = [NSString stringWithFormat:@"恭喜%@同学已被录取",_name];
                    if([[[response objectForKey:@"data"]objectForKey:@"lqzt"]isEqualToString:@"toudang"])
                        lqztLb.text = [NSString stringWithFormat:@"%@同学正在投档中",_name];
                }
                
            }];
    
    
    
}
-(void)btnclick:(UIButton *)sender
{
   
    sender.titleLabel.textColor = [UIColor redColor];
    UIImageView *iamge = (UIImageView *)[self.view viewWithTag:101];
    iamge.frame = sender.frame;
    if(sender.tag==0)
    {
        scro.contentSize = CGSizeMake(320, (DEVH-50-90)*2.2);
        backscro.hidden = NO;
        backscro1.hidden = YES;
    }
    if(sender.tag==1)
    {
        scro.contentSize = CGSizeMake(320, (DEVH-50-90)*1.2);
        backscro.hidden = YES;
        backscro1.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
