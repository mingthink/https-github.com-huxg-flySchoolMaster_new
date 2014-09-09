//
//  MTAppDelegate.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//
#import "MTAppDelegate.h"
#import "MTStartViewController.h"
#import "MTMainViewController.h"
#import "MTZiYuanViewController.h"
#import "MTSearchViewController.h"
#import "MTSetViewController.h"
#import "MTTabrViewController.h"
#import "FuncPublic.h"
#import "MTMainViewController.h"
#import "MTGKZXViewController.h"
#import "MTNEwsDetailViewController.h"
#import "NSString+SBJSON.h"
#import "SBJSON.h"
#import "SDImageCache.h"
#import "Reachability.h"
#import "WToast.h"
#import "UncaughtExceptionHandler.h"
@implementation MTAppDelegate
{
    NSMutableArray *msgList;
    Reachability *hostReach;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"手机标识;%@",[FuncPublic createUUID]);
    //错误追踪
   // NSSetUncaughtExceptionHandler(&CrashHandlerExceptionHandler);
    InstallUncaughtExceptionHandler();
  //  InstallUncaughtExceptionHandler();
    
//    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    vie.backgroundColor = [UIColor redColor];
//    [self.window insertSubview:vie atIndex:1000];
//  [self.window bringSubviewToFront:vie];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearcahce) name:@"clearcache" object:nil];
    //[UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
    // 设置网络状态变化时的通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                                                 name:@"kNetworkReachabilityChangedNotification" object:nil];
    
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [hostReach startNotifier];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:nil userInfo:nil];
    
    //清除图片缓存
   // [[SDImageCache sharedImageCache]clearDisk];
    // [FuncPublic saveDataToLocal:nil toFileName:@"message.plist"];
    
    
    
    //NSLog(@"DIC IS ;%@",[FuncPublic GetDefaultInfo:@"MessageListData"]);
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filename = [Path stringByAppendingPathComponent:@"savemesstest"];
    
    NSLog(@"文件路径:%@",filename);
    msgList = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
    //  msgList = [FuncPublic GetDefaultInfo:@"MessageListData"];
    if (msgList==NULL)msgList = [NSMutableArray array];
    // 注册推送通知
	[application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    
    [self receiveRemoteNotificationForApp:application launchingOptionS:launchOptions];
    
    
    // Override point for customization after application launch.
    [FuncPublic SaveDefaultInfo:@"5" Key:@"APPVersion"];
    
    [FuncPublic SaveDefaultInfo:@"123" Key:@"dvid"];
    
    MTStartViewController *start = [[MTStartViewController alloc]init];
    
    self.window.rootViewController = start;
    
    return YES;
}
-(void)clearcahce
{
    msgList = [FuncPublic GetDefaultInfo:@"MessageListData"];
    
    if (msgList==NULL)msgList = [NSMutableArray array];
    
}
-(void)reachabilityChanged:(NSNotification *)note
{
    
   
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    //  self.isReachable = YES;
    if(status == NotReachable)
    {
       // [MTAlertView Aletwithstring:@"networkDisabled"];
       // self.isreachable = NO;
        _iswife = 0;
        
        _ismolie = 0;
        [FuncPublic SaveDefaultInfo:@"0" Key:@"iswife"];
        [FuncPublic SaveDefaultInfo:@"0" Key:@"ismobile"];
     //   [FuncPublic SaveDefaultInfo:@"0" toFileName:@"ismobile"];
        
       
        return;
    }
    if (status==ReachableViaWiFi) {
        [FuncPublic SaveDefaultInfo:@"1" Key:@"iswife"];
        [FuncPublic SaveDefaultInfo:@"0" Key:@"ismobile"];
        

        _iswife = 1;
        _ismolie = 0;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"KCFNetChange" object:nil userInfo:nil];
        
    }
    if(status==ReachableViaWWAN)
    {
       // self.isreachable = YES;
        [FuncPublic SaveDefaultInfo:@"0" Key:@"iswife"];
        [FuncPublic SaveDefaultInfo:@"1" Key:@"ismobile"];
        

        _ismolie = 1;
        _iswife = 0;
        [MTAlertView Aletwithstring:@"networkSwitch3G"];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
	NSString *myToken = [deviceToken description];
    myToken = [myToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&lt;&gt;"]];
    myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
	myToken = [myToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
	myToken = [myToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSString *token = [FuncPublic GetDefaultInfo:@"DeviceToken"];
    
    NSLog(@"DeviceToken:---------%@",myToken);
    
    if (![myToken isEqualToString:token]) {
        // 保存deviceToken值
        [FuncPublic SaveDefaultInfo:myToken Key:@"DeviceToken"];
    }
}
// 自定义：APP未启动时处理推送消息处理
- (void)receiveRemoteNotificationForApp:(UIApplication *)application launchingOptionS:(NSDictionary *)launchOptions {
    // 未运行程序时接受到推送
    application.applicationIconBadgeNumber = 0;
	UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    //保存推送消息
    if (launchOptions != nil) {
        NSMutableDictionary *dic = [launchOptions mutableCopy];
        NSMutableDictionary *savedic = [dic objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        NSMutableDictionary *dicc = [[savedic objectForKey:@"custom"]JSONValue];
        [self saveMessage:dicc];
        int module = [[FuncPublic tryObject:dic Key:@"module" Kind:1] intValue];
        [self MessageAction:module param:dic];
    }
    
	if (localNotif) {
        
	}
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
   
    NSMutableDictionary *pushShowMessage = [userInfo objectForKey:@"aps"];//提示消息
    
    //保存推送消息
    if (userInfo != nil) {
       
       
        
        // 收到推送时 播放声音
        if ([pushShowMessage objectForKey:@"sound"] != nil) {
           
            NSString *filePath = [[NSBundle mainBundle] pathForResource:[pushShowMessage objectForKey:@"sound"] ofType:nil];
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
            player.delegate = self;
            [player play];
        }
        NSMutableDictionary *diction = [[userInfo objectForKey:@"custom"]JSONValue];
        
        
        int mod = [[diction objectForKey:@"module"]integerValue];
        
        [self MessageAction:mod param:diction];
        [self saveMessage:diction];
    }
    
    
    
    [FuncPublic ShowAlert:[pushShowMessage objectForKey:@"alert"]];
    
    
    
}
-(void)MessageAction:(int)module param:(NSDictionary *)dic
{
    NSLog(@"comr iiii");
    NSString *urlstr = [dic objectForKey:@"param"];
    if(module==1)
        
    {
        
        MTNEwsDetailViewController *detail = [[MTNEwsDetailViewController alloc]init];
        detail.urlstr = urlstr;
        [self.tab.navigationController pushViewController:detail animated:NO];
        
    }
}
-(void)saveMessage:(NSMutableDictionary*)dic{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"savemesstest"];
   
    int i=0;
    if(msgList!=NULL)
    {
        for (NSMutableDictionary *msgdic in msgList) {
            if ([[msgdic objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                i = 1;
            }
        }
        if (i == 0) {
            [dic setObject:@"1" forKey:@"isreader"];
            [msgList addObject:dic];
            
            [NSKeyedArchiver archiveRootObject:msgList toFile:filename];
            
            // [FuncPublic SaveDefaultInfo:msgList Key:@"MessageListData"];
        }
    }
    else
    {
        [msgList addObject:dic];
        [NSKeyedArchiver archiveRootObject:msgList toFile:filename];
        
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // [self receiveRemoteNotificationForApp:application launchingOptionS:launchOptions];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)changeroot
{
    self.tab = [[MTTabrViewController alloc]init];
    // MTTabrViewController *tab = [[MTTabrViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.tab];
    self.tab.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = nav;
}
-(void)showalert
{
    
    UIAlertView *aleert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"cancel", nil];
    aleert.userInteractionEnabled = YES;
   // [aleert show];
}
@end
void CrashHandlerExceptionHandler(NSException *exception) {
    
   
    NSString *resas = [exception reason];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"应用意外终止" message:resas delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alert show];
     NSLog(@"出错的原因输出数据:%@",[exception callStackSymbols]);
    
    
}
