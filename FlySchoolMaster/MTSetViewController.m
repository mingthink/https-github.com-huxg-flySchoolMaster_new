//
//  MTSetViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTSetViewController.h"
#import "FuncPublic.h"
#import "MTLoginViewController.h"
#import "WToast.h"
#import "SVHTTPRequest.h"
#import "MTAboutViewController.h"
#import "MTNotiMessageViewController.h"
#import "MTCusetViewController.h"
#import "MTPageModel.h"
#import "UIImageView+webimage.h"
#import "SDImageCache.h"
#import "MTAlertView.h"
#import "MTAppCenter.h"

@interface MTSetViewController ()<UIAlertViewDelegate>
{
    
    UILabel *selectlabel;
}
@end

@implementation MTSetViewController

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
   
//    _switchs.On = [FuncPublic GetDefaultInfo:@"SelectServers"]?YES:NO;
//    _selectLabel.text = _switchs.on?@"测试版":@"发布版";
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [FuncPublic InstanceNavgationBar:@"设置" action:nil superclass:self isroot:YES];
    
    MTPageModel *model = [MTPageModel getPageModel];
    
    NSString *backstr = [model.backgroud objectForKey:@"otherBg"];
    
    UISwitch *swicts = [[UISwitch alloc]initWithFrame:CGRectMake(80, 70, 60, 40)];
   // swicts.on = [FuncPublic GetDefaultInfo:@"SelectServers"]?YES:NO;
   // swicts.on = NO;
    BOOL isswitchon = [[FuncPublic GetDefaultInfo:@"SelectServers"]boolValue];
    if(isswitchon)
        swicts.on = YES;
    if(isswitchon==NO)
        swicts.on = NO;
    [swicts addTarget:self action:@selector(switchclick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:swicts];
    selectlabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 70, 80, 30)];
    selectlabel.text = swicts.isOn?@"测试版":@"发布版";
    [self.view addSubview:selectlabel];
    
    
    self.backimagee.image = [UIImage imageNamed:backstr];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)select:(UIButton *)sender {
    if(sender.tag==5)
    {
        MTCusetViewController *cuset = [[MTCusetViewController alloc]
                                        init];
        [self.navigationController pushViewController:cuset animated:NO];
    }
    if(sender.tag==4)
    {
        MTNotiMessageViewController *notimesage = [[MTNotiMessageViewController alloc]initWithNibName:@"MTNotiMessageViewController" bundle:nil];
        
        [self.navigationController pushViewController:notimesage animated:NO];
    }
    if(sender.tag==1)
    {
        UIAlertView *alet = [[UIAlertView alloc]initWithTitle:@"注销提醒" message:@"确定注销吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        alet.delegate = self;
        
        [alet show];
        
    }
    if(sender.tag==2)
    {
        MTAboutViewController *about = [[MTAboutViewController alloc]init];
        
        [self.navigationController pushViewController:about animated:NO];
        
    }
    if(sender.tag==3)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        
        [dic setObject:[FuncPublic createUUID] forKey:@"r"];
        
        [SVHTTPRequest GET:@"/api/base/iosUpdate.html"
                parameters:dic
                completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(error!=nil)
                    {
                        [WToast showWithText:kMessage];
                        return ;
                    }
                    else if([[response objectForKey:@"status"]isEqualToString:@"true"])
                    {
                        NSString *url = [[response objectForKey:@"data"]objectForKey:@"file"];
                        
                        NSString *versioncode = [[response objectForKey:@"data"]objectForKey:@"versionCode"];
                        
                        NSDictionary *dicc = [FuncPublic GetDefaultInfo:@"APPVersions"] ;
                        

                        if (dicc !=nil && [[dicc objectForKey:@"baseVer"] isEqualToString:versioncode])
                        {
                            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"已是最新版本" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                            
                            [aler show];
                            
                        }
                        else
                        {
                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
                        }
                    }
                }];
    }
    
}

