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
@interface MTAppCenter ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *applist;
    NSMutableArray *listarr;
    NSMutableArray *buttonarr;
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
    
//    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(getdata) object:nil];
//    
//    [thread start];
    
   // [self loaddata];
    
    [self getdata];
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listarr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    UIImageView *icon = [[UIImageView alloc]init];
    
    UILabel *appname = [[UILabel alloc]init];
    
    UIButton *downbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    downbtn.tag = indexPath.row;
    
    [downbtn addTarget:self action:@selector(downApp:) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL canopern = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"SharedTest://"]];
    
    [downbtn setTitle:canopern?@"打开":@"下载" forState:UIControlStateNormal];
    
    [downbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [buttonarr addObject:downbtn];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
        NSString *iconstr = [[listarr objectAtIndex:indexPath.row]objectForKey:@"iconname"];
        
        NSString *appnamestr = [[listarr objectAtIndex:indexPath.row]objectForKey:@"appname"];
        
        icon.frame = CGRectMake(10, 5, 48, 48);
        
        icon.image = [UIImage imageNamed:iconstr];
        
        appname.frame = CGRectMake(65, 20, 100, 20);
        
        appname.font = [UIFont systemFontOfSize:14.0f];
        
        appname.text = appnamestr;
        
        downbtn.frame = CGRectMake(250, 20, 50, 30);
        
        [cell.contentView addSubview:icon];
        
        [cell.contentView addSubview:appname];
        
        [cell.contentView addSubview:downbtn];
    }
    
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
