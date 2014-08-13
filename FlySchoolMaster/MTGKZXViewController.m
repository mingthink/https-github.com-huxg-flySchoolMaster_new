//
//  MTGKZXViewController.m
//  FlySchoolMaster
//
//  Created by huxg on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTGKZXViewController.h"


#import "MJRefresh.h"
#import "MJRefreshBaseView.h"
#import "SVHTTPRequest.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "MTNEwsDetailViewController.h"
@interface MTGKZXViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *footview;
    MJRefreshHeaderView *headview;
    NSMutableArray *datalist;
    NSMutableArray *moredatasouce;
    int page;
    BOOL isRefreshing;
    
    
}
@end

@implementation MTGKZXViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loaddata:) name:@"KCFNetChange" object:nil];
    [FuncPublic InstanceNavgationBar:@"高考资讯" action:@selector(back:) superclass:self isroot:NO];
    // [[NSNotificationCenter defaultCenter]addObserverForName:@"KCFNetChange" object:nil queue:nil usingBlock:nil];
    page = 1;
    datalist = [[NSMutableArray alloc]initWithCapacity:0];
    moredatasouce = [[NSMutableArray alloc]initWithCapacity:0];
    
    mytab = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, DEVH-60-50) style:UITableViewStylePlain];
    mytab.delegate = self;
    mytab.dataSource =self;
    mytab.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mytab];
    
    footview = [[MJRefreshFooterView alloc]init];
    footview.delegate = self;
    footview.scrollView = mytab;
    
    headview = [[MJRefreshHeaderView alloc]init];
    headview.delegate =self;
    headview.scrollView = mytab;
    
    
    [self loaddata:page];
    // Do any additional setup after loading the view from its nib.
}
-(void)loaddata:(int)pag
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[NSString stringWithFormat:@"%d",pag] forKey:@"page_number"];
    [dic setObject:@"1" forKey:@"isDoPaging"];
    [dic setObject:@"5" forKey:@"txbPageSize"];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [SVHTTPRequest GET:@"/api/news/"
            parameters:dic
            completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
               // NSLog(@"返回信息:%d",[urlResponse statusCode]);
                if(error!=nil)
                {
                   // [MTAlertView Aletwithstring:@"networkDisabled"];
                    
                   
                    return ;
                }
                if(isRefreshing==YES)
                {
                    NSMutableArray *datamore = [[NSMutableArray alloc]initWithCapacity:0];
                    //                          [moredatasouce removeAllObjects];
                    
                    if([[response objectForKey:@"status"]isEqualToString:@"false"])
                    {
                        [WToast showWithText:@"无最新数据"];
                        return;
                    }
                    for(NSDictionary *dic in [response objectForKey:@"data"])
                    {
                        [datamore addObject:dic];
                    }
                    
                    
                    [datalist removeAllObjects];
                    datalist = datamore;
                    [mytab reloadData];
                    
                    
                    
                }
                
                
                
                else if(isRefreshing==NO){
                    
                    //  NSLog(@"返回信息是:%@",dictt);
                    if([[response objectForKey:@"status"]isEqualToString:@"false"])
                    {
                        [WToast showWithText:@"已经全部加载"];
                        return;
                    }
                    page++;
                    for(NSDictionary *dic in [response objectForKey:@"data"])
                    {
                        [datalist addObject:dic];
                    }
                    
                    [mytab reloadData];
                }
                
                NSLog(@"返回信息是:%@",response);
            }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datalist.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor =[UIColor clearColor];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 250, 30)];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:16.0f];
    title.lineBreakMode = NSLineBreakByWordWrapping;
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 100, 20)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(280, 20, 20, 20)];
    
    
    
    
    
    
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        time.text = [NSString stringWithFormat:@"%@", [[datalist objectAtIndex:indexPath.row]objectForKey:@"published"]];
        title.text = [NSString stringWithFormat:@"%@",[[datalist objectAtIndex:indexPath.row]objectForKey:@"title"]];
        CGSize size = [title.text sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        title.frame = CGRectMake(20, 5, 250, size.height);
        image.frame = CGRectMake(280, size.height/2+10, 15, 15);
        time.frame = CGRectMake(20, size.height+10, 250, 20);
        
        
        
        
    }
    
    if(indexPath.row%2==0)
    {
        cell.backgroundColor = [UIColor colorWithRed:86./255 green:255./255 blue:255./255 alpha:1];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:160./255 green:255./255 blue:255./255 alpha:1];
    }
    image.contentMode = UIViewContentModeScaleAspectFit;
    image.image = [UIImage imageNamed:@"right.png"];
    [cell.contentView addSubview:image];
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:time];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",[[datalist objectAtIndex:indexPath.row]objectForKey:@"title"]]];
    // NSLog(@"掉出数据是：%@",str);
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(250, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"返回高度是：%f",size.height);
    return size.height+30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MTNEwsDetailViewController *detail = [[MTNEwsDetailViewController alloc]init];
    detail.urlstr = [NSString stringWithFormat:@"/api/news/detail.html?id=%@",[[datalist objectAtIndex:indexPath.row]objectForKey:@"id"]];
    [self.navigationController pushViewController:detail animated:NO];
}
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(refreshView ==headview)
    {
        isRefreshing = YES;
        NSLog(@"刷新");
    }
    else if(refreshView==footview)
    {
        isRefreshing = NO;
        NSLog(@"加载");
    }
    [self performSelector:@selector(refesshview:) withObject:refreshView afterDelay:2.0];
}
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    
}
// 刷新状态变更就会调用
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    
}
//刷新方法
-(void)refesshview:(MJRefreshBaseView *)refersh
{
    
    if(isRefreshing)
    {
        page = 1;
    }
    
   
    [self loaddata:page];
    [refersh endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [footview free];
    [headview free];
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
