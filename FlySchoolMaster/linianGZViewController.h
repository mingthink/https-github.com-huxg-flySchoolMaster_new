//
//  linianGZViewController.h
//  scrollview
//
//  Created by huxg on 14-6-18.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface linianGZViewController : UIViewController
{
    
    IBOutlet UILabel *name;
    IBOutlet UILabel *number;
    IBOutlet UILabel *info;
    IBOutlet UILabel *score;
    IBOutlet UILabel *campus;
    IBOutlet UILabel *specialty;
}
@property(nonatomic,retain)NSString *namestr;
@property(nonatomic,retain)NSString *numberstr;
@property(nonatomic,retain)NSString *infostr;
@property(nonatomic,retain)NSString *scrostr;
@property(nonatomic,retain)NSString *yuanxstr;
@property(nonatomic,retain)NSString *zhuanystr;

- (IBAction)back:(id)sender;
@end
