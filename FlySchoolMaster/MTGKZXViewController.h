//
//  MTGKZXViewController.h
//  FlySchoolMaster
//
//  Created by huxg on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTGKZXViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
     UITableView *mytab;
}
- (IBAction)back:(UIButton *)sender;
@property()NSString *moudelurl;

@end
