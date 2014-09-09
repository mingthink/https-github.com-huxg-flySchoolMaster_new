//
//  MTCusetViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-7-18.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTCusetViewController.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "MyDbHandel.h"
#import "MTMudelDaTa.h"
#import "UIImageView+webimage.h"
#import "MTPageModel.h"
@interface MTCusetViewController ()
{
     UIView *backview;
    NSArray *arrr;
}
@end

@implementation MTCusetViewController

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
    [FuncPublic InstanceNavgationBar:@"自定义设置" action:@selector(backto:) superclass:self isroot:NO];
    [self getdata];
    // Do any additional setup after loading the view from its nib.
}
-(void)getdata
{
    MTPageModel *model = [MTPageModel getPageModel];
    NSString *backstr = [model.backgroud objectForKey:@"otherBg"];
    
    backview = [[UIView alloc]initWithFrame:CGRectMake(0, 60, DEVW, DEVH-60)];
   // backview.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:backview];
    
    UIImageView *images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVW, DEVH-80)];
    images.image = [UIImage imageNamed:backstr];
    [backview addSubview:images];
  //  [FuncPublic InstanceImageView:backstr Ect:nil RECT:CGRectMake(0, 0, DEVW, DEVH-60) Target:backview TAG:12334];
    
    [[MyDbHandel defaultDBManager]openDb:DBName];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by num asc",NAME];
    arrr = [[MyDbHandel defaultDBManager]select:sql];
    NSMutableArray *mutaarr = [NSMutableArray array];
    for(MTMudelDaTa *datas in arrr)
    {
        if([datas.status isEqualToString:@"1"])
        {
            [mutaarr addObject:datas];
        }
    }
    for(int i =0;i<arrr.count;i++)
    {
        int row = i/4;
        int dow = i%4;
        MTMudelDaTa *data = [arrr objectAtIndex:i];
        UIView *vi = [[UIView alloc]init];
        
        vi.frame = CGRectMake(10+dow*75, 10+row *80, 60, 90);
        vi.tag = i;
       
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

        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_118",data.icon]] forState:UIControlStateNormal];
        }
        [vi addSubview:btn];
        [backview addSubview:vi];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 60, 20)];
        label.text = data.name;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = 1;
        [vi addSubview:label];
        if([data.status isEqualToString:@"0"])
        {
            
            UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeContactAdd];
            btn1.frame = CGRectMake(0, 0, 25, 25);
            // [btn1 setBackgroundImage:[UIImage imageNamed:@"deleteTag.png"] forState:UIControlStateNormal];
            //  btn1.hidden = YES;
            [btn1 addTarget:self action:@selector(addbtn:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag  = i;
            // [btn1 addTarget:self action:@selector(deleteaction:) forControlEvents:UIControlEventTouchUpInside];
            //   [delebutarr addObject:btn1];
            [vi addSubview:btn1];
        }
    }
}

-(void)addbtn:(UIButton *)btn
{
    btn.hidden = YES;
    [[MyDbHandel defaultDBManager]openDb:DBName];
    MTMudelDaTa *data = [arrr objectAtIndex:btn.tag];
    NSString *sql = [NSString stringWithFormat:@"update %@ set status = '1' where num =%d and mouname = '%@'",NAME,data.num,data.moudname];
    [[MyDbHandel defaultDBManager]updata:sql];
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"statuschang" object:nil userInfo:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)backto:(id)sender {
//    [UIView animateKeyframesWithDuration:.3 delay:.2 options:3 animations:^{
//        self.view.transform = CGAffineTransformMakeScale(0.0000001, 0.00001);
//        self.view.clipsToBounds = YES;
//    } completion:^(BOOL finished) {
//        [self.navigationController popViewControllerAnimated:NO];
//    }];
//}


- (IBAction)backto:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
//        [UIView animateKeyframesWithDuration:.3 delay:.2 options:3 animations:^{
//            self.view.transform = CGAffineTransformMakeScale(0.0000001, 0.00001);
//            self.view.clipsToBounds = YES;
//        } completion:^(BOOL finished) {
//          [self.navigationController popViewControllerAnimated:NO];
//       }];
}
@end
