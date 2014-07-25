//
//  MTStuListViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-11.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTStuListViewController.h"
#import "MJRefresh.h"
#import "WToast.h"
#import "SVHTTPRequest.h"
#import "FuncPublic.h"
#import "MTLoginViewController.h"
#import "MTScoreDetViewController.h"
#import "MTStuDetailViewController.h"

@interface MTStuListViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *footview;
    MJRefreshHeaderView *headview;
    NSMutableArray *datalist;
    NSMutableArray *moredatasouce;
    BOOL isRefreshing;
    int page;
}
@end

@implementation MTStuListViewController

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
    
    datalist = [[NSMutableArray alloc]initWithCapacity:0];
    moredatasouce = [[NSMutableArray alloc]initWithCapacity:0];
    page = 1;
    
    mytab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, DEVH-50-64) style:UITableViewStylePlain];
    
    mytab.delegate =self;
    mytab.dataSource = self;
    mytab.hidden = YES;
    [self.view addSubview:mytab];
    
    footview = [[MJRefreshFooterView alloc]init];
    footview.delegate = self;
    footview.scrollView = mytab;
    
    headview = [[MJRefreshHeaderView alloc]init];
    headview.delegate = self;
    headview.scrollView = mytab;

    
    [self getlist:page];
    // Do any additional setup after loading the view from its nib.
}
-(void)getlist:(int)pag
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    if([FuncPublic GetDefaultInfo:@"zxdm"]==NULL)
    {
        MTLoginViewController *login = [[MTLoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
    else
    {
        [dic setObject:[FuncPublic GetDefaultInfo:@"zxdm"] forKey:@"zxdm"];
    }
    [dic setObject:_ksh forKey:@"ksh"];
    [dic setObject:_name forKey:@"xm"];
    [dic setObject:[NSString stringWithFormat:@"%d",pag] forKey:@"page_number"];
    [dic setObject:@"1" forKey:@"isDoPaging"];
    [dic setObject:@"10" forKey:@"txbPageSize"];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [SVHTTPRequest GET:@"/api/examinee/"
                  parameters:dic
                  completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
//                      mytab.hidden = NO;
                     
                      if(error!=nil)
                      {
                          [WToast showWithText:kMessage];
                          return ;
                      }
                      
                      
                      if(isRefreshing==YES)
                      {
                          NSMutableArray *datamore = [[NSMutableArray alloc]initWithCapacity:0];
                         // [moredatasouce removeAllObjects];
                          
                          if([[response objectForKey:@"status"]isEqualToString:@"false"])
                          {
                              
                            //  return;
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
                          
                          
                          //  NSLog(@"返回信息是:%@",response);
                          if([[response objectForKey:@"status"]isEqualToString:@"false"])
                          {
                              [WToast showWithText:EMessage];
                             // mytab.hidden = YES;
                              //[footview free];
                              //footview.hidden = YES;
                             // [footview removeFromSuperview];
                              return;
                          }
//                          if([[response objectForKey:@"data"]count]==0)
//                          {
//                              mytab.hidden = YES;
//                              [WToast showWithText:@"查无数据"];
//                              return;
//                          }
                          
                          for(NSDictionary *dic in [response objectForKey:@"data"])
                          {
                              [datalist addObject:dic];
                          }
//                          if(datalist.count==0)
//                          {
//                              mytab.hidden = YES;
//                             [WToast showWithText:@"查无数据"];
//                                return;
//                          }
                          [mytab reloadData];
                      }
                      mytab.hidden = NO;
                      

                  }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datalist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell *cell = [tableView  cellForRowAtIndexPath:indexPath];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 320, 30)];
    UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, 100, 25)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(280, 20, 20, 20)];
    //    CGSize labelsize =  [title sizeWithFont:15 constrainedToSize:CGSizeMake(260, 320) lineBreakMode:NSLineBreakByWordWrapping];
    //
    //    if (labelsize.height > 25) {
    //        _title.frame = CGRectMake(15, 8, 260, 41);
    //        _timelabel.frame = CGRectMake(15, 50, 260, 20);
    //    }else{
    //        _title.frame = CGRectMake(15, 20, 260, 20);
    //        _timelabel.frame = CGRectMake(15, 41, 260, 20);
    //    }
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        time.text = [[datalist objectAtIndex:indexPath.row]objectForKey:@"zkzh"];
        title.text = [[datalist objectAtIndex:indexPath.row]objectForKey:@"xm"];
    }
    
    if(indexPath.row%2==0)
    {
        cell.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
    }
    else
    {
       // image.image = [UIImage imageNamed:@"newsitem_bg2.9.png"];
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
    return 80;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if(refreshView ==headview)
    {
        isRefreshing = YES;
       // NSLog(@"刷新");
    }
    else if(refreshView==footview)
    {
        isRefreshing = NO;
      //  NSLog(@"加载");
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
    else
    {
        page++;
    }
    // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/news/?page_number=%d&isDoPaging=1&txbPageSize=5",SERVER3,page]];
   // NSLog(@"刷新次数是：---------%d",page);
    //[self loaddata:url];
    //[self loaddataa:page];
    [self getlist:page];
    [refersh endRefreshing];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MTStuDetailViewController *detail = [[MTStuDetailViewController alloc]init];
     detail.Ksh = [[datalist objectAtIndex:indexPath.row]objectForKey:@"ksh"];
    detail.name = [[datalist objectAtIndex:indexPath.row]objectForKey:@"xm"];
    detail.zkzh = [[datalist objectAtIndex:indexPath.row]objectForKey:@"zkzh"];
    [self.navigationController pushViewController:detail animated:NO];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [headview free];
    [footview free];
}
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
