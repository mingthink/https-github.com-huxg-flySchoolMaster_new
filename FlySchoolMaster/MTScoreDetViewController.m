//
//  MTScoreDetViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-11.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTScoreDetViewController.h"
#import "WToast.h"
#import "FuncPublic.h"
#import "SVHTTPRequest.h"
@interface MTScoreDetViewController ()

@end

@implementation MTScoreDetViewController

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
    MYBAckVIew.hidden = YES;
    kshLabel.text = _Ksh;
    nameLabel.text = _name;
    zkzLabel.text = _zkzh;
//    UIImageView *iamgeb = [UIImageView alloc]initWithFrame:CGRectMake(CjButton.frame.origin.x, CjButton.frame.origin.y, <#CGFloat width#>, <#CGFloat height#>)
    [self getscore];
    // Do any additional setup after loading the view from its nib.
}
-(void)SetUI
{
   // [FuncPublic InstanceImageView:@"未标题-27" Ect:@"png" RECT:CGRectMake(0,49,320,40) Target:self.view TAG:1];
    NSArray *arr = [NSArray arrayWithObjects:@"学生成绩",@"录取情况", nil];
    for (int i =0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(160*i, 49, 160, 40);
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
    }
//    [FuncPublic InstanceButton:nil Ect:nil RECT:CGRectMake(0, 49, 160, 40) AddView:self.view ViewController:self SEL_:@selector(btnclick:) Kind:1 TAG:1];
   // UIImageView *image = [FuncPublic InstanceImageView:@"title_bar_btn_click" Ect:@"png" RECT:CGRectMake(0, 49, 160, 40) Target:self.view TAG:1];
}
-(void)getscore
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    //[dic setObject:[FuncPublic GetDefaultInfo:@"zxdm"] forKey:@"zxdm"];
    [dic setObject:_Ksh forKey:@"ksh"];
    //[dic setObject:[FuncPublic createUUID] forKey:@"r"];
   
    [SVHTTPRequest GET:@"/api/examinee/getResultInfo.html"
                   parameters:dic
                   completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                       NSLog(@"utl is :------------///////%@",urlResponse);
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
                                   yuwenLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               if([[diction objectForKey:@"detail"]isEqualToString:@"sx"])
                                   ShuxueLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               if([[diction objectForKey:@"detail"]isEqualToString:@"wy"])
                                   waiyuLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               if([[diction objectForKey:@"detail"]isEqualToString:@"bkpmf"])
                                   BenkeZfLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               if([[diction objectForKey:@"detail"]isEqualToString:@"bkpm"])
                                   BenkePmLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               if([[diction objectForKey:@"detail"]isEqualToString:@"bktfrs"])
                                   TongFLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               if([[diction objectForKey:@"detail"]isEqualToString:@"zh"])
                                   zonghLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               if([[diction objectForKey:@"detail"]isEqualToString:@"zkpm"])
                                   zhuankePMLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               if([[diction objectForKey:@"detail"]isEqualToString:@"zkpmf"])
                                   zhuankeZFLb.text =[NSString stringWithFormat:@"%@  %@",[diction objectForKey:@"name"], [diction objectForKey:@"score"]];
                               

                               
                           }
