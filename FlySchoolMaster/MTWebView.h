//
//  MTWebView.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-7-25.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTWebView : UIViewController
@property(nonatomic,retain)NSDictionary *MoudelDic;
@property(nonatomic,retain)NSString *titlestr;
@property (strong, nonatomic) IBOutlet UILabel *titlelb;
- (IBAction)back:(id)sender;
@property(nonatomic,retain)NSString *urlstr;
@property()BOOL isroot;
@end
