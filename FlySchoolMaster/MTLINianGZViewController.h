//
//  MTLINianGZViewController.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-18.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTLINianGZViewController : UIViewController<UISearchBarDelegate>
{
    
    IBOutlet UISearchBar *mysearch;
}
- (IBAction)back:(id)sender;
- (IBAction)serahaction:(id)sender;
@property()NSString *moudelurl;

@end