//                           BenkeZfLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:0]objectForKey:@"name"], [[scrodata objectAtIndex:0]objectForKey:@"score"] ];
//                           BenkePmLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:1]objectForKey:@"name"], [[scrodata objectAtIndex:1]objectForKey:@"score"]];
//                           TongFLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:8]objectForKey:@"name"], [[scrodata objectAtIndex:8]objectForKey:@"score"]];
//                           zhuankeZFLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:2]objectForKey:@"name"], [[scrodata objectAtIndex:2]objectForKey:@"score"]];
//                           zhuankePMLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:3]objectForKey:@"name"], [[scrodata objectAtIndex:3]objectForKey:@"score"]];
//                           yuwenLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:4]objectForKey:@"name"], [[scrodata objectAtIndex:4]objectForKey:@"score"]];
//                           ShuxueLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:5]objectForKey:@"name"], [[scrodata objectAtIndex:5]objectForKey:@"score"]];
//                           waiyuLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:6]objectForKey:@"name"], [[scrodata objectAtIndex:6]objectForKey:@"score"]];
//                           zonghLb.text =[NSString stringWithFormat:@"%@  %@",[[scrodata objectAtIndex:7]objectForKey:@"name"], [[scrodata objectAtIndex:7]objectForKey:@"score"]];
                       }
                   }];
    UILabel *title = nil;
    UILabel *info = nil;
    UILabel *xm = nil;
    UILabel *ksh = nil;
    UILabel *yxmc = nil;
    UILabel *yxdh = nil;
    UILabel *zymc = nil;
    UILabel *luquzk = nil;
    for(UIView *v in [Myview subviews])
    {
        if(v==MYBAckVIew)
        {
            
        title = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 10, 285, 50) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:v Lines:3 TAG:1 Ailgnment:1];
        
        info = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 60, 285, 60) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:v Lines:4 TAG:1 Ailgnment:1];
        xm = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 120, 285, 20) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:v Lines:1 TAG:1 Ailgnment:2];
        ksh = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 140, 285, 20) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:v Lines:1 TAG:1 Ailgnment:2];
        yxmc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 160, 285, 20) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:v Lines:1 TAG:1 Ailgnment:2];
        yxdh = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 180, 285, 20) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:v Lines:1 TAG:1 Ailgnment:2];
        zymc = [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 200, 285, 40) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:v Lines:2 TAG:1 Ailgnment:2];
        luquzk= [FuncPublic InstanceLabel:nil RECT:CGRectMake(10, 250, 285, 30) FontName:nil Red:0 green:0 blue:0 FontSize:13 Target:v Lines:1 TAG:1 Ailgnment:1];
    }

    }
    //title.font = [UIFont fontWithName:nil size:12];
//    title.numberOfLines = 3;
//    title.textColor = [UIColor redColor];

   
//    UILabel *ksh = [[UILabel alloc]initWithFrame:CGRectMake(10, 145, 285, 30)];
//    UILabel *yxmc = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 285, 30)];
//    UILabel *yxdh = [[UILabel alloc]initWithFrame:CGRectMake(10, 215, 285, 30)];
//    UILabel *zymc = [[UILabel alloc]initWithFrame:
//    CGRectMake(10, 245, 285, 30)];
//    for(UIView *v in [Myview subviews])
//    {
//        if(v==MYBAckVIew)
//        {
//            //[v addSubview:title];
//            [v addSubview:info];
//            [v addSubview:xm];
//            [v addSubview:ksh];
//            [v addSubview:yxmc];
//            [v addSubview:yxdh];
//            [v addSubview:zymc];
//        }
//    }
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
                    title.text = [[response objectForKey:@"data"]objectForKey:@"title"];
                    info.text = [[response objectForKey:@"data"]objectForKey:@"info"];
                    ksh.text = [NSString stringWithFormat:@"考生号：  %@",[[response objectForKey:@"data"]objectForKey:@"ksh"]];
                    xm.text = [NSString stringWithFormat:@"姓名：   %@", [[response objectForKey:@"data"]objectForKey:@"xm"]];
                    yxmc.text = [NSString stringWithFormat:@"院校名称：  %@",[[response objectForKey:@"data"]objectForKey:@"yxmc"]];
                    yxdh.text = [NSString stringWithFormat:@"院校代号：  %@",[[response objectForKey:@"data"]objectForKey:@"yxdh"]];
                    zymc.text = [NSString stringWithFormat:@"专业名称：  %@",[[response objectForKey:@"data"]objectForKey:@"zymc"]];
                    if([[[response objectForKey:@"data"]objectForKey:@"lqzt"]isEqualToString:@"luqu"])
                    luquzk.text = @"已录取";
                    if([[[response objectForKey:@"data"]objectForKey:@"lqzt"]isEqualToString:@"toudang"])
                        luquzk.text = @"正在投档中";
                }
                
            }];
    
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)btnclick:(UIButton *)sender {
    if(sender.tag==2)
    {
          for(UIView *v in [Myview subviews])
          {
              if(v==MYBAckVIew)
              {
                  
                  v.hidden = NO;
              }
              else{
              v.hidden = YES;
              }
          }
        
            
        
    }
           else
           {
               
            for(UIView *v in [Myview subviews])
            {
                if(v==MYBAckVIew)
                {
                    v.hidden = YES;
                }
                else{
                    v.hidden=NO;
                }
            }
 
        }
   // [sender setBackgroundImage:[UIImage imageNamed:@"未标题-26.png"] forState:UIControlStateNormal];
}
@end
