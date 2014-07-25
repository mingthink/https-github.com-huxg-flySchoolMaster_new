//
//  FeedbackViewController.m
//  GaoKao
//
//  Created by chenan on 14-5-28.
//  Copyright (c) 2014年 user. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FuncPublic.h"
#import "SVHTTPRequest.h"
#import "WToast.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface FeedbackViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>{

    AVAudioRecorder *recorder; 
    NSURL *urlPlay;
    int luyin;
    int bofang;
}

@property (retain, nonatomic) AVAudioPlayer *avPlay;

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    luyin = 0;
    bofang = 0;
    
    //隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark- textField delegete
//隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    for (int i=2000; i<=2004; i++) {
        UITextField *field = (UITextField *)[self.view viewWithTag:i];
        [field resignFirstResponder];
    }
    view4.frame = CGRectMake(0, 75+[FuncPublic IosPosChange:20], 320, view4.frame.size.height);
}
//下一项
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == nameTextField) {
        [sfzTextField becomeFirstResponder];
    }else if(textField == sfzTextField){
        [moblieTextField becomeFirstResponder];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if (DEVH<=480) {
        if (textField == simTextField) {
            view4.frame = CGRectMake(0, 75-30, 320, view4.frame.size.height);
        }
    }
    
    [UIView commitAnimations];
    return YES;
}
//现在输入位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == sfzTextField) {
        if (range.location>17) {
            return NO;
        }
    }
    if (textField == moblieTextField) {
        if (range.location>10) {
            return NO;
        }
    }
    if (textField == simTextField) {
        if (range.location>19) {
            return NO;
        }
    }
    return YES;
}
#pragma mark- action
- (void)audio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init]  ;
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/feedback.amv", strUrl]];
    urlPlay = url;
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    NSError * sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

