//
//  MTStuListViewController.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-11.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTStuListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
     UITableView *mytab;
}
@property(nonatomic,retain)NSString *ksh;
@property(nonatomic,retain)NSString *name;
- (IBAction)back:(UIButton *)sender;

@end
