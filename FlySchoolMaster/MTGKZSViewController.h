//
//  MTGKZSViewController.h
//  FlySchoolMaster
//
//  Created by huxg on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGKZSViewController : UIViewController
{
    
    IBOutlet UILabel *zxmcLb;
    IBOutlet UILabel *luqLB;
    IBOutlet UILabel *toudLb;
    IBOutlet UITextField *KsTf;
    IBOutlet UILabel *alllabel;
    
    IBOutlet UILabel *ScoolLabel;
    IBOutlet UITextField *NameTf;
    IBOutlet UILabel *Slabel;
}
@property (strong, nonatomic) IBOutlet UIButton *backbutton;
@property(nonatomic,retain)NSString *time;
- (IBAction)back:(UIButton *)sender;
- (IBAction)select:(UIButton *)sender;
- (IBAction)Lqselect:(id)sender;
@property()NSString *moudelurl;

@end
