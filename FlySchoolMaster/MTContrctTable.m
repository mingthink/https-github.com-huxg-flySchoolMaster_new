//
//  MTContrctTable.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-9-9.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTContrctTable.h"
#import "MTCustomViewCell.h"
@interface MTContrctTable ()<UIScrollViewDelegate>
{
    NSMutableArray *arr;
}
@end

@implementation MTContrctTable
{
    UIView *v;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr = [NSMutableArray array];
    [arr addObject:@"cyc"];
    [arr addObject:@"cyc1"];
    [arr addObject:@"cyc2"];
    [arr addObject:@"cyc3"];
    [FuncPublic InstanceNavgationBar:@"通讯录列表" action:@selector(back) superclass:self isroot:NO];
    v = [[UIView alloc]initWithFrame:CGRectMake(0, DEVH-50-40, DEVW, 40)];
    v.backgroundColor = [UIColor grayColor];
    v.hidden = YES;
    UIButton *load = [UIButton buttonWithType:UIButtonTypeCustom];
    load.frame = CGRectMake(0, 0, 100, 30);
    [load setTitle:@"加载更多" forState:UIControlStateNormal];
    [load addTarget:self action:@selector(laoddata:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:load];
    [self.view addSubview:v];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)laoddata:(UIButton *)btn
{
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    MTCustomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        NSArray *cellarr = [[NSBundle mainBundle]loadNibNamed:@"MTCustomViewCell" owner:self options:nil];
        cell = cellarr[0];
        NSString *sre = [arr objectAtIndex:indexPath.row];
        cell.labels.text =sre ;
        
    }
    
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
    for(UIButton *btn in v.subviews)
    {
        [btn setTitle:@"正在加载" forState:UIControlStateNormal];
        [self performSelector:@selector(loaddtass:) withObject:nil];
     //
    }
}
-(void)loaddtass:(id)sender
{
    [arr addObject:@"chadj"];
    [self performSelector:@selector(finishload:) withObject:nil afterDelay:2];
}
-(void)finishload:(id)sneder
{
    [self.tableView reloadData];
    v.hidden = YES;
    for(UIButton *btn in v.subviews)
    {
        [btn setTitle:@"加载更多" forState:UIControlStateNormal];
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y>40)
    {
        v.hidden = NO;
    }
   // NSLog(@"scorlll did scro.....");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
