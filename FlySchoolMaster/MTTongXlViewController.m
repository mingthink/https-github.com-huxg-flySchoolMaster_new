//
//  MTTongXlViewController.m
//  FlySchoolMaster
// sfsdfsdibds是东方酒店送 i 风景
//  Created by caiyc on 14-9-5.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTTongXlViewController.h"
#import "MTCustomBut.h"
#import "MTContrctTable.h"
@interface MTTongXlViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *mytab;
    NSMutableArray *datasource;
    UISearchBar *mysearch;
    NSArray *arr;
    NSMutableArray *headviewarr;
    NSMutableArray *buttonsarr;
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
    arr = [[NSArray alloc]initWithObjects:@"常用电话",@"同事",@"学生家长" ,@"常用",nil];
    
    headviewarr = [NSMutableArray array];
    
    buttonsarr = [NSMutableArray array];
    
    for(int i=0;i<arr.count;i++)
    {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        
        v.backgroundColor = [UIColor redColor];
        
        MTCustomBut *buttons = [[MTCustomBut alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        
        NSString *btntitle = [arr objectAtIndex:i];
        
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
    
    [FuncPublic InstanceNavgationBar:@"通讯录" action:@selector(back) superclass:self isroot:NO];
    
    mytab = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, DEVW, DEVH-50-100) style:UITableViewStyleGrouped];
    
    mytab.delegate = self;
    
    
    mytab.dataSource = self;
    
    [self.view addSubview:mytab];
    
    mysearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 60, DEVW-50, 40)];
    
    mysearch.barStyle = UIBarStyleDefault;
    
    mysearch.delegate = self;
    
    [self.view addSubview:mysearch];
    
    UIButton *searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchbut setTitle:@"搜索" forState:UIControlStateNormal];
    [searchbut setFrame:CGRectMake(DEVW-50, 60, 50, 40)];
    [self.view addSubview:searchbut];
    [searchbut addTarget:self action:@selector(srarchclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark tableview handel
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTContrctTable *table = [[MTContrctTable alloc]init];
    [self.navigationController pushViewController:table animated:NO];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTCustomBut *but = [buttonsarr objectAtIndex:indexPath.section];
    return but.isclicked?40:0;
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
-(void)btnclick:(MTCustomBut * )btn
{
  //  NSLog(@"btn clicked........");
    btn.isclicked = !btn.isclicked;
   // [mytab reloadData];
    [mytab reloadSections:[NSIndexSet indexSetWithIndex:btn.asction] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark srachbar handel

-(void)srarchclick:(UIButton *)button
{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSLog(@"come thi fusn....");
    [mysearch resignFirstResponder];
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