//反馈
-(void)feedback:(int)flg{
    
        
   // NSLog(@"校长信息是:---%@",[FuncPublic GetDefaultInfo :@"authCode"]);
   // NSMutableDictionary *dic = [FuncPublic GetDefaultInfo:@"UserInfo"];
    [[FuncPublic SharedFuncPublic] StartActivityAnimation:self];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if([FuncPublic GetDefaultInfo:@"authCode"]==NULL)
    {
        [param setObject:@"" forKey:@"authCode"];
    }
    else{
    [param setObject:[FuncPublic GetDefaultInfo :@"authCode"] forKey:@"authCode"];
    }
    if (flg == 1) {
        if(self.avPlay != nil){
            NSData *data  = [NSData dataWithContentsOfURL:urlPlay];
            [param setObject:[data base64Encoding] forKey:@"resourceData"];
        }
    }else{
        [param setObject:[FuncPublic emptyStr:feedView.text] forKey:@"mindContent"];
    }
    [param setObject:[FuncPublic createUUID] forKey:@"r"];
    [param setObject:[FuncPublic GetDefaultInfo:@"dvid"] forKey:@"dvid"];
    [param setObject:[FuncPublic GetDefaultInfo:@"mobilenumber"] forKey:@"mobilenumber"];
    [param setObject:@"writerFeedback" forKey:@"action"];
    
   // NSString *url =[NSString stringWithFormat:@"/action/common.ashx?action=writerFeedback&r=%@&dvid=%@&ksh=%@",[FuncPublic createUUID],[FuncPublic GetDefaultInfo:@"DeviceToken"],[dic objectForKey:@"ksh"]];

    [SVHTTPRequest POST:@"/action/common.ashx"
             parameters:param
             completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
         [[FuncPublic SharedFuncPublic] StopActivityAnimation];
        if (error != nil) {
            [WToast showWithText:kMessage];
            return;
        }
        
        NSString *status = [FuncPublic tryObject:response Key:@"status" Kind:1];
        if ([status isEqualToString:@"true"]) {
            [FuncPublic ShowAlert:@"提交成功，感谢您的宝贵建议"];
            if (flg == 1) {
                [self clickSoundDelete:nil];//删除录音
            }else{
                feedView.text = @"";
            }
        }
    }];
}
//激活SIM卡
-(void)submitSIM{
    
    NSMutableDictionary *dic = [FuncPublic GetDefaultInfo:@"UserInfo"];
    [[FuncPublic SharedFuncPublic] StartActivityAnimation:self];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"checkMobileUser" forKey:@"action"];
    [param setObject:[FuncPublic GetDefaultInfo:@"DeviceToken"] forKey:@"dvid"];//手机设备id
    [param setObject:[dic objectForKey:@"ksh"] forKey:@"ksh"];
    [param setObject:[dic objectForKey:@"authCode"] forKey:@"authCode"];
    [param setObject:@"" forKey:@"remarkInfo"];
    [param setObject:[FuncPublic createUUID] forKey:@"r"];
    [param setObject:nameTextField.text forKey:@"userName"];
    [param setObject:sfzTextField.text forKey:@"idCardNumber"];
    [param setObject:moblieTextField.text forKey:@"mobileNumber"];
    [param setObject:simTextField.text forKey:@"sim"];
    [param setObject:@"127.0.0.1" forKey:@"ip"];
    
    NSString *url = @"/action/common.ashx";
    
    [SVHTTPRequest GET:url
            parameters:param
            completion:^(NSMutableDictionary *response, NSHTTPURLResponse *urlResponse, NSError *error) {
                [[FuncPublic SharedFuncPublic] StopActivityAnimation];
                if (error != nil) {
                    [WToast showWithText:kMessage];
                    return;
                }
                
                NSString *status = [FuncPublic tryObject:response Key:@"status" Kind:1];
                if ([status isEqualToString:@"true"]) {
                    [FuncPublic ShowAlert:@"激活成功"];
                }
            }];

}
#pragma mark- UIbutton IBAction
//返回
-(IBAction)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickSelectItem:(UIButton *)sender{
    NSDictionary *dic = [FuncPublic GetDefaultInfo:@"OpenInfo"];
    
 
 
    
    switch (sender.tag) {
        case 201:
        {
            for (int i=201; i<=204; i++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:i];
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
            }
            [sender setBackgroundImage:[UIImage imageNamed:@"select_a.png"] forState:UIControlStateNormal];
            
            view1.hidden = NO;
            view2.hidden = YES;
            view3.hidden = YES;
            view4.hidden = YES;
            
        }
            break;
        case 202:
        {
            for (int i=201; i<=204; i++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:i];
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
            }
            [sender setBackgroundImage:[UIImage imageNamed:@"select_a.png"] forState:UIControlStateNormal];
            
            view1.hidden = YES;
            view2.hidden = NO;
            view3.hidden = YES;
            view4.hidden = YES;

        }
            break;
        case 203:
        {
            for (int i=201; i<=204; i++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:i];
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
            }
            [sender setBackgroundImage:[UIImage imageNamed:@"select_a.png"] forState:UIControlStateNormal];
            
            view1.hidden = YES;
            view2.hidden = YES;
            view3.hidden = NO;
            view4.hidden = YES;
           // NSString *str = [NSString stringWithFormat:@"%@/api/help/",SERVER];
            //[view3 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        }
            break;
        case 204:
        {//激活SIM卡
            
            if ([[dic objectForKey:@"isOpenBookinMobile"] isEqualToString:@"true"]) {
                for (int i=201; i<=204; i++) {
                    UIButton *btn = (UIButton *)[self.view viewWithTag:i];
                    [btn setBackgroundImage:nil forState:UIControlStateNormal];
                }
                [sender setBackgroundImage:[UIImage imageNamed:@"select_a.png"] forState:UIControlStateNormal];
                
                view1.hidden = YES;
                view2.hidden = YES;
                view3.hidden = YES;
                view4.hidden = NO;
            }           
        }
            break;
        default:
            break;
    }
}
//开始录音
-(IBAction)clickSoundStart:(UIButton *)sender{
    if (luyin == 0) {
        luyin = 1;
        
        //创建录音文件，
        [self audio];
        //准备录音
        if ([recorder prepareToRecord]) {
            //开始
            [recorder record];
        }
        
        animatImage.hidden = NO;
        animatImage.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"sound_b.png"],[UIImage imageNamed:@"sound_b1.png"],[UIImage imageNamed:@"sound_b2.png"],[UIImage imageNamed:@"sound_b3.png"],nil];
        animatImage.animationDuration =   1.0f;
        [animatImage startAnimating];
        [sender setImage:nil forState:UIControlStateNormal];
        
        speakLabel.text = @"正在录音，点击结束录音";
    }else{
        luyin = 0;
         speakLabel.text = @"点击预览录音";
        [sender setImage:[UIImage imageNamed:@"sound_a.png"] forState:UIControlStateNormal];
        animatImage.hidden = YES;
        //时长判断
        double cTime = recorder.currentTime;
        if (cTime>1) {
            self.avPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
            sender.hidden = YES;
            
            UIButton *playbtn = (UIButton *)[view1 viewWithTag:888];
            playbtn.hidden = NO;
            
            UIButton *deletebtn = (UIButton *)[view1 viewWithTag:999];
            deletebtn.hidden = NO;
            
        }else{
        }
        [recorder deleteRecording];
        [recorder stop];
    }
}

