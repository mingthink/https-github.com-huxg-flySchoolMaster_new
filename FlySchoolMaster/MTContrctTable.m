//
//  MTContrctTable.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-9-9.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTContrctTable.h"
#import "MTContantPersonModel.h"
@interface MTContrctTable ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation MTContrctTable
{
    UITableView *mytable;
    NSMutableArray *datalist;
    float rowhei;
    UIView *loadview;
}

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
    
    datalist = [NSMutableArray array];
    
    [self getdata];
    
    [FuncPublic InstanceNavgationBar:@"通讯录列表" action:@selector(back) superclass:self isroot:NO];
    
    mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, DEVW, DEVH-60-50) style:UITableViewStylePlain];
    
    mytable.dataSource = self;
    
    mytable.delegate = self;
    
    [self.view addSubview:mytable];
    
//加载更多数据视图
    
    loadview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 40)];
    
    loadview.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, DEVW, 15)];
    
    label.text = @"松开加载更多数据";
    label.tag = 1002;
    
    [loadview addSubview:label];
    
    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 22, 200, 15)];
    timelabel.text = [self gettimeNow];
    [loadview addSubview:timelabel];
    timelabel.font = [UIFont systemFontOfSize:12];
    timelabel.tag = 1003;
    
    UIActivityIndicatorView *action = [[UIActivityIndicatorView alloc]init];
    action.center = CGPointMake(160, 20);
    action.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    action.color = [UIColor darkGrayColor];
    action.tag = 1004;
    [loadview addSubview:action];
    
  //  [self.view addSubview:loadview];
    
  //  loadview.hidden = YES;

    
    
    // Do any additional setup after loading the view.
}
#pragma mark tableview handel
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datalist count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 150, 20)];
    UILabel *addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 200, 20)];
    MTContantPersonModel *model = [datalist objectAtIndex:indexPath.row];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell.contentView addSubview:namelabel];
        [cell.contentView addSubview:phonelabel];
        [cell.contentView addSubview:addresslabel];
        namelabel.text = model.name;
        phonelabel.text = model.phonenum;
        addresslabel.text = model.address;
    }
    return cell;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return loadview;
//}
-(void)getdata
{
    for(int i =0;i<10;i++)
    {
        MTContantPersonModel *model = [[MTContantPersonModel alloc]init];
        
        model.name = @"蔡跃春";
        
        model.address = @"高新大道589号";
        
        model.phonenum = @"13340116537";
        
        rowhei = 50;
        
        [datalist addObject:model];
    }
    [mytable reloadData];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowhei;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark loadmore
-(NSString *)gettimeNow
{
    //获得系统时间
    NSDate * senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    
    //获得系统日期
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent = [cal components:unitFlags fromDate:senddate];
    NSInteger year = [conponent year];
    NSInteger month = [conponent month];
    NSInteger day = [conponent day];
    NSString * nsDateString = [NSString stringWithFormat:@"%d/%d/%d",year,month,day];
    
    NSString *timestr = [NSString stringWithFormat:@"last Update:%@ %@",nsDateString,locationString];
    return timestr;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scorll did scroll.........");
    
    NSLog(@"偏移量:%f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y>100)
    {
        mytable.tableFooterView = loadview;
        //loadview.hidden = NO;
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y==100)
    {
    
    [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   // mytable.tableFooterView = nil;
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
