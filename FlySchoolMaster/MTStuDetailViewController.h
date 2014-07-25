//
//  MTStuDetailViewController.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-16.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTStuDetailViewController : UIViewController
{
    UILabel *zhuankePMLb;
    UIView *MYBAckVIew;
    UILabel *zhuankeZFLb;
    UIView *Myview;
    UILabel *TongFLb;
    UILabel *BenkePmLb;
    UILabel *BenkeZfLb;
    UILabel *zonghLb;
    UILabel *waiyuLb;
    UILabel *ShuxueLb;
    UILabel *yuwenLb;
    UILabel *zkzLabel;
    UILabel *nameLabel;
    UILabel *kshLabel;
    UIButton *CjButton;
    UILabel *TongYJs;
    UILabel *RuWLB;
    UILabel *JiafenLb;
    UILabel *WeiJLB;
    UILabel *lqztLb;
    UILabel *yuwensc;
    UILabel *shuxuesc;
    UILabel *waiyusc;
    UILabel *benkezfsc;
    UILabel *benkepmsc;
    UILabel *benketfsc;
    UILabel *zhuankezfsc;
    UILabel *zhunkepmsc;
    UILabel *tongfsc;
    UILabel *zonghsc;
    UILabel *ruwsc;
    UILabel *weijsc;
    UILabel *jiafensc;
    UILabel *tongyjssc;
}
- (IBAction)back:(UIButton *)sender;
@property(nonatomic,retain)NSString *Ksh;
@property(nonatomic,retain)NSString *zkzh;
@property(nonatomic,retain)NSString *name;
@end
