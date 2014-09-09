//
//  MyDbHandel.m
//  MyFmDbtest
//
//  Created by caiyc on 14-6-24.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MyDbHandel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "MTMudelDaTa.h"
@implementation MyDbHandel
{
    FMDatabase *db;
    NSString *namepath;
}
static MyDbHandel * _sharedDBManager;
+ (MyDbHandel *) defaultDBManager {
	if (!_sharedDBManager) {
		_sharedDBManager = [[MyDbHandel alloc] init];
	}
	return _sharedDBManager;
}

-(BOOL)openDb:(NSString *)str
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:str];
   // namepath = @"myfirsttab22";
  //  namepath = [[[path lastPathComponent]componentsSeparatedByString:@"."]objectAtIndex:0];
  //  NSLog(@"数据库名字是:%@",namepath);
    db = [FMDatabase databaseWithPath:path];
  //  NSLog(@"数据库路径是：%@",path);
    if(![db open])
    {
        NSLog(@"打开数据库失败.....");
        return NO;
    }
    else
       // NSLog(@"打开数据库成功....");
        return YES;
}
-(BOOL)creatTab:(NSString *)sql
{
    
    if(![db open])
    {
        
        return NO;
    }
    else if ([db executeUpdate:sql])
    {
      //  NSLog(@"创建表成功.....");
        [db close];
        return YES;
    }
    else
    {
         NSLog(@"创建表失败.....");
        [db close];
        return NO;
    }
}
-(BOOL)insertdata:(NSArray *)sql
{
    if(![db open])
           {
               return NO;
           }
    else
    {

    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@",NAME];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
   // NSMutableArray * arguments = [NSMutableArray arrayWithCapacity:5];
       if ([sql objectAtIndex:0]) {
        [keys appendString:@"icon,"];
        [values appendString:@"?,"];
        //[arguments addObject:user.name];
       }
       if ([sql objectAtIndex:1]) {
        [keys appendString:@"id,"];
        [values appendString:@"?,"];
       // [arguments addObject:user.description];
       }
        
        if ([sql objectAtIndex:2]) {
            [keys appendString:@"mode,"];
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:3]) {
            [keys appendString:@"name,"];
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:4]) {
            [keys appendString:@"num,"];
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:5]) {
            [keys appendString:@"param,"];
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:6]) {
            [keys appendString:@"status,"];
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if ([sql objectAtIndex:7]) {
            [keys appendString:@"ver,"];
            [values appendString:@"?,"];
            // [arguments addObject:user.description];
        }
        if([sql objectAtIndex:8])
        {
            [keys appendString:@"mouname,"];
            [values appendString:@"?,"];
        }
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
    [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
    [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
  //  NSLog(@"%@",query);
   // [AppDelegate showStatusWithText:@"插入一条数据" duration:2.0];
    [db executeUpdate:query withArgumentsInArray:sql];
    [db close];
    return YES;
    }

//   if(![db open])
//   {
//       return NO;
//   }
//    FMResultSet *rs = [db executeQuery:sql];
//    if([rs next])
//    {
//        [db executeUpdate:sql];
//        return YES;
//    }
//    else
//    {
//        [db executeQuery:sql];
//        return YES;
//    }
}
-(BOOL)deletedata:(NSString *)ids
{
    if(![db open])
    {
        return NO;
    }
    else
    {
    
        [db executeUpdate:ids];
        [db close];
        return YES;
    }
}
-(NSArray *)select:(NSString *)sql
{
  //  NSLog(@"chacun语句是:%@",sql);
    if(![db open])
    {
        //return ;
    }
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    FMResultSet *rs = [db executeQuery:sql];
  //  NSLog(@"rs is %@",[rs columnNameForIndex:0]);
    while ([rs next]) {
       
    MTMudelDaTa *MDdata = [[MTMudelDaTa alloc]init];
    
    MDdata.icon = [rs stringForColumnIndex:0];
       
    MDdata.ids = [rs stringForColumnIndex:1];
    MDdata.mode = [rs stringForColumnIndex:2];
    MDdata.name = [rs stringForColumnIndex:3];
    MDdata.num = [[rs stringForColumnIndex:4]integerValue];
    MDdata.param = [rs stringForColumnIndex:5];
    MDdata.status = [rs stringForColumnIndex:6];
    MDdata.ver = [rs stringForColumnIndex:7];
        MDdata.moudname = [rs stringForColumnIndex:8];
    [arr addObject:MDdata];
        
      //  NSLog(@"图标名字%@",MDdata.name);
}
    [db close];
    return arr;
}
-(NSString *)jsonwrite:(NSString *)sql
{
    
    
    if(![db open])
    {
        return @"";
    }
    NSMutableArray *arr1 = [NSMutableArray array];
    //[arr removeAllObjects];
    FMResultSet *rs = [db executeQuery:sql];
    NSString *str = @"[";
    while ([rs next]) {
        str = @"{";
        int k = [rs columnCount];
        for(int n= 0;n<k;n++)
        {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"\"%@",[rs columnNameForIndex:n]]];
    
        str = [str stringByAppendingString:@"\""];
        str = [str stringByAppendingString:@":"];
        str = [str stringByAppendingString:@"\""];
        NSString *str1 = [rs stringForColumnIndex:n];
        str = [str stringByAppendingString:str1];
        str = [str stringByAppendingString:@"\""];
        if(n<k-1)
        {
        str = [str stringByAppendingString:@","];
        }
 
        }
        str = [str stringByAppendingString:@"}"];
        [arr1 addObject:str];
        }
   
    str = [arr1 componentsJoinedByString:@","];
    str = [str stringByAppendingString:@"]"];
    NSString *tempstr = @"[";
    str = [tempstr stringByAppendingString:str];
    [db close];
    return str;
}
-(BOOL)updata:(NSString *)sql
{
    if(![db open])
    {
       
        return NO;
    }
    else
    {
        
        [db executeUpdate:sql];
        [db close];
        return YES;
    }

}
@end
