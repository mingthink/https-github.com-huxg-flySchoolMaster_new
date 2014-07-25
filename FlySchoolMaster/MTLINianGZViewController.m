//
//  MTLINianGZViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-18.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTLINianGZViewController.h"
#import "SVHTTPRequest.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "linianGZViewController.h"

#import "MJRefreshFooterView.h"


@interface MTLINianGZViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *mytab;
    NSMutableArray *datasouce;
    BOOL issearch;
    BOOL ismore;
    
    NSString *searchname;
    MJRefreshFooterView *footer;
    int page;
}
@end

@implementation MTLINianGZViewController

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
    page = 1;
    datasouce = [[NSMutableArray alloc]initWithCapacity:0];
    mysearch.delegate = self;
    
    issearch = YES;
    [self setUI];
    
    [self getdata:nil andpagnum:1];
   
   
    // Do any additional setup after loading the view from its nib.
}
-(void)getdata:(NSString *)name andpagnum:(int)pagnum
{
    mytab.hidden = NO;
    [[FuncPublic SharedFuncPublic]StartActivityAnimation:self];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];

    if(issearch)
    {
       
    
    [dic setObject:[FuncPublic GetDefaultInfo:@"zxdm"] forKey:@"zxdm"];
    [dic setObject:[NSString stringWithFormat:@"%d",pagnum] forKey:@"page_number"];
    [dic setObject:@"1" forKey:@"isDoPaging"];
    [dic setObject:@"10" forKey:@"txbPageSize"];
        if(name!=nil)
        {
            [dic setObject:name forKey:@"xm"];
        }
    
    }
    if(ismore)
    {
       
        [dic setObject:[FuncPublic GetDefaultInfo:@"zxdm"] forKey:@"zxdm"];
        [dic setObject:[NSString stringWithFormat:@"%d",pagnum] forKey:@"page_number"];
        [dic setObject:@"1" forKey:@"isDoPaging"];
        [dic setObject:@"10" forKey:@"txbPageSize"];
        if(name!=nil)
        {
            [dic setObject:name forKey:@"xm"];
        }
    }
    
    NSString *url = @"/api/thlqk/";
    [SVHTTPRequest GET:url parameters:dic completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSLog(@"返回信息是：%@",response);
        [[FuncPublic SharedFuncPublic]StopActivityAnimation];
        if(error!=nil)
        {
            [WToast showWithText:kMessage];
            return ;
        }
        else if ([[response objectForKey:@"status"]isEqualToString:@"false"])
        {
            if(issearch)
            {
                mytab.hidden = YES;
            }
            [WToast showWithText:EMessage];
           // mytab.hidden = YES;
            return;
        }
        else
        {
            if(issearch)
            {
                [datasouce removeAllObjects];
            }
           // mytab.hidden = NO;
            for(NSDictionary *diction in [response objectForKey:@"data"])
            {
                [datasouce addObject:diction];
            }
            NSLog(@"返回信息是:%@",datasouce);
            [mytab reloadData];
        }
        //mytab.hidden = NO;
    }];
    
    
}
-(void)setUI
{
    
    
    mytab = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, 320, DEVH-108-50) style:UITableViewStylePlain];
    mytab.delegate = self;
    mytab.dataSource = self;
   // mytab.hidden = YES;
    [self.view addSubview:mytab];
   // NSLog(@"mytab.retaincount is");
    footer = [[MJRefreshFooterView alloc]init];
    footer.delegate = self;
    footer.scrollView = mytab;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return datasouce.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellindeb = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
    UILabel *score = [[UILabel alloc]initWithFrame:CGRectMake(110, 10, 70, 40)];
    UILabel *yxmc = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 100, 40)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(300, 20, 15, 15)];
    image.image = [UIImage imageNamed:@"right.png"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindeb];
        name.text = [[datasouce objectAtIndex:indexPath.row]objectForKey:@"xm"];
        score.text = [NSString stringWithFormat:@"%@",[[datasouce objectAtIndex:indexPath.row]objectForKey:@"cj"]];
        yxmc.text = [[datasouce objectAtIndex:indexPath.row]objectForKey:@"yxmc"];
      
        
        
    }
    [cell.contentView addSubview:score];
    [cell.contentView addSubview:yxmc];
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:image];
    if(indexPath.row%2==0)
    {
        cell.backgroundColor = [UIColor colorWithRed:225./255 green:225./255 blue:225./255 alpha:1];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [mysearch resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    linianGZViewController *detail = [[linianGZViewController alloc]init];
    detail.namestr = [[datasouce objectAtIndex:indexPath.row]objectForKey:@"xm"];
    detail.numberstr = [[datasouce objectAtIndex:indexPath.row]objectForKey:@"ksh"];
    detail.infostr = [NSString stringWithFormat:@"%@  %@  %@",[[datasouce objectAtIndex:indexPath.row]objectForKey:@"pcmc"],[[datasouce objectAtIndex:indexPath.row]objectForKey:@"klmc"],[[datasouce objectAtIndex:indexPath.row]objectForKey:@"jhxz"]];
    detail.scrostr = [[datasouce objectAtIndex:indexPath.row]objectForKey:@"cj"];
    detail.yuanxstr = [[datasouce objectAtIndex:indexPath.row]objectForKey:@"yxmc"];
    detail.zhuanystr = [[datasouce objectAtIndex:indexPath.row]objectForKey:@"zymc"];
    [self.navigationController pushViewController:detail animated:NO];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
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
-(void)refesshview:(MJRefreshBaseView *)refersh
{
    ismore = YES;
    issearch = NO;
        page++;
    
    // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/news/?page_number=%d&isDoPaging=1&txbPageSize=5",SERVER3,page]];
    NSLog(@"刷新次数是：---------%d",page);
    //[self loaddata:url];
    //[self loaddataa:page];
   if([mysearch.text isEqualToString:@""])
   {
       [self getdata:nil andpagnum:page];
   }
    else
    {
    [self getdata:mysearch.text andpagnum:page];
    }
    [refersh endRefreshing];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        page = 1;
        issearch = YES;
        ismore = NO;
        [self getdata:nil andpagnum:page];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"seach click...");
    [self serahaction:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [mysearch resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [mysearch resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)serahaction:(id)sender {
    [mysearch resignFirstResponder];
    page = 1;
    issearch = YES;
    ismore = NO;
    searchname = mysearch.text;
   // NSString *anme = [mysearch.text stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingUTF8];
    [self getdata:searchname andpagnum:page];
}
@end
