//
//  MTTongXlViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-9-5.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTTongXlViewController.h"

@interface MTTongXlViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *mytab;
    NSMutableArray *datasource;
    UISearchBar *mysearch;
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
    [FuncPublic InstanceNavgationBar:@"通讯录" action:@selector(back) superclass:self isroot:NO];
    mytab = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, DEVW, DEVH-50-80) style:UITableViewStylePlain];
    mytab.delegate = self;
    mytab.dataSource = self;
    [self.view addSubview:mytab];
    mysearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 60, DEVW, 20)];
    mysearch.delegate = self;
    [self.view addSubview:mysearch];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
