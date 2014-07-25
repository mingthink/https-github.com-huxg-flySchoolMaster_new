//
//  MTAboutViewController.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-12.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTAboutViewController : UIViewController
{
    IBOutlet UILabel *Phonenum;
    
}
- (IBAction)makecall:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *back;
- (IBAction)back:(UIButton *)sender;

@end
