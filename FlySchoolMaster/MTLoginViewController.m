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
@interface MTLoginViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    int kbheigh;
    NSArray *rolesarr;
    NSString *rolseid;
}
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
-(void)viewWillAppear:(BOOL)animated
{
    RolesLiset.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"进入登陆界面...........");
    [self getroles];
    RolesLiset.delegate = self;
    RolesLiset.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    NumTf.delegate = self;
    YanzTf.delegate = self;
    RolesTf.delegate = self;
    // [FuncPublic InstanceImageView:@"logooo" Ect:@"png" RECT:CGRectMake(120, 300, 80, 80) Target:self.view TAG:1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(misskeyboad)];
    tap.delegate = self;
    [backscro addGestureRecognizer:tap];
}
-(void)getroles
{
   // NSLog(@"本地角色数据:%@",[FuncPublic GetDefaultInfo:@"roleslist"]);
    if([FuncPublic GetDefaultInfo:@"roleslist"]==nil)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setObject:[FuncPublic createUUID] forKey:@"r"];
        
        [SVHTTPRequest GET:@"/api/role/"
                parameters:dic
                completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error)
         {
             NSLog(@"网络请求的角色接口数据:%@",response);
             if([[response objectForKey:@"status"]isEqualToString:@"true"])
             {
                 NSArray *arr = [response objectForKey:@"data"];
                 [FuncPublic SaveDefaultInfo:arr Key:@"roleslist"];
                 rolesarr = arr;
                 [RolesLiset reloadData];
             }
         }];
    }
    else
    {
        rolesarr = [FuncPublic GetDefaultInfo:@"roleslist"];
        [RolesLiset reloadData];
    }
    
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    RolesLiset.hidden = YES;
    [backscro setContentOffset:CGPointZero animated:YES];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)misskeyboad
{
    RolesLiset.hidden = YES;
    [NumTf resignFirstResponder];
    [YanzTf resignFirstResponder];
    [RolesTf resignFirstResponder];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //    if ([touch.view isKindOfClass:[UITableView class]])
    //    {
    //        return NO;
    //    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    RolesLiset.hidden = YES;
    if(DEVH<568)
    {
        int contset=0;
        if(textField==YanzTf)
        {
            contset=40;
        }
        if(textField==RolesTf)
        {
            
            contset=100;
        }
        [backscro setContentOffset:CGPointMake(0, contset) animated:YES];
    }
    else
    {
        if(textField==RolesTf)
            [backscro setContentOffset:CGPointMake(0, 30) animated:YES];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    RolesLiset.hidden = YES;
    [YanzTf becomeFirstResponder];
    if(textField==YanzTf)
        [RolesTf becomeFirstResponder];
    if(textField==RolesTf)
        [self login:nil];
    if(DEVH<568)
    {
        if(textField==RolesTf)
        {
            
            [backscro setContentOffset:CGPointMake(0, 60) animated:YES];
        }
    }
    return YES;
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
    if(![RolesTf.text isEqualToString:@""])
    {
        RolesLiset.hidden = YES;
    }
    [NumTf resignFirstResponder];
    [YanzTf resignFirstResponder];
    [RolesTf resignFirstResponder];
}
- (IBAction)login:(UIButton *)sender {
    RolesLiset.hidden = YES;
    [NumTf resignFirstResponder];
    [YanzTf resignFirstResponder];
    [RolesTf resignFirstResponder];
    if([NumTf.text isEqualToString:@""])
    {
        [MTAlertView Aletwithstring:@"needUserName"];
        return;
    }
    if([YanzTf.text isEqualToString:@""])
    {
        [MTAlertView Aletwithstring:@"needPWD"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [dic setObject:YanzTf.text forKey:@"password"];
    [dic setObject:NumTf.text forKey:@"loginName"];
    [dic setObject:@"1" forKey:@"dvtype"];
    [dic setObject:rolseid forKey:@"rid"];
    [dic setObject:@"123" forKey:@"dvid"];
    [dic setObject:@"login" forKey:@"action"];
    [SVHTTPRequest GET:@"/action/common.ashx"
            parameters:dic
            completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                 NSLog(@"登陆的链接信息：%@",response);
                
                if(error!=nil)
                {
                  //  NSLog(@"登陆失败......%@",error);
                    [WToast showWithText:kMessage];
                    return ;
                }
                else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
                {
                    [FuncPublic SaveDefaultInfo:[response objectForKey:@"data"] Key:@"Newuser"];
                    [self getvision];
                    [self getPageInfo];
                    [self getinfostr];
                }
                else
                {
                    [MTAlertView Aletwithstring:@"userLoginError"];
                    return;
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                MTAppDelegate *app = (MTAppDelegate *)[[UIApplication sharedApplication]delegate];
                [app changeroot];
            }];
    
}

- (IBAction)selctroles:(UIButton *)sender {
    // NSLog(@"select......");
    RolesLiset.hidden = !RolesLiset.hidden;
}

- (IBAction)support:(UIButton *)sender {
    NSLog(@"support......");
}

- (IBAction)selectroless:(UIButton *)sender {
    RolesLiset.hidden = YES;
    RolesTf.text=sender.titleLabel.text;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return rolesarr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [[rolesarr objectAtIndex:indexPath.row]objectForKey:@"DisplayName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rolsname = [[rolesarr objectAtIndex:indexPath.row]objectForKey:@"DisplayName"];
    rolseid = [[rolesarr objectAtIndex:indexPath.row]objectForKey:@"RoleID"];
    RolesTf.text = rolsname;
    // NSLog(@"role text：%@",rolsname);
    RolesLiset.hidden = YES;
}
//判断各个接口版本
-(void)getvision
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:[FuncPublic createUUID] forKey:@"r"];//uuid
    
    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    [param setObject:[userdic objectForKey:@"id"] forKey:@"uid"];
    
    [param setObject:[userdic objectForKey:@"rid"] forKey:@"rid"];
    
    [SVHTTPRequest GET:@"/api/module/version.html"
            parameters:param
            completion:^(NSMutableDictionary *response, NSHTTPURLResponse *urlResponse, NSError *error) {
                if(error!=nil)
                    return ;
                
                if([[response objectForKey:@"status"]isEqualToString:@"false"])
                    return;
                
                NSString *status = [FuncPublic tryObject:response Key:@"status" Kind:1]  ;
                
                if ([status isEqualToString:@"true"]) {
                    NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
                    
                    NSString *fielpath = nil;
                    
                    //  NSString *fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",CachePath]];
                    
                    NSFileManager *filemanger = [NSFileManager defaultManager];
                    
                    if([[FuncPublic GetDefaultInfo:@"APPVersions"]count]!=0)
                    {
                        //整个框架的版本
                        NSString *vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"iosVerCode"];
                        
                        NSString *nowvision = [[response objectForKey:@"data"]objectForKey:@"iosVerCode"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            
                        }
                        //模块定义接口的版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"modulesVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"modulesVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            
                            // [[NSNotificationCenter defaultCenter]postNotificationName:@"freshMoudledata" object:nil];
                            
                            fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",CachePath]];
                            
                            [filemanger removeItemAtPath:fielpath error:nil];
                            
                        }
                        //界面定义接口的版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"baseVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"baseVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [self getPageInfo];
                        }
                        //应用中心的接口版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"applicationsVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"applicationsVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [FuncPublic SaveDefaultInfo:nil Key:@"AppList"];
                            // [[NSNotificationCenter defaultCenter]postNotificationName:@"freshAppcenterData" object:nil];
                        }
                        
                        //消息提示接口的版本
                        vision = [[FuncPublic GetDefaultInfo:@"APPVersions"]objectForKey:@"noticeMsgVer"];
                        
                        nowvision = [[response objectForKey:@"data"]objectForKey:@"noticeMsgVer"];
                        
                        if(![vision isEqualToString:nowvision])
                        {
                            [self getinfostr];
                            
                        }
                        
                        NSDictionary *dic = [response objectForKey:@"data"];
                        
                        [FuncPublic SaveDefaultInfo:dic Key:@"APPVersions"];
                        
                        
                    }
                    else{
                        NSDictionary *dic = [response objectForKey:@"data"];
                        
                        [FuncPublic SaveDefaultInfo:dic Key:@"APPVersions"];
                    }
                }
            }];
    
}
//得到界面的配置风格数据
-(void)getPageInfo
{
    NSDictionary *dic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    NSMutableDictionary *dci = [NSMutableDictionary dictionary];
    
    [dci setObject:[dic objectForKey:@"rid"] forKey:@"rid"];
    
    [dci setObject:[dic objectForKey:@"id"] forKey:@"id"];
    
    [dci setObject:[FuncPublic createUUID] forKey:@"r"];
    
    [SVHTTPRequest GET:@"/api/module/base.html" parameters:dci completion:
     ^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
         NSLog(@"界面定义数据:----->>>>>>%@",response);
         if(error!=nil)
         {
             [WToast showWithText:kMessage];
             return ;
         }
         else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
         {
             [FuncPublic saveDataToLocal:response toFileName:PaGeCtrlCache];
         }
     }];
}
//得到全局的消息提示
-(void)getinfostr
{
    NSDictionary *dic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[FuncPublic createUUID] forKey:@"r"];
    
    [dict setObject:[dic objectForKey:@"id"] forKey:@"dvid"];
    
    [dict setObject:[dic objectForKey:@"rid"] forKey:@"role"];
    
    [SVHTTPRequest GET:@"/api/module/getNoticeMsg.html" parameters:dict completion:
     ^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
         if(error!=nil)
         {
             [WToast showWithText:@"获取提示信息失败"];
             return ;
         }
         else if ([[response objectForKey:@"status"]isEqualToString:@"true"])
         {
             [FuncPublic saveDataToLocal:response toFileName:UserAletInfo];
         }
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
