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
    NSMutableArray *listarr;//数据源
    NSMutableArray *beforesearch;//搜索之前数据源的复制数据
    
    MJRefreshFooterView *footview;
    // MJRefreshHeaderView *headview;
    int num;
    int pagenum;
    BOOL isseach;
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
    NSLog(@"cid is ；%@",_cid);
    beforesearch = [NSMutableArray array];
    pagenum=1;
    num = 0;
    datalist = [NSMutableArray array];
    listarr = [NSMutableArray array];
    NSFileManager *FM = [NSFileManager defaultManager];
    NSString *fielpaths = [NSHomeDirectory()stringByAppendingString:@"/Documents"];
    NSString *fullpath = [fielpaths stringByAppendingString:[NSString stringWithFormat:@"/%@/%@.txt",Contranct,_cid]];
    
    if([FM fileExistsAtPath:fullpath isDirectory:NO ])
    {
        
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:fullpath];
        NSString *ves = [dict objectForKey:@"vers"];
        NSLog(@"文件缓存路径:%@",ves);
        if([ves isEqualToString:_versions])
        {
            
            datalist = [dict objectForKey:@"data"];
           // NSLog(@"缓存的数据长度:%d",[datalist count]);
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
    
    [FuncPublic InstanceNavgationBar:_titless action:@selector(back) superclass:self isroot:NO];
    
    mytable = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, DEVW, DEVH-100-50) style:UITableViewStylePlain];
    
    mytable.dataSource = self;
    
    mytable.delegate = self;
    
    [self.view addSubview:mytable];
    
    mysearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 60, DEVW-60, 40)];
    
    mysearch.delegate = self;
    
    mysearch.placeholder = @"请输入关键字";
    
    //  mysearch.showsCancelButton = YES;
    
    [self.view addSubview:mysearch];
    
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelbtn.frame = CGRectMake(DEVW-60, 60, 60, 40);
    
    [cancelbtn setTitle:@"取消搜索" forState:UIControlStateNormal];
    
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [cancelbtn setBackgroundColor:[UIColor grayColor]];
    
    [cancelbtn addTarget:self action:@selector(cancelsearch:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelbtn];
    
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 3, 240, 20)];
    namelabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    UIButton *dialnum = [UIButton buttonWithType:UIButtonTypeCustom];
    dialnum.frame = CGRectMake(8, 44, 30, 30);
    [dialnum setTitle:@"☎️" forState:UIControlStateNormal];
    dialnum.titleLabel.textAlignment = NSTextAlignmentLeft;
    dialnum.tag = indexPath.row;
    [dialnum addTarget:self action:@selector(dialnum:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 44, 150, 20)];
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
        [cell.contentView addSubview:dialnum];
        namelabel.text = [[listarr objectAtIndex:indexPath.row]objectForKey:@"name"];
        
        phonelabel.text = [NSString stringWithFormat:@"%@",[[listarr objectAtIndex:indexPath.row]objectForKey:@"mobile"]];
        NSString *phoe = [[listarr objectAtIndex:indexPath.row]objectForKey:@"mobile"];
        NSString *dialtext = @"☎️";
        // [dialnum setTitle:[NSString stringWithFormat:@"%@%@",dialtext,phoe] forState:UIControlStateNormal];
        addresslabel.text = [[listarr objectAtIndex:indexPath.row]objectForKey:@"address"];
    }
    
    return cell;
}
-(void)dialnum:(UIButton *)sender
{
    NSString *number = [[listarr objectAtIndex:sender.tag]objectForKey:@"mobile"];// 此处读入电话号码
    NSString *numben = [[NSString alloc] initWithFormat:@"tel://%@",number]; //number为号码字符串 如果使用这个方法 结束电话之后会进入联系人列表
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:numben]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
            
            //  [FuncPublic saveDataToLocal:dict toFileName:[NSString stringWithFormat:@"%@/%@.txt",Contranct,_cid]];
            NSString *fielpaths = [NSHomeDirectory()stringByAppendingString:@"/Documents"];
            NSString *dpath = [fielpaths stringByAppendingString:[NSString stringWithFormat:@"/%@",Contranct]];
            NSString *fullpath = [fielpaths stringByAppendingString:[NSString stringWithFormat:@"/%@/%@.txt",Contranct,_cid]];
            NSFileManager *fiel = [NSFileManager defaultManager];
            [fiel createDirectoryAtPath:dpath withIntermediateDirectories:YES attributes:nil error:nil];
            [fiel createFileAtPath:fullpath contents:nil attributes:nil];
            // NSLog(@"缓存路径:%@",fullpath);
            [dict writeToFile:fullpath atomically:NO];
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
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self performSelector:@selector(refesshview:) withObject:refreshView afterDelay:2.0];
}
//取消搜索
-(void)cancelsearch:(UIButton *)seneder
{
    
    if(isseach)
    {
        
        [mysearch resignFirstResponder];
        
        listarr = nil;
        
        listarr = [NSMutableArray arrayWithArray:beforesearch];
        // listarr = beforesearch;
        
        [mytable reloadData];
        
        isseach = NO;
    }
    else
        return;
    
    
    
}
//刷新方法
-(void)refesshview:(MJRefreshBaseView *)refersh
{
    //处于搜索状态的加载
    if(isseach)
    {
        [self searches];
    }
    
    
    //处于普通状态的加载
    else
    {
        if([datalist count]<=10)
        {
            [refersh endRefreshing];
            return;
        }
        else
        {
            num = num+10;
            for(int i=num;i<num+rowsnum;i++)
            {
                if(i<=[datalist count]-1)
                {
                    NSDictionary *dcic = [datalist objectAtIndex:i];
                    [listarr addObject:dcic];
                    
                }
                else
                    continue;
            }
            [mytable reloadData];
            [refersh endRefreshing];
        }
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [mysearch resignFirstResponder];
    
    isseach = YES;
    beforesearch = [listarr copy];
    
    [self searches];
}
//搜索事件
-(void)searches
{
    // NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *seachtext = mysearch.text;
    
    seachtext = [seachtext stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
    
    [dcit setObject:seachtext forKey:@"keyword"];
    
    [dcit setObject:@"1" forKey:@"isDoPaging"];
    
    [dcit setObject:[NSString stringWithFormat:@"%d",pagenum] forKey:@"page_number"];
    
    [dcit setObject:@"10" forKey:@"txbPageSize"];
    NSLog(@"dict is :%@",dcit);
    [SVHTTPRequest POST:@"/api/contact/cateSearch.html" parameters:dcit completion:
     ^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
         // NSLog(@"搜索结果：------------------------------------%@",response);
         if([[response objectForKey:@"status"]isEqualToString:@"true"])
         {
             if(pagenum==1)
             {
                 [listarr removeAllObjects];
                 
                 listarr = nil;
                 
                 listarr = [NSMutableArray array];
             }
             for(NSDictionary *dci in [response objectForKey:@"data"])
             {
                 [listarr addObject:dci];
             }
             
             [mytable reloadData];
             
             pagenum++;
         }
         
     }];
    
    
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
