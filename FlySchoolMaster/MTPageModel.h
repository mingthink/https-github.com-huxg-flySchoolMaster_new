//
//  MTPageModel.h
//  FlySchoolMaster
//
//  Created by caiyc on 14-8-6.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTPageModel : NSObject
@property(nonatomic,retain)NSString *ver;
@property(nonatomic,retain)NSString *ids;
@property(nonatomic,retain)NSString *mainid;
@property(nonatomic,retain)NSString *logo;
@property(nonatomic,retain)NSDictionary *backgroud;
@property(nonatomic,retain)NSDictionary *button;
@property(nonatomic,retain)NSString *pagemode;
@property(nonatomic,retain)NSString *perpage;
+(MTPageModel *)getPageModel;
@end
