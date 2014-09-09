//
//  MTSetViewController.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTSetViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *caheBnt;
@property (strong, nonatomic) IBOutlet UILabel *selectLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchs;
@property (strong, nonatomic) IBOutlet UIImageView *backimagee;
- (IBAction)select:(UIButton *)sender;
- (IBAction)clearcache:(id)sender;
- (IBAction)switchclick:(UISwitch *)sender;

@end
