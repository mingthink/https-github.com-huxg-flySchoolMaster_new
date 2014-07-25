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
    
    IBOutlet UITextField *YanzTf;
    IBOutlet UITextField *NumTf;
}
- (IBAction)getYanZ:(UIButton *)sender;
- (IBAction)login:(UIButton *)sender;

@end
