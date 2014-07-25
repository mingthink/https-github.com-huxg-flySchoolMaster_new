//
//  MTMainViewController.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTMainViewController : UIViewController
{
    
    IBOutlet UILabel *scolllabel;
    UIScrollView *scro;
    IBOutlet UIPageControl *page;
}
@property (strong, nonatomic) IBOutlet UIImageView *myimage;
- (IBAction)feedback:(UIButton *)sender;
@property()NSArray *MudelArr;
@property()NSDictionary *Mudic;
@end
