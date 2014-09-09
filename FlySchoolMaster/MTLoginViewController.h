//
//  MTLoginViewController.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTLoginViewController : UIViewController
{
    
    IBOutlet UITableView *RolesLiset;
    IBOutlet UITextField *YanzTf;
    IBOutlet UITextField *NumTf;
    IBOutlet UIScrollView *backscro;
    IBOutlet UIButton *lginButn;
    IBOutlet UITextField *RolesTf;
    IBOutlet UIView *rolesview;
}
- (IBAction)getYanZ:(UIButton *)sender;
- (IBAction)login:(UIButton *)sender;
- (IBAction)selctroles:(UIButton *)sender;
- (IBAction)support:(UIButton *)sender;
- (IBAction)selectroless:(UIButton *)sender;

@end
