//
//  MTTongXlViewController.m
//  FlySchoolMaster
// sfsdfsdibds是东方酒店送 i 风景
//  Created by caiyc on 14-9-5.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTTongXlViewController.h"
#import "MTCustomBut.h"
@interface MTTongXlViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *mytab;
    NSMutableArray *datasource;
    UISearchBar *mysearch;
    NSArray *arr;
    NSMutableArray *headviewarr;
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
    arr = [[NSArray alloc]initWithObjects:@"常用电话",@"同事",@"学生家长" ,nil];
    headviewarr = [NSMutableArray array];
    for(int i=0;i<arr.count;i++)
    {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 40)];
        v.backgroundColor = [UIColor yellowColor];
        v.userInteractionEnabled = YES;
        MTCustomBut *buttons = [[MTCustomBut alloc]initWithFrame:CGRectMake(30, 0, 80, 40)];
        NSString *btntitle = [arr objectAtIndex:i];
        [buttons setTitle:btntitle forState:UIControlStateNormal];
        [v addSubview:buttons];
        [headviewarr addObject:v];
        [buttons addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        buttons.tag = i;
    }
    
    [FuncPublic InstanceNavgationBar:@"通讯录" action:@selector(back) superclass:self isroot:NO];
    mytab = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, DEVW, DEVH-50-100) style:UITableViewStyleGrouped];
    mytab.delegate = self;
    mytab.dataSource = self;
    [self.view addSubview:mytab];
    mysearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 60, DEVW, 40)];
    mysearch.barStyle = UIBarStyleDefault;
    mysearch.delegate = self;
    [self.view addSubview:mysearch];
    // Do any additional setup after loading the view.
}
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [headviewarr objectAtIndex:section];
}
-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)btnclick:(MTCustomBut *)btn
{
    NSLog(@"btn clicked........");
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
