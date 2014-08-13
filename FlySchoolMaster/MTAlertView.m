//
//  MTAlertView.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-8-11.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTAlertView.h"
#import "MTAppDelegate.h"
@implementation MTAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(void)Aletwithstring:(NSString *)str
{
    // NSLog(@"进入提示消息配置......");
    NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",UserAletInfo]];
    
    NSDictionary * ddict = [[NSDictionary alloc]initWithContentsOfFile:fielpath];
    
    NSDictionary *dic = [ddict objectForKey:@"data"];
    
    NSString *txtxstr = [dic objectForKey:str];
    
    CGSize size = [txtxstr sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(150, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    UIView *Alview = [[UIView alloc]init];
    
    Alview.layer.cornerRadius = 7;
    
    // NSLog(@"消息具体提示:%@",txtxstr);
    
    Alview.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:105.0/255 blue:210.0/255 alpha:.7];
    
    
    Alview.frame = CGRectMake(100, DEVH-50-size.height-7, 150, size.height);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Alview.frame.size.width, Alview.frame.size.height)];
    
    label.numberOfLines = 0;
    
    label.font = [UIFont systemFontOfSize:15.0f];
    
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    label.text = txtxstr;
    
    [Alview addSubview:label];
    
    UIWindow *mainwindow = [[UIApplication sharedApplication]keyWindow];
    
    [mainwindow addSubview:Alview];
    
    [MTAlertView missview:Alview];
    
    
    
}
+(void)missview:(UIView *)obcView
{
    [UIView animateWithDuration:2.5f
					 animations:^{
						 obcView.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [obcView removeFromSuperview];
						 
					 }];
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
