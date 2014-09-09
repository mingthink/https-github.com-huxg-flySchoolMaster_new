//
//  MTAppDelegate.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MTTabrViewController.h"
@interface MTAppDelegate : UIResponder <UIApplicationDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)MTTabrViewController *tab;
@property()BOOL iswife;
@property()BOOL ismolie;
-(void)changeroot;
-(void)showalert;
@end
void CrashHandlerExceptionHandler(NSException *exception);