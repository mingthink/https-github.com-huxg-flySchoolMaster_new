//
//  MTMudelDaTa.h
//  TEst
//
//  Created by caiyc on 14-7-18.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
[insarr addObject:[[arr objectAtIndex:i]objectForKey:@"createDatetime"]];
[insarr addObject:[[arr objectAtIndex:i]objectForKey:@"id"]];
[insarr addObject:[[arr objectAtIndex:i]objectForKey:@"moduleFlag"]];
[insarr addObject:[[arr objectAtIndex:i]objectForKey:@"moduleImage"]];
[insarr addObject:[[arr objectAtIndex:i]objectForKey:@"moduleName"]];
[insarr addObject:[[arr objectAtIndex:i]objectForKey:@"moduleUrl"]];
[insarr addObject:[[arr objectAtIndex:i]objectForKey:@"sortNumber"]];
[insarr addObject:[[arr objectAtIndex:i]objectForKey:@"status"]];*/
@interface MTMudelDaTa : NSObject
@property(nonatomic,retain)NSString *icon;
@property(nonatomic,retain)NSString *ids;
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,retain)NSString *name;
@property()int  num;
@property(nonatomic,retain)NSString *param;

@property(nonatomic,retain)NSString *status;
@property()NSString *ver;

@end
