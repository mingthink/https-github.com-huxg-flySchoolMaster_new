//
//  UncaughtExceptionHandler.m
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import "FuncPublic.h"
#import "SVHTTPRequest.h"
#import "MTAlertView.h"
#import "MTAppDelegate.h"


NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation UncaughtExceptionHandler
{
    NSString *debugreson;
    UIAlertView *alert;
}

+ (NSArray *)backtrace
{
	 void* callstack[128];
	 int frames = backtrace(callstack, 128);
	 char **strs = backtrace_symbols(callstack, frames);
	 
	 int i;
	 NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
	 for (
	 	i = UncaughtExceptionHandlerSkipAddressCount;
	 	i < UncaughtExceptionHandlerSkipAddressCount +
			UncaughtExceptionHandlerReportAddressCount;
		i++)
	 {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
	 }
	 free(strs);
	 
	 return backtrace;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [self handel:debugreson];
        
    }
}
- (void)validateAndSaveCriticalApplicationData
{
	
}

- (void)handleException:(NSException *)exception
{
    
    debugreson = [exception reason];
	[self validateAndSaveCriticalApplicationData];
	
	UIAlertView *alertss =
		[[UIAlertView alloc]
			initWithTitle:NSLocalizedString(@"应用意外终止", nil)
			message:[NSString stringWithFormat:NSLocalizedString(
				@"You can try to continue but the application may be unstable.\n\n"
				@"Debug details follow:\n%@", nil),
				[exception reason],
				[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
			delegate:self
			cancelButtonTitle:@"发送报告"
			otherButtonTitles:@"退出" ,nil]
		;
      [alertss show];
//
//   //获取网路状态
//    NSLog(@"当前网络状态:%@",[FuncPublic GetDefaultInfo:@"iswife" ]);
//	NSLog(@"conr this pointtt memory:%f",[self availableMemory]);
//    //手机系统版本
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    NSLog(@"手机系统版本: %@", phoneVersion);
//    //手机型号
//    NSString* phoneModel = [[UIDevice currentDevice] model];
//    
//     NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
//    
//    NSString *datastr = @"\"OS\"";
//  datastr =  [datastr stringByAppendingString:@":"];
//  datastr =  [datastr stringByAppendingString:@"\"ios\","];
//    
//  datastr = [datastr stringByAppendingString:@"\"OSVer\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",phoneVersion]];
//    
//    datastr = [datastr stringByAppendingString:@"\"dvid\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[FuncPublic createUUID]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"phoneModel\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",phoneModel]];
//    
//    double free = [self availableMemory]-[self usedMemory];
//    NSString *freememory = [NSString stringWithFormat:@"%f",free ];
//    datastr = [datastr stringByAppendingString:@"\"freeMem\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",freememory]];
//    
//    NSString *sdfree = @"未知";
//    datastr = [datastr stringByAppendingString:@"\"freeSDcard\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",sdfree]];
//    
//    //获取时间戳
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
//    NSString *timeString = [NSString stringWithFormat:@"%f", a];
//    datastr = [datastr stringByAppendingString:@"\"dateTime\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",timeString]];
//    
//    datastr = [datastr stringByAppendingString:@"\"wifiUsed\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[FuncPublic GetDefaultInfo:@"iswife"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"mobileUsed\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[FuncPublic GetDefaultInfo:@"ismobile"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"mobileUsed\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[FuncPublic GetDefaultInfo:@"ismobile"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"uid\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[userdic objectForKeyedSubscript:@"id"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"rid\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[userdic objectForKeyedSubscript:@"rid"]]];
//    
//    NSDictionary *appvsdic = [FuncPublic GetDefaultInfo:@"APPVersions"];
//    datastr = [datastr stringByAppendingString:@"\"VerCode\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"iosVerCode"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"VerName\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"iosVerCode"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"modulesVer\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"modulesVer"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"applicationsVer\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"applicationsVer"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"noticeMsgVer\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"noticeMsgVer"]]];
//    
//    datastr = [datastr stringByAppendingString:@"\"errLog\":"];
//    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[exception reason]]];
//
////
//    NSLog(@"json is :%@",datastr);
//    
//
//    
//    
//    
//    
//    
//
//
//
//    
//
//
//    
//
//
//    
//
//    
//
//    
//    
//    
//    
//    
//    
//    
//     
//     
//   
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
////    
//   [dic setObject:[FuncPublic createUUID] forKey:@"r"];
////    
////    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
////    
//    NSString *rid = [userdic objectForKeyedSubscript:@"authUser"];
////    
//    NSString *dvid = [userdic objectForKeyedSubscript:@"id"];
//    
//    [dic setObject:rid forKey:@"authUser"];
//    
//    [dic setObject:dvid forKey:@"dvid"];
//    
//    [dic setObject:[FuncPublic emptyStr:datastr] forKey:@"data"];
//    
//    [dic setObject:@"putErrReport" forKey:@"action"];
//    
//    [SVHTTPRequest POST:@"/action/module.ashx" parameters:dic
//    completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//        NSLog(@"response is ；……%@",response);
//    }];
    
    
    
//    NSLog(@"comt this point..........>>>>>>>>>>>>>>>");
    
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed)
	{
       
        
       //  [MTAlertView showalertview:@"程序已自动终止" andleftact:nil andrightact:nil];
		for (NSString *mode in (NSArray *)allModes)
		{
			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
		}
	}
	
	CFRelease(allModes);

	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
	{
         NSLog(@"come this pointtt.......");
		kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[exception raise];
	}
//
}
-(void)showaletview:(NSException *)exception
{
    

   // [NSThread sleepForTimeInterval:5];
  //  NSLog(@"show alertview function.......");
    
//    MTAppDelegate *app = (MTAppDelegate *)[[UIApplication sharedApplication]delegate];
//    [app showalert];
// UIAlertView *   alerts =
//    [[UIAlertView alloc]
//      initWithTitle:NSLocalizedString(@"应用意外终止", nil)
//      message:[NSString stringWithFormat:NSLocalizedString(
//                                                           @"You can try to continue but the application may be unstable.\n\n"
//                                                           @"Debug details follow:\n%@", nil),
//               [exception reason],
//               [[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]]
//      delegate:nil
//      cancelButtonTitle:@"ok"
//      otherButtonTitles:nil, nil]
//     ;
  //  UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
   // [alerts show];
    //[self aletshowe];
   // [self performSelectorOnMainThread:@selector(aletshowe) withObject:nil waitUntilDone:YES];
   // alert.userInteractionEnabled = YES;
	//[alert show];
  //  [self performSelector:@selector(dismissalert:) withObject:alert afterDelay:2];
    
  //  [MTAlertView Aletwithstring:@"此功能出现问题，已发送问题至技术中心"];
   // [MTAlertView showalertview:@"此功能出现问题，已发送问题至技术中心,为了更好体验程序将在5秒自动终止" andleftact:nil andrightact:nil];
   // [self handel:exception];

}
-(void)aletshowe
{
    [alert show];
}
-(void)dismissalert:(UIAlertView *)aler
{
    NSLog(@"comt tis funccccc.......");
    [aler removeFromSuperview];
    aler.alpha = 0;
    aler = nil;
    
}
-(void)click
{
    NSLog(@"click button........");
}
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return YES;
}
-(void)handel:(NSString *)exception
{
    NSLog(@"发送错误报告..................");
    //[NSThread sleepForTimeInterval:5];
    //获取网路状态
   
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    
    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    NSString *datastr = @"{\"OS\"";
    datastr =  [datastr stringByAppendingString:@":"];
    datastr =  [datastr stringByAppendingString:@"\"ios\","];
    
    datastr = [datastr stringByAppendingString:@"\"OSVer\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",phoneVersion]];
    
    datastr = [datastr stringByAppendingString:@"\"dvid\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[FuncPublic createUUID]]];
    
    datastr = [datastr stringByAppendingString:@"\"phoneModel\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",phoneModel]];
    
    double free = [self availableMemory]-[self usedMemory];
    NSString *freememory = [NSString stringWithFormat:@"%f",free ];
    datastr = [datastr stringByAppendingString:@"\"freeMem\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",freememory]];
    
    NSString *sdfree = @"未知";
    datastr = [datastr stringByAppendingString:@"\"freeSDcard\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",sdfree]];
    
    //获取时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    datastr = [datastr stringByAppendingString:@"\"dateTime\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",timeString]];
    
    datastr = [datastr stringByAppendingString:@"\"wifiUsed\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[FuncPublic GetDefaultInfo:@"iswife"]]];
    
    datastr = [datastr stringByAppendingString:@"\"mobileUsed\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[FuncPublic GetDefaultInfo:@"ismobile"]]];
    
    datastr = [datastr stringByAppendingString:@"\"mobileUsed\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[FuncPublic GetDefaultInfo:@"ismobile"]]];
    
    datastr = [datastr stringByAppendingString:@"\"uid\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[userdic objectForKeyedSubscript:@"id"]]];
    
    datastr = [datastr stringByAppendingString:@"\"rid\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[userdic objectForKeyedSubscript:@"rid"]]];
    
    NSDictionary *appvsdic = [FuncPublic GetDefaultInfo:@"APPVersions"];
    datastr = [datastr stringByAppendingString:@"\"VerCode\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"iosVerCode"]]];
    
    datastr = [datastr stringByAppendingString:@"\"VerName\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"iosVerCode"]]];
    
    datastr = [datastr stringByAppendingString:@"\"modulesVer\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"modulesVer"]]];
    
    datastr = [datastr stringByAppendingString:@"\"applicationsVer\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"applicationsVer"]]];
    
    datastr = [datastr stringByAppendingString:@"\"noticeMsgVer\":"];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\",",[appvsdic objectForKeyedSubscript:@"noticeMsgVer"]]];
    
    datastr = [datastr stringByAppendingString:@"\"errLog\":"];
    exception = [[exception componentsSeparatedByString:@"0"]objectAtIndex:0];
    NSString *changestr = [exception stringByReplacingOccurrencesOfString:@"{" withString:@" "];
    changestr = [changestr stringByReplacingOccurrencesOfString:@"}" withString:@" "];
    changestr = [changestr stringByReplacingOccurrencesOfString:@"\"" withString:@" "];
    changestr = [changestr stringByReplacingOccurrencesOfString:@":" withString:@" "];
    changestr = [changestr stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    changestr = [changestr stringByReplacingOccurrencesOfString:@"[" withString:@" "];
    changestr = [changestr stringByReplacingOccurrencesOfString:@"]" withString:@" "];
    datastr = [datastr stringByAppendingString:[NSString stringWithFormat:@"\"%@\"}",changestr]];
    
    //
    NSLog(@"json is :%@",datastr);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    //
    //    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
    //
    NSString *rid = [userdic objectForKeyedSubscript:@"authCode"];
    //
    NSString *dvid = [userdic objectForKeyedSubscript:@"id"];
    
    [dic setObject:rid forKey:@"authUser"];
    
    [dic setObject:dvid forKey:@"dvid"];
    
    [dic setObject:[FuncPublic emptyStr:datastr] forKey:@"data"];
    
    [dic setObject:@"putErrReport" forKey:@"action"];
    
    [SVHTTPRequest POST:@"/action/common.ashx" parameters:dic
             completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                 NSLog(@"返回信息 :……>>>%@",response);
               if([[response objectForKey:@"status"]isEqualToString:@"true"])
               {
                   dismissed = YES;
               }
             }];
    
    
    
   // NSLog(@"comt this point..........>>>>>>>>>>>>>>>");
   // [self hangdele:exception];
   // [self performSelectorOnMainThread:@selector(hangdele:) withObject:exception waitUntilDone:YES];
    //[NSThread sleepForTimeInterval:5];

}
-(void)hangdele:(NSException *)exception
{
   	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
   	while (!dismissed)
   	{
   		for (NSString *mode in (NSArray *)allModes)
   	{
   			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
   		}
  	}
   
   	CFRelease(allModes);
   
  	NSSetUncaughtExceptionHandler(NULL);
    	signal(SIGABRT, SIG_DFL);
  	signal(SIGILL, SIG_DFL);
 	signal(SIGSEGV, SIG_DFL);
    	signal(SIGFPE, SIG_DFL);
    	signal(SIGBUS, SIG_DFL);
    	signal(SIGPIPE, SIG_DFL);
    
  	if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
   	{
          //  NSLog(@"come this pointtt.......");
   		kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
   	}
    	else
   	{
    		[exception raise];
   	}

}
// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}
// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}
@end

void HandleException(NSException *exception)
{
   
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSArray *callStack = [UncaughtExceptionHandler backtrace];
	NSMutableDictionary *userInfo =
		[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[[UncaughtExceptionHandler alloc] init] autorelease]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:[exception name]
				reason:[exception reason]
				userInfo:userInfo]
		waitUntilDone:YES];
}

void SignalHandler(int signal)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSMutableDictionary *userInfo =
		[NSMutableDictionary
			dictionaryWithObject:[NSNumber numberWithInt:signal]
			forKey:UncaughtExceptionHandlerSignalKey];

	NSArray *callStack = [UncaughtExceptionHandler backtrace];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[[UncaughtExceptionHandler alloc] init] autorelease]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
				reason:
					[NSString stringWithFormat:
						NSLocalizedString(@"Signal %d was raised.", nil),
						signal]
				userInfo:
					[NSDictionary
						dictionaryWithObject:[NSNumber numberWithInt:signal]
						forKey:UncaughtExceptionHandlerSignalKey]]
		waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler(void)
{
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

