//
//  MTScoreDetViewController.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-11.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTScoreDetViewController : UIViewController
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
}
- (IBAction)back:(id)sender;
- (IBAction)btnclick:(UIButton *)sender;
@property(nonatomic,retain)NSString *Ksh;
@property(nonatomic,retain)NSString *zkzh;
@property(nonatomic,retain)NSString *name;
@end
