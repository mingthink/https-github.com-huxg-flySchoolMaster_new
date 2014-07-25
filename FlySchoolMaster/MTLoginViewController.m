//
//  MTLoginViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTLoginViewController.h"
#import "SVHTTPRequest.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "MTAppDelegate.h"
@interface MTLoginViewController ()<UITextFieldDelegate>

@end

@implementation MTLoginViewController

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
    NumTf.delegate = self;
    YanzTf.delegate = self;
    [FuncPublic InstanceImageView:@"logooo" Ect:@"png" RECT:CGRectMake(120, 300, 80, 80) Target:self.view TAG:1];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getYanZ:(UIButton *)sender {
    [NumTf resignFirstResponder];
    [YanzTf resignFirstResponder];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [dic setObject:NumTf.text forKey:@"mobilenumber"];
    [dic setObject:@"sendValidateCode" forKey:@"action"];
    [SVHTTPRequest GET:@"/action/common.ashx"
                  parameters:dic
                  completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                      if(error!=nil)
                      {
                          [WToast showWithText:kMessage];
                          return ;
                      }
                      else if([[response objectForKey:@"status"]isEqualToString:@"false"])
                      {
                          if([[[response objectForKey:@"data"]objectForKey:@"msg"]isEqualToString:@"empty_args_mobilenumber"])
                          {
                              [WToast showWithText:@"手机号码不能未空"];
                          }
                          if([[[response objectForKey:@"data"]objectForKey:@"msg"]isEqualToString:@"mobilenumber_format_error"])
                          {
                              [WToast showWithText:@"手机号码格式错误"];
                          }
                          if([[[response objectForKey:@"data"]objectForKey:@"msg"]isEqualToString:@"not_exist_master"])
                          {
                              [WToast showWithText:@"不存在该校长"];
                          }
                      }
                      else
                      {
                          [WToast showWithText:@"短信发送成功"];
                      }
                     
                  }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NumTf resignFirstResponder];
    [YanzTf resignFirstResponder];
}
- (IBAction)login:(UIButton *)sender {
    [NumTf resignFirstResponder];
    [YanzTf resignFirstResponder];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [dic setObject:YanzTf.text forKey:@"password"];
    [dic setObject:NumTf.text forKey:@"djxm"];
  //  [dic setObject:@"login" forKey:@"action"];
    [SVHTTPRequest GET:@"/api/test/"
                  parameters:dic
                  completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                      NSLog(@"登陆返回信息:----%@",response);
                      if(error!=nil)
                      {
                          [WToast showWithText:kMessage];
                          return ;
                      }
                      else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
                      {
                          [FuncPublic SaveDefaultInfo:[response objectForKey:@"data"] Key:@"Newuser"];
                      }
                      [self dismissViewControllerAnimated:YES completion:nil];
                      MTAppDelegate *app = [[UIApplication sharedApplication]delegate];
                      [app changeroot];
                      /*
                      else if ([[response objectForKey:@"status"]isEqualToString:@"false"])
                      {
                          if([[[response objectForKey:@"data"]objectForKey:@"msg"]isEqualToString:@"not_exist_master"])
                          {
                              [WToast showWithText:@"不存在该校长"];
                          }
                          if([[[response objectForKey:@"data"]objectForKey:@"msg"]isEqualToString:@"validateCode_error"])
                          {
                              [WToast showWithText:@"验证码错误"];
                          }
                          if([[[response objectForKey:@"data"]objectForKey:@"msg"]isEqualToString:@"empty_args_validateCode"])
                          {
                              [WToast showWithText:@"验证码为空"];
                          }
                          if([[[response objectForKey:@"data"]objectForKey:@"msg"]isEqualToString:@"empty_args_mobilenumber"])
                          {
                              [WToast showWithText:@"手机号码为空"];
                          }
                      }
                      else
                      {
                          [WToast showWithText:@"登陆成功"];
                          NSString *mobile = [[response objectForKey:@"data"]objectForKey:@"mobilenumber"];
                          [FuncPublic SaveDefaultInfo:mobile Key:@"mobilenumber"];
                          NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
                          [dict setObject:[FuncPublic GetDefaultInfo:@"mobilenumber"] forKey:@"mobilenumber"];
                          [dict setObject:[FuncPublic createUUID] forKey:@"r"];
                          [SVHTTPRequest GET:@"/api/schoolmaster/getSchoolmasterInfo.html"
                                        parameters:dict
                                        completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                                            if(error!=nil)
                                            {
                                                [WToast showWithText:kMessage];
                                                return ;
                                            }
                                            if([[response objectForKey:@"status"]isEqualToString:@"true"])
                                            {
                                                NSString *authocode = [[response objectForKey:@"data"]objectForKey:@"authCode"];
                                                [FuncPublic SaveDefaultInfo:authocode Key:@"authCode"];
                                                [FuncPublic SaveDefaultInfo:[[response objectForKey:@"data"]objectForKey:@"zxdm" ] Key:@"zxdm"];
                                                [FuncPublic SaveDefaultInfo:[[response objectForKey:@"data"]objectForKey:@"zxmc" ] Key:@"zxmc"];
                                                [FuncPublic SaveDefaultInfo:[[response objectForKey:@"data"]objectForKey:@"djxm"] Key:@"xzxm"];
                                                
                                            }
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            MTAppDelegate *app = [[UIApplication sharedApplication]delegate];
                                            [app changeroot];
                                        }];
                          
                          
                          
                          
                      }
                       */
                  }];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    int lengthe = 0;
    if(textField==NumTf)
    {
        lengthe = 11;
    }
    if(textField==YanzTf)
    {
        lengthe=6;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length >= lengthe && range.length!=1){
        textField.text = [toBeString substringToIndex:lengthe];
        return NO;
        
    }
    
    return YES;
}
@end