//播放语音
-(IBAction)clickPlaySound:(UIButton *)sender{
    if (bofang == 0) {
        bofang = 1;
        [sender setImage:[UIImage imageNamed:@"play_stop.png"] forState:UIControlStateNormal];
        
        if (self.avPlay.playing) {
            [self.avPlay stop];
            return;
        }
        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
        player.delegate = self;
        self.avPlay = player;
        [self.avPlay play];
        
        speakLabel.text = @"点击停止录音";
    }else{
        
        speakLabel.text = @"点击预览录音";
        bofang = 0;
        [self.avPlay stop];
        [sender setImage:[UIImage imageNamed:@"play_a.png"] forState:UIControlStateNormal];
    }
    
}
//删除语音
-(IBAction)clickSoundDelete:(UIButton *)sender{
    luyin = 0;
    bofang = 0;
    speakLabel.text = @"点击开始录音";
    if (recorder != nil)[recorder deleteRecording];
    if(self.avPlay!=nil)self.avPlay = nil;
    
    UIButton *btn = (UIButton *)[view1 viewWithTag:777];
    [btn setImage:[UIImage imageNamed:@"sound_a.png"] forState:UIControlStateNormal];
    btn.hidden = NO;
    
    UIButton *btndelete = (UIButton *)[view1 viewWithTag:999];
    btndelete.hidden = YES;
    
    UIButton *btnplay = (UIButton *)[view1 viewWithTag:888];
    [btnplay setImage:[UIImage imageNamed:@"play_a.png"] forState:UIControlStateNormal];
    btnplay.hidden = YES;
}
//播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
  {
       UIButton *playbtn = (UIButton *)[view1 viewWithTag:888];
      [playbtn setImage:[UIImage imageNamed:@"play_a.png"] forState:UIControlStateNormal];
      bofang = 0;
       speakLabel.text = @"点击预览录音";
   }

//提交语音反馈
-(IBAction)clickSubmitSound:(UIButton *)sender{
//    [self clickSoundStart:nil];
    [self feedback:1];
}
//文字反馈
-(IBAction)clickTextFeed:(id)sender{
    if ([FuncPublic IsEmpty:feedView.text]) {
        [FuncPublic ShowAlert:@"请输入反馈信息"];
        return;
    }
    [self feedback:2];
}
//激活卡
-(IBAction)clickSIM:(id)sender{
    if ([FuncPublic IsEmpty:nameTextField.text]) {
        [FuncPublic ShowAlert:@"请输入姓名"];
        return;
    }
    if ([FuncPublic IsEmpty:sfzTextField.text]) {
        [FuncPublic ShowAlert:@"请输入身份证"];
        return;
    }
    if ([FuncPublic IsEmpty:moblieTextField.text]) {
        [FuncPublic ShowAlert:@"请输入手机号"];
        return;
    }else if(![FuncPublic isPureInt:moblieTextField.text] || moblieTextField.text.length != 11){
        [FuncPublic ShowAlert:@"手机号码为11位数字"];
        return;
    }
    if ([FuncPublic IsEmpty:simTextField.text]) {
        [FuncPublic ShowAlert:@"请输入SIM卡号"];
        return;
    }
    [self submitSIM];
 }
@end
