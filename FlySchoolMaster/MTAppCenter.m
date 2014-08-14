//
//  MTAppCenter.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-8-12.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTAppCenter.h"
#import "MTPageModel.h"
#import "SVHTTPRequest.h"
#import "UIImageView+webimage.h"
@interface MTAppCenter ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *applist;
    NSMutableArray *listarr;
    NSMutableArray *buttonarr;
    NSMutableArray *dataDic;
    NSMutableArray *searchArr;
    NSString *str;
}
@end

@implementation MTAppCenter

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        listarr = [NSMutableArray array];
        
        buttonarr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    if ([FuncPublic GetDefaultInfo:@"AppList"] == nil) {
        [self getdata];
    }
    else
        listarr = [[NSMutableArray alloc]initWithCapacity:0];
        listarr = [FuncPublic GetDefaultInfo:@"AppList"];
    
    NSLog(@"listarr is ...%@",listarr);
    
    [self drawUI];
    
    
    // Do any additional setup after loading the view from its nib.好遥远
}
-(void)getdata
{
    
    NSDictionary *diss = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    NSString *dvid = [FuncPublic GetDefaultInfo:@"dvid"];
    
    NSString *rid = [diss objectForKey:@"rid"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    
    [dic setObject:dvid forKey:@"dvid"];
    
    [dic setObject:rid forKey:@"rid"];
    
    [SVHTTPRequest GET:@"/api/module/getApplication.html" parameters:dic completion:
     ^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
         NSLog(@"返回信息:%@",response);
         if(error!=nil)
             return ;
         if([[response objectForKey:@"status"]isEqualToString:@"false"])
             return;
         if([[response objectForKey:@"status"]isEqualToString:@"true"])
         {
             NSMutableArray *arrary = [[NSMutableArray alloc]init];
             for (NSMutableDictionary *diction in [response objectForKey:@"data"]) {
                 [arrary addObject:diction];
                 
                 dataDic = arrary;
             }
             
             [FuncPublic SaveDefaultInfo:dataDic Key:@"AppList"];
             NSLog(@"dataDic is....%@",dataDic);
         }
       
    }];
    
}
-(void)drawUI
{
    [FuncPublic InstanceNavgationBar:@"应用中心" action:@selector(back:) superclass:self isroot:NO];
    
    MTPageModel *model = [MTPageModel getPageModel];
    
    NSString *backimastr = [model.backgroud objectForKey:@"otherBg"];
    
    [FuncPublic InstanceImageView:backimastr Ect:@"png" RECT:CGRectMake(0, 60, DEVW, DEVH-110) Target:self.view TAG:2435];
    
    applist = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, DEVW, DEVH-110) style:UITableViewStylePlain];
    
    applist.dataSource = self;
    
    applist.delegate = self;
    
    applist.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:applist];

}
#pragma mark-tableview


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
       if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    [FuncPublic InstanceLabel:[NSString stringWithFormat:@"%@",[[[[listarr objectAtIndex:indexPath.section]objectForKey:@"applications"] objectAtIndex:indexPath.row ] objectForKey:@"name"] ] RECT:CGRectMake(90, 30, 120, 20) FontName:nil Red:0 green:0 blue:0 FontSize:18 Target:cell Lines:0 TAG:0 Ailgnment:0];
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 76, 76)];

    [FuncPublic InstanceLabel:[NSString stringWithFormat:@"%@",[[[[listarr objectAtIndex:indexPath.section]objectForKey:@"applications"] objectAtIndex:indexPath.row ] objectForKey:@"describe"] ] RECT:CGRectMake(90, 60, 150, 15) FontName:nil Red:0 green:0 blue:0 FontSize:12 Target:cell Lines:0 TAG:1 Ailgnment:0];
    NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER,[[[[listarr objectAtIndex:indexPath.section]objectForKey:@"applications"] objectAtIndex:indexPath.row ] objectForKey:@"icon"]]];
    [iconImage setLoadingImageWithURL:iconURL placeholderImage:nil];
     
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"下载" forState:UIControlStateNormal];
        button.frame = CGRectMake(220, 30, 40, 30);
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 0.8;
        button.tintColor = [UIColor blueColor];
        [button addTarget:self action:@selector(downApp:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button];
        [cell addSubview:iconImage];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    searchArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < listarr.count; i++) {
        [searchArr addObject:[[listarr objectAtIndex:i]objectForKey:@"name"]];
    }
    return searchArr;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return listarr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [[listarr objectAtIndex:section]objectForKey:@"name"];
    
    return sectionTitle;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [listarr objectAtIndex:section];
    NSArray *arrary = [dictionary objectForKey:@"applications"];
    return arrary.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:applist titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(12, 0, 200, 22);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    label.text = sectionTitle;
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    //[sectionView setBackgroundColor:[UIColor blackColor]];
    [sectionView addSubview:label];
    return sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
-(void)downApp:(UIButton *)sender
{
    
    NSString *urlstr = @"SharedTest://";
    
    NSURL *url = [NSURL URLWithString:urlstr];
    
    if([[UIApplication sharedApplication]canOpenURL:url])
    {
        [[UIApplication sharedApplication]openURL:url];
        
    }
    else
        {
            NSString *downloadstr = @"http://www.gaokaoApp.cn/";
            
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:downloadstr]];
        }
   }
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
