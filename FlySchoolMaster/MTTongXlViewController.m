//wqeq
//  MTTongXlViewController.m
//  FlySchoolMaster
// sfsdfsdibds是东方酒店送 i 风景
//  Created by caiyc on 14-9-5.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTTongXlViewController.h"
#import "MTCustomBut.h"
#import "MTContrctTable.h"
#import "SVHTTPRequest.h"
#import "WToast.h"
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
@interface MTTongXlViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *mytab;
    UITableView *seatable;
    NSMutableArray *searcharr;
    NSMutableArray *datasource;
    UISearchBar *mysearch;
    // NSArray *arr;
    NSMutableArray *arr;
    NSMutableArray *copyarr;
    NSMutableArray *headviewarr;
    NSMutableArray *buttonsarr;
    BOOL isseach;
    CALayer *celllayer;
}

@end

@implementation MTTongXlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr = [NSMutableArray array];
    copyarr = [NSMutableArray array];
    // arr = [[NSArray alloc]initWithObjects:@"常用电话",@"同事",@"学生家长" ,@"常用",nil];
    
    [self getdatas];
    
    
    [FuncPublic InstanceNavgationBar:@"通讯录" action:@selector(back) superclass:self isroot:NO];
    
    mytab = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, DEVW, DEVH-50-100) style:UITableViewStyleGrouped];
    
    mytab.delegate = self;
    
    
    mytab.dataSource = self;
    
    [self.view addSubview:mytab];
    
    seatable = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, DEVW, DEVH-50-100) style:UITableViewStyleGrouped];
    
    seatable.delegate = self;
    
    
    seatable.dataSource = self;
    
    [self.view addSubview:seatable];
    
    seatable.hidden = YES;
    
    mysearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 60, DEVW-50, 40)];
    
    mysearch.barStyle = UIBarStyleDefault;
    
    mysearch.delegate = self;
    
    [self.view addSubview:mysearch];
    
    UIButton *searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [searchbut setTitle:@"取消搜索" forState:UIControlStateNormal];
    
    searchbut.titleLabel.font = [UIFont systemFontOfSize:12];
    
    searchbut.backgroundColor = [UIColor grayColor];
    
    [searchbut setFrame:CGRectMake(DEVW-50, 60, 50, 40)];
    
    [self.view addSubview:searchbut];
    
    [searchbut addTarget:self action:@selector(srarchclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark datahandel
-(void)getdatas
{
    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    NSString *oid = [userdic objectForKey:@"organID"];
    
    NSString *ids = [userdic objectForKey:@"id"];
    
    NSMutableDictionary *dcit = [NSMutableDictionary dictionary];
    
    [dcit setObject:oid  forKey:@"oid"];
    
    [dcit setObject:ids forKey:@"uid"];
    
    [dcit setObject:[FuncPublic getDvid] forKey:@"dvid"];
    
    [dcit setObject:[FuncPublic createUUID] forKey:@"r"];
    
    [SVHTTPRequest GET:@"/api/contact/" parameters:dcit completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
       // NSLog(@"请求的返回数据:%@",response);
        if([[response objectForKey:@"status"]isEqualToString:@"true"])
        {
            arr = [response objectForKey:@"data"];
            
            [mytab reloadData];
            
            [self tablehead:arr];
            
        }
        //   NSLog(@"请求的返回数据:%d",[[response objectForKey:@"data"]count]);
    }];
    
    
    
}
-(void)tablehead:(NSMutableArray *)arrs
{
    headviewarr = [NSMutableArray array];
    
    buttonsarr = [NSMutableArray array];
    
    for(int i=0;i<arrs.count;i++)
    {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        
        v.backgroundColor = [UIColor darkGrayColor];
        
        MTCustomBut *buttons = [[MTCustomBut alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        
        NSString *btntitle = [[arrs objectAtIndex:i]objectForKey:@"cateName"];
        
        [buttons setTitle:btntitle forState:UIControlStateNormal];
        
        // [buttons setBackgroundColor:[UIColor redColor]];
        
        [buttons addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        buttons.tag = i;
        
        buttons.isclicked = NO;
        
        buttons.asction = i;
        
        [v addSubview:buttons];
        
        [headviewarr addObject:v];
        
        [buttonsarr addObject:buttons];
    }
    
}
#pragma mark tableview handel
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==mytab)
        return arr.count;
    else return searcharr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return 5;
    //    NSLog(@"数据源内容是:----------%@",[arr objectAtIndex:1]);
    //    NSLog(@"每个组的数据长度:=====%d",[[[arr objectAtIndex:section]objectForKey:@"childCate"]count]);
    if(tableView==mytab)
    {
        if([[[arr objectAtIndex:section]objectForKey:@"childCate"]count]>0)
            return [[[arr objectAtIndex:section]objectForKey:@"childCate"]count];
        else
            return 1;
    }
    else
    {
        if([[[searcharr objectAtIndex:section]objectForKey:@"childCate"]count]>0)
            return [[[searcharr objectAtIndex:section]objectForKey:@"childCate"]count];
        else
            return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==mytab)
    {
        static NSString *cellid = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        if([[[arr objectAtIndex:indexPath.section] objectForKey:@"childCate"]count]>0)
        {
            cell.textLabel.text = [[[[arr objectAtIndex:indexPath.section] objectForKey:@"childCate"]objectAtIndex:indexPath.row ]objectForKey:@"cateName"];
        }
        else
        {
            cell.textLabel.text=@"";
        }
        return cell;
        
    }
    
    else
    {
        static NSString *cellid = @"cell";
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        
        namelabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *phonenum = [[UILabel alloc]initWithFrame:CGRectMake(170, 10, 70, 20)];
        
        phonenum.font = [UIFont systemFontOfSize:12];
        
        UILabel *telnum = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 70, 20)];
        
        telnum.font = [UIFont systemFontOfSize:10];
        
        UILabel *adress = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 300, 20)];
        
        UILabel *webaddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 20)];
        
        adress.font = [UIFont systemFontOfSize:13];
        
        webaddress.font = [UIFont systemFontOfSize:13];
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        [cell.contentView addSubview:namelabel];
        
        [cell.contentView addSubview:phonenum];
        
        [cell.contentView addSubview:telnum];
        
        [cell.contentView addSubview:adress];
        
        [cell.contentView addSubview:webaddress];
        
        if([[[searcharr objectAtIndex:indexPath.section] objectForKey:@"childCate"]count]>0)
        {
            namelabel.text = [[[[searcharr objectAtIndex:indexPath.section] objectForKey:@"childCate"]objectAtIndex:indexPath.row ]objectForKey:@"name"];
            
            phonenum.text = [[[[searcharr objectAtIndex:indexPath.section] objectForKey:@"childCate"]objectAtIndex:indexPath.row ]objectForKey:@"mobile"];
            
            adress.text = [[[[searcharr objectAtIndex:indexPath.section] objectForKey:@"childCate"]objectAtIndex:indexPath.row ]objectForKey:@"address"];
            
            NSString *web = @"网址:";
            
            webaddress.text = [web stringByAppendingString:[[[[searcharr objectAtIndex:indexPath.section] objectForKey:@"childCate"]objectAtIndex:indexPath.row ]objectForKey:@"webAddress"]];
            
            telnum.text = [[[[searcharr objectAtIndex:indexPath.section] objectForKey:@"childCate"]objectAtIndex:indexPath.row ]objectForKey:@"tel"];
            
        }
        else
        {
            // cell.textLabel.text=@"";
        }
       
        return cell;
    }
    
    //    else
    //    {
    //        static NSString *cellids = @"cells";
    //        UITableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:cellids];
    //        UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    //        UILabel *phonenum = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 150, 20)];
    //        if(!cells)
    //        {
    //            cells = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellids];
    ////            for(UIView *v in cells.subviews)
    ////            {sss
    ////                [v removeFromSuperview];
    ////            }
    //
    //        }
    //        [cells.contentView addSubview:namelabel];
    //        [cells.contentView addSubview:phonenum];
    //        if([[[arr objectAtIndex:indexPath.section] objectForKey:@"childCate"]count]>0)
    //        {
    //            namelabel.text = [[[[arr objectAtIndex:indexPath.section] objectForKey:@"childCate"]objectAtIndex:indexPath.row ]objectForKey:@"name"];
    //            phonenum.text = [[[[arr objectAtIndex:indexPath.section] objectForKey:@"childCate"]objectAtIndex:indexPath.row ]objectForKey:@"mobile"];
    //        }
    //        else
    //        {
    //           // cell.textLabel.text=@"";
    //        }
    //     return cells;
    //
    //    }
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [self animationForIndexPath:indexPath];
}
- (void)animationForIndexPath:(NSIndexPath *)indexPath {
    int row = indexPath.row;
    float radians = (120 + row*30)%360;
    radians = 20;
    CALayer *layer = celllayer;
    
    // Rotation Animation
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue =@DEGREES_TO_RADIANS(radians);
    animation.toValue = @DEGREES_TO_RADIANS(0);
    
    // Opacity Animation;
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = @0.1f;
    fadeAnimation.toValue = @1.f;
    
    // Translation Animation
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    ;
    translationAnimation.fromValue = @(-300.f * ((indexPath.row%2 == 0) ? -1: 1));
    translationAnimation.toValue = @0.f;
    
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.4f;
    animationGroup.animations = @[animation,fadeAnimation,translationAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animationGroup forKey:@"spinAnimation"];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MTContrctTable *table = [[MTContrctTable alloc]init];
    
    if(tableView==mytab)
    {
        table.pid = [[arr objectAtIndex:indexPath.section]objectForKey:@"id"];
        
        table.cid = [[[[arr objectAtIndex:indexPath.section]objectForKey:@"childCate"]objectAtIndex:indexPath.row]objectForKey:@"id"];
        
        table.versions = [[[[arr objectAtIndex:indexPath.section]objectForKey:@"childCate"]objectAtIndex:indexPath.row]objectForKey:@"ver"];
    }
    else
    {
        table.pid = [[searcharr objectAtIndex:indexPath.section]objectForKey:@"id"];
        
        table.cid = [[[[searcharr objectAtIndex:indexPath.section]objectForKey:@"childCate"]objectAtIndex:indexPath.row]objectForKey:@"id"];
    }
    [self.navigationController pushViewController:table animated:NO];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTCustomBut *but = [buttonsarr objectAtIndex:indexPath.section];
    
    if(tableView==mytab)
        return but.isclicked?40:0;
    else
        return but.isclicked?80:0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [headviewarr objectAtIndex:section];
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 3)];
    v.backgroundColor = [UIColor grayColor];
    return v;
}
-(void)btnclick:(MTCustomBut * )btn
{
    //  NSLog(@"btn clicked........");
    btn.isclicked = !btn.isclicked;
    if(seatable.hidden==NO)
        [seatable reloadData];
       // [ seatable reloadSections:[NSIndexSet indexSetWithIndex:btn.asction] withRowAnimation:UITableViewRowAnimationFade];
    // [mytab reloadData];
    else
        
        [mytab reloadSections:[NSIndexSet indexSetWithIndex:btn.asction] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark srachbar handel

-(void)srarchclick:(UIButton *)button
{
    [mysearch resignFirstResponder];
    
    seatable.hidden = YES;
    
//    if(![mysearch.text isEqualToString:@""])
//        [self seachs];
}
-(void)seachs
{
    
    searcharr = [NSMutableArray array];
    
    [[FuncPublic SharedFuncPublic]StartActivityAnimation:self];
    
    NSString *seachtext = mysearch.text;
    
    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
    
    NSString *oid = [userdic objectForKey:@"organID"];
    
    NSString *ids = [userdic objectForKey:@"id"];
    
    NSMutableDictionary *dcit = [NSMutableDictionary dictionary];
    
    [dcit setObject:oid  forKey:@"oid"];
    
    [dcit setObject:ids forKey:@"uid"];
    
    [dcit setObject:[FuncPublic getDvid] forKey:@"dvid"];
    
    [dcit setObject:[FuncPublic createUUID] forKey:@"r"];
    
    [dcit setObject:seachtext forKey:@"keyword"];
    
    [SVHTTPRequest GET:@"/api/contact/search.html" parameters:dcit completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [[FuncPublic SharedFuncPublic]StopActivityAnimation];
         NSLog(@"搜索的返回结果:%@",response);
        if([[response objectForKey:@"status"]isEqualToString:@"true"])
        {
            
            seatable.hidden = NO;
            
            searcharr = [response objectForKey:@"data"];
            
            [self tablehead:searcharr];
            
            [seatable reloadData];
        }
        else
        {
            seatable.hidden = YES;
            [WToast showWithText:[response objectForKey:@"msg"]];
        }
        
    }];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"取消搜索..........");
    [mysearch resignFirstResponder];
    
    isseach = NO;
    
    arr = copyarr;
    
    [mytab reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"come thi fusn....");
    [mysearch resignFirstResponder];
    
    if(![mysearch.text isEqualToString:@""])
        
        [self seachs];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
