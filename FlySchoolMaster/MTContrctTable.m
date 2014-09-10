//
//  MTContrctTable.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-9-9.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTContrctTable.h"
#import "MTContantPersonModel.h"
#import "SVHTTPRequest.h"
#import "MJRefresh.h"
#import "MJRefreshBaseView.h"
#define rowsnum 10
@interface MTContrctTable ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,MJRefreshBaseViewDelegate>

@end

@implementation MTContrctTable
{
    UITableView *mytable;
    NSMutableArray *datalist;
    float rowhei;
    UIView *loadview;
    UISearchBar *mysearch;
    NSMutableArray *listarr;
    
    MJRefreshFooterView *footview;
   // MJRefreshHeaderView *headview;
    int num;
    
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
    num = 10;
    datalist = [NSMutableArray array];
    listarr = [NSMutableArray array];
    NSFileManager *FM = [NSFileManager defaultManager];
    NSString *fielpaths = [NSHomeDirectory()stringByAppendingString:@"/Documents/FileDocuments"];
    NSString *fullpath = [fielpaths stringByAppendingString:[NSString stringWithFormat:@"/%@/%@.txt",Contranct,_cid]];
   
    if([FM fileExistsAtPath:fullpath isDirectory:NO ])
    {
        
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:fullpath];
        NSString *ves = [dict objectForKey:@"vers"];
      //  NSLog(@"文件缓存路径:%@",ves);
        if([ves isEqualToString:_versions])
        {
            
            datalist = [dict objectForKey:@"data"];
            if([datalist count]>10)
            {
                for(int i=0;i<rowsnum;i++)
                {
                    NSDictionary *dic = [datalist objectAtIndex:i];
                    [listarr addObject:dic];
                }
            }
            else
                listarr = datalist;

        }
        else
        {
            [self getdata];
        }
    }
    else
    {
        
    
    [self getdata];
    }
    
    [FuncPublic InstanceNavgationBar:@"通讯录列表" action:@selector(back) superclass:self isroot:NO];
    
    mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, DEVW, DEVH-100-50) style:UITableViewStylePlain];
    
    mytable.dataSource = self;
    
    mytable.delegate = self;
    
    [self.view addSubview:mytable];
    
    mysearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 60, DEVW, 40)];
    
    mysearch.delegate = self;
    
    [self.view addSubview:mysearch];
    
    footview = [[MJRefreshFooterView alloc]init];
    footview.delegate = self;
    footview.scrollView = mytable;
    
//    headview = [[MJRefreshHeaderView alloc]init];
//    headview.delegate =self;
//    headview.scrollView = mytable;

    
////加载更多数据视图
//    
    loadview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 40)];
//    
    loadview.backgroundColor = [UIColor whiteColor];
//    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, DEVW, 15)];
//    
    label.text = @"正在加载";
    label.tag = 1002;
//    
   // [loadview addSubview:label];
//    
//    UILabel *timelabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 22, 200, 15)];
//    timelabel.text = [self gettimeNow];
//    [loadview addSubview:timelabel];
//    timelabel.font = [UIFont systemFontOfSize:12];
//    timelabel.tag = 1003;
//    
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
    
    return [listarr count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 3, 240, 20)];
    namelabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 44, 130, 20)];
    phonelabel.font = [UIFont systemFontOfSize:16];
    UILabel *addresslabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 25, 300, 20)];
    addresslabel.font = [UIFont systemFontOfSize:16];
    UILabel *web = [[UILabel alloc]initWithFrame:CGRectMake(8, 47, 132, 20)];
    web.font = [UIFont systemFontOfSize:16];
    //MTContantPersonModel *model = [datalist objectAtIndex:indexPath.row];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell.contentView addSubview:namelabel];
        [cell.contentView addSubview:phonelabel];
        [cell.contentView addSubview:addresslabel];
        [cell.contentView addSubview:web];
        namelabel.text = [[datalist objectAtIndex:indexPath.row]objectForKey:@"name"];
        
        phonelabel.text = [NSString stringWithFormat:@"☎️%@",[[datalist objectAtIndex:indexPath.row]objectForKey:@"tel"]];
        addresslabel.text = [[datalist objectAtIndex:indexPath.row]objectForKey:@"address"];
    }
    
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return loadview;
//}
-(void)getdata
{
    
    
    
    NSLog(@"进入网络请求..........");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
    NSString *oid = [userdic objectForKey:@"organID"];
    NSString *ids = [userdic objectForKey:@"id"];
    NSMutableDictionary *dcit = [NSMutableDictionary dictionary];
    [dcit setObject:oid  forKey:@"oid"];
    [dcit setObject:ids forKey:@"uid"];
    [dcit setObject:[FuncPublic getDvid] forKey:@"dvid"];
    [dcit setObject:[FuncPublic createUUID] forKey:@"r"];
    [dcit setObject:_pid forKey:@"pid"];
    [dcit setObject:_cid forKey:@"cid"];
    [SVHTTPRequest GET:@"/api/contact/detail.html" parameters:dcit completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
      
        if ([[response objectForKey:@"status"]isEqualToString:@"true"]) {
           
            [dict setObject:[response objectForKey:@"data"] forKey:@"data"];
            [dict setObject:_versions forKey:@"vers"];
        
          //  NSString *path = [Contranct strin
            [FuncPublic saveDataToLocal:dict toFileName:[NSString stringWithFormat:@"%@/%@.txt",Contranct,_cid]];
            
                datalist = [response objectForKey:@"data"];
            if([datalist count]>10)
            {
            for(int i=0;i<rowsnum;i++)
            {
                NSDictionary *dic = [datalist objectAtIndex:i];
                [listarr addObject:dic];
            }
            }
            else
                listarr = datalist;
            [mytable reloadData];
        }
        
    }];
   // [mytable reloadData];
   //NSLog(@"arr is .. %@",datalist);
    
//    [mytable reloadData];
}
//-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return rowhei;
//}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
//    if(refreshView ==headview)
//    {
//        isRefreshing = YES;
//        NSLog(@"刷新");
//    }
//    else if(refreshView==footview)
//    {
//        isRefreshing = NO;
//        NSLog(@"加载");
//    }
    [self performSelector:@selector(refesshview:) withObject:refreshView afterDelay:2.0];
}
//刷新方法
-(void)refesshview:(MJRefreshBaseView *)refersh
{
    if([datalist count]<=10)
    {
        [refersh endRefreshing];
        return;
    }
    else
    {
        for(int i=num;i<num+rowsnum;i++)
        {
            NSDictionary *dcic = [datalist objectAtIndex:i];
            [listarr addObject:dcic];
            if(i>[datalist count]-1)
                continue;
        }
        [mytable reloadData];
        [refersh endRefreshing];
    }
    
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

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"scorll did scroll.........");
//    
//    NSLog(@"偏移量:%f",(scrollView.contentSize.height-scrollView.frame.size.height)+100);
//    if(scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height)+100)
//    {
//        mytable.tableFooterView = loadview;
//        UIActivityIndicatorView *action = (UIActivityIndicatorView *)[loadview viewWithTag:1004];
//        [action startAnimating];
//        //loadview.hidden = NO;
//    }
//    else
//        mytable.tableFooterView = nil;
//}
//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    if(scrollView.contentOffset.y==100)
//    {
//    
//    [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
//    }
//}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//   // mytable.tableFooterView = nil;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [footview free];
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
