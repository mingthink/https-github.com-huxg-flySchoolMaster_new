//
//  FeedbackViewController.h
//  GaoKao
//
//  Created by chenan on 14-5-28.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController{

    IBOutlet UIView *view1;//语音反馈
    IBOutlet UIView *view2;//文字反馈
    IBOutlet UIWebView *view3;//帮助
    IBOutlet UIScrollView *view4;//SIM文件
    IBOutlet UITextField *nameTextField;//姓名
    IBOutlet UITextField *sfzTextField;//身份证
    IBOutlet UITextField *moblieTextField;//手机
    IBOutlet UITextField *simTextField;//SIM卡
    IBOutlet UITextView *feedView;//文字反馈输入框
    IBOutlet UILabel *speakLabel;
    IBOutlet UIImageView *animatImage;
}


@end
