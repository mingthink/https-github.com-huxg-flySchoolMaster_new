//
//  MTLQQKViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-17.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTLQQKViewController.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "SVHTTPRequest.h"
#import "MJRefreshFooterView.h"
#import "MTStuDetailViewController.h"
@interface MTLQQKViewController ()<MJRefreshBaseViewDelegate>
{
    UITableView *listtab;
    NSMutableArray *listdata;
    UITableView *stutab;
    NSMutableArray *studata;
    MJRefreshFooterView *footfresh;
    int index;
    int page;
    BOOL isrefresh;
}
@end

@implementation MTLQQKViewController

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
    index = 0;
    studata = [[NSMutableArray alloc]initWithCapacity:0];
    listdata = [[NSMutableArray alloc]initWithCapacity:0];
    [self setUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)setUI
{
    [FuncPublic InstanceNavgationBar:@"考生情况" action:@selector(back:) superclass:self isroot:NO];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 40)];
    view.backgroundColor = [UIColor colorWithRed:0 green:171./255 blue:171./255 alpha:1];
    [self.view addSubview:view];
    [FuncPublic InstanceLabel:@"科类：" RECT:CGRectMake(0, 0, 80, 40) FontName:nil Red:0 green:0 blue:0 FontSize:15 Target:view Lines:1 TAG:1 Ailgnment:1];
  //  [FuncPublic InstanceImageView:@"未标题-27" Ect:@"png" RECT:CGRectMake(80, 0, 240, 40) Target:view TAG:1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(80, 64, 240, 40);
    [btn setTitle:@"文科" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:0 green:200./255 blue:200./255 alpha:1];
    [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 1001;
    [self.view addSubview:btn];
    [FuncPublic InstanceImageView:@"selectimag" Ect:@"png" RECT:CGRectMake(300, 80, 15, 15) Target:self.view TAG:1];
    
    stutab = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, 320, DEVH-104-50) style:UITableViewStylePlain];
    stutab.delegate = self;
    stutab.dataSource = self;
    stutab.rowHeight = 40;
    [self.view addSubview:stutab];
    
    
    footfresh = [[MJRefreshFooterView alloc]init];
    footfresh.delegate = self;
    footfresh.scrollView = stutab;
    
    
    
    
    
    listtab = [[UITableView alloc]initWithFrame:CGRectMake(220, 104, 100, 120) style:UITableViewStylePlain];
    listtab.delegate = self;
    listtab.dataSource = self;
    listtab.rowHeight = 40;
    listtab.hidden = YES;
    // listtab.backgroundColor = [UIColor grayColor];
    [self.view addSubview:listtab];

    
    
    
    [self getlistdata];
    
    
}
-(void)getlistdata
{
    [[FuncPublic SharedFuncPublic]StartActivityAnimation:self];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [SVHTTPRequest GET:@"/api/examinee/getExamineeKL.html" parameters:dic completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
        [[FuncPublic SharedFuncPublic]StopActivityAnimation];
        if(error!=nil)
        {
            [WToast showWithText:kMessage];
            return ;
            
        }
        else if([[response objectForKey:@"status"]isEqualToString:@"true"])
        {
            for(NSDictionary *dic in [response objectForKey:@"data"])
            {
                [listdata addObject:dic];
                
            }
            [listtab reloadData];
            [self getstudata:index andpagenum:page];
        }
        
    }];
    

}
-(void)btnclick:(UIButton *)sender
{
    listtab.hidden = !listtab.hidden;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==listtab)
        return listdata.count;
    else
        return studata.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellindentifier = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30)];
    UILabel *scorelabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 50, 30)];
    UILabel *scolllabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 140, 30)];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(300, 15, 15, 15)];
    image.image = [UIImage imageNamed:@"right.png"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindentifier];
        if(tableView==listtab)
        {
           
        cell.backgroundColor = [UIColor colorWithRed:0 green:200./255 blue:200./255 alpha:1];
        cell.textLabel.text = [[listdata objectAtIndex:indexPath.row]objectForKey:@"klmc"];
        }
        else if (tableView==stutab)
        {
           // NSLog(@"考生录取情况；----!!!%@",studata);
            if([[[studata objectAtIndex:indexPath.row]objectForKey:@"lqzt"]isEqualToString:@"录取"])
            {
                scolllabel.textColor = [UIColor redColor];
            }
           else if([[[studata objectAtIndex:indexPath.row]objectForKey:@"lqzt"]isEqualToString:@"投档"])
            {
                scolllabel.textColor = [UIColor colorWithRed:0 green:200./255 blue:200./255 alpha:1];
            }
            else
            {
                scolllabel.textColor = [UIColor colorWithRed:52./255 green:60./255 blue:70./255 alpha:1];
            }
            if(indexPath.row%2==0)
            {
                cell.backgroundColor = [UIColor colorWithRed:235./255 green:235./255 blue:235./255 alpha:1];
            }
            namelabel.text = [[studata objectAtIndex:indexPath.row]objectForKey:@"xm"];
            scorelabel.text = [NSString stringWithFormat:@"%@分",[[studata objectAtIndex:indexPath.row]objectForKey:@"totalScore"] ];
            scolllabel.text = [[studata objectAtIndex:indexPath.row]objectForKey:@"yxmc"];
            [cell.contentView addSubview:namelabel];
            [cell.contentView addSubview:scorelabel];
            [cell.contentView addSubview:scolllabel];
            [cell.contentView addSubview:image];
        }
        

    }
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView==listtab)
    {
        index = indexPath.row;
        UIButton *btn = (UIButton*)[self.view viewWithTag:1001];
        btn.titleLabel.text = [[listdata objectAtIndex:indexPath.row]objectForKey:@"klmc"];
        listtab.hidden = !listtab.hidden;
        isrefresh = NO;
        [self getstudata:indexPath.row andpagenum:1];
        
    }
    else
    {
        MTStuDetailViewController *detail = [[MTStuDetailViewController alloc]init];
        detail.Ksh = [[studata objectAtIndex:indexPath.row]objectForKey:@"ksh"];
        detail.name = [[studata objectAtIndex:indexPath.row]objectForKey:@"xm"];
        detail.zkzh = [[studata objectAtIndex:indexPath.row]objectForKey:@"zkzh"];
        [self.navigationController pushViewController:detail animated:NO];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
-(void)getstudata:(int )indexx andpagenum:(int )pagnum
{
    NSString *zxdm = [[FuncPublic GetDefaultInfo:@"Newuser"]objectForKey:@"zxdm"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:zxdm forKey:@"zxdm"];
    [dic setObject:[[listdata objectAtIndex:indexx]objectForKey:@"kldm"] forKey:@"kldm"];
    [dic setObject:[NSString stringWithFormat:@"%d",pagnum] forKey:@"page_number"];
    [dic setObject:@"1" forKey:@"isDoPaging"];
    [dic setObject:@"10" forKey:@"txbPageSize"];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [[FuncPublic SharedFuncPublic]StartActivityAnimation:self];
    [SVHTTPRequest GET:@"/api/examinee/getTotalScore.html" parameters:dic completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
       // NSLog(@"返回信息是:------>>>%@",urlResponse);
        stutab.hidden = NO;
        [[FuncPublic SharedFuncPublic]StopActivityAnimation];
        if(error!=nil)
        {
            stutab.hidden = YES;
            [WToast showWithText:kMessage];
            return ;
        }
        else if ([[response objectForKey:@"status"]isEqualToString:@"false"])
        {
            
             stutab.hidden = YES;
            [WToast showWithText:@"暂时无数据"];
            return ;
        }
        else
        {
            if(isrefresh==NO)
            {
            [studata removeAllObjects];
            }
            for(NSDictionary *diction in [response objectForKey:@"data"])
            {
                [studata addObject:diction];
            }
            [stutab reloadData];
        }
    }];
}
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    isrefresh = YES;
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
    page++;
    [self getstudata:index andpagenum:page];
    [refersh endRefreshing];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