- (IBAction)clearcache:(id)sender {
    //plist文件里面删除某行操作
    // [FuncPublic SaveDefaultInfo:nil Key:@"APPVersions"];
    
    MTAppCenter *appcenter = [[MTAppCenter alloc]initWithNibName:@"MTAppCenter" bundle:nil];
    
    [self.navigationController pushViewController:appcenter animated:NO];
    
}

- (void)switchclick:(UISwitch *)sender {
    NSString *str = selectlabel.text;
    selectlabel.text = [str isEqualToString:@"测试版"]?@"发布版":@"测试版";
    [FuncPublic SaveDefaultInfo:[NSNumber numberWithBool:sender.on] Key:@"SelectServers"];

    }

-(void)clearCacheSuccess
{
  //  NSLog(@"清理成功");
}

-(void)close
{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [FuncPublic SaveDefaultInfo:nil Key:@"Newuser"];
        
        NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
        NSString *fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",CachePath]];
        
        NSString *fielpath1 = [fiel stringByAppendingString:DBName];
        NSString *fielpath2 = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingString:@"/Preferences/edu.mt.FS.plist"];
        
        NSFileManager *Fm = [NSFileManager defaultManager];
        
        [Fm removeItemAtPath:fielpath error:nil];
        
        [Fm removeItemAtPath:fielpath1 error:nil];
        NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
       // [userDefatluts removeObjectForKey:@"roleslist"];
//        NSDictionary *dictions = [userDefatluts dictionaryRepresentation];
//        for(NSString *key in [dictions allKeys])
//        {
//            [userDefatluts removeObjectForKey:key];
//            [userDefatluts synchronize];
//        }
      //  [FuncPublic SaveDefaultInfo:nil Key:@"roleslist"];
//        NSDictionary *dictionary = [userDefaults dictionaryRepresentation];
//        for(NSString* key in [dictionary allKeys]){
//            [userDefaults removeObjectForKey:key];
//            [userDefaults synchronize];
//        }
      //  [Fm removeItemAtPath:fielpath2 error:nil];
        
        MTLoginViewController *login = [[MTLoginViewController alloc]init];
        
        [self presentViewController:login animated:YES completion:nil];
    }
    
}
-(float)getCacheSizeandclear:(BOOL)clears
{
    float sizen = 0;
    
    NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *fielpath = [fiel stringByAppendingPathComponent:DBName];
    
    NSFileManager *FMM = [NSFileManager defaultManager];
    
    long long size1 = [[FMM attributesOfItemAtPath:fielpath error:nil]fileSize];
    if(clears)
    {
        [FMM removeItemAtPath:fielpath error:nil];
    }
    NSString *filepath1 = [fiel stringByAppendingPathComponent:@"/FileDocuments"];
    
    
    NSArray *arr = [FMM subpathsAtPath:filepath1];
    
    long long size2 = 0;
    
    for(NSString *str in arr)
    {
        NSString *filefullpath = [filepath1 stringByAppendingPathComponent:str];
        size2+= [[FMM attributesOfItemAtPath:filefullpath error:nil]fileSize];
        //  [FMM removeItemAtPath:filefullpath error:nil];
    }
    
    
    //图片缓存路径路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachesDir = [paths objectAtIndex:0];
    
    NSString *fullpath = [cachesDir stringByAppendingString:@"/ImageCache"];
    
    NSArray *arr1 = [FMM subpathsAtPath:fullpath];
    
    long long size3 = 0;
    
    for(NSString *strs in arr1)
    {
        NSLog(@"图片的缓存路径:%@",strs);
        
        NSString *imagepath = [fullpath stringByAppendingPathComponent:strs];
        
        size3+= [[FMM attributesOfItemAtPath:imagepath error:nil]fileSize];
        //  NSLog(@"图片的缓存大小:%2.f",size3);
    }
    if(clears)
    {
        [[SDImageCache sharedImageCache]clearMemory];
    }
    
    sizen = (size1 + size2 + size3)/1024;
    
    
    
    
    
    
    
    return sizen;
}

@end
