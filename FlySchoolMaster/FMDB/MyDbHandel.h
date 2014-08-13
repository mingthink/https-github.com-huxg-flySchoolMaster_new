//
//  MyDbHandel.h
//  MyFmDbtest
//
//  Created by caiyc on 14-6-24.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface MyDbHandel : NSObject
+(MyDbHandel *) defaultDBManager;
-(BOOL)openDb:(NSString *)str;
-(BOOL)creatTab:(NSString *)sql;
-(BOOL)insertdata:(NSArray *)sql;
-(BOOL)deletedata:(NSString *)ids;
-(NSArray *)select:(NSString *)sql;
-(BOOL)updata:(NSString *)sql;
-(NSString *)jsonwrite:(NSString *)sql;
@end
