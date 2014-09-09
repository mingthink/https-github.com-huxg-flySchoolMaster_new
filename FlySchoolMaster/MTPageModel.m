//
//  MTPageModel.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-8-6.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTPageModel.h"

@implementation MTPageModel
+(MTPageModel *)getPageModel
{
    MTPageModel *model = [[MTPageModel alloc]init];
    NSString *fiel = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *fielpath = [fiel stringByAppendingString:[NSString stringWithFormat:@"/FileDocuments/%@",PaGeCtrlCache]];
    NSDictionary * ddict = [[NSDictionary alloc]initWithContentsOfFile:fielpath];
    NSDictionary *dic = [ddict objectForKey:@"data"];
    model.ver = [dic objectForKey:@"ver"];
    model.ids = [dic objectForKey:@"id"];
    model.mainid = [dic objectForKey:@"mainID"];
    model.logo = [dic objectForKey:@"logo"];
    model.backgroud = [dic objectForKey:@"background"];
    model.button = [dic objectForKey:@"button"];
    model.pagemode = [dic objectForKey:@"pageMode"];
    model.perpage = [dic objectForKey:@"perPage"];
    return model;

}
@end
