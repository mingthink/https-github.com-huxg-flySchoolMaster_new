//
//  MTNotiMessageViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-19.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTNotiMessageViewController.h"
#import "FuncPublic.h"
#import "MTNEwsDetailViewController.h"
@interface MTNotiMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dataarr;
    UITableView *mytab;
}
@end

@implementation MTNotiMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(DEVH==480)
    {
        NSLog(@"comr in    ....");
        [_mybutton setFrame:CGRectMake(0, DEVH-200, 320, 50)];
    }
    NSLog(@"数据源。。。。。%@",[FuncPublic GetDefaultInfo:@"MessageListData"]);
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"savemesstest"];
   // dataarr = [FuncPublic GetDefaultInfo:@"MessageListData"];
    dataarr = [NSKeyedUnarchiver unarchiveObjectWithFile: filename];
    if(dataarr==NULL)
        dataarr = [[NSMutableArray alloc]init];
    mytab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, DEVH-50-64) style:UITableViewStylePlain];
    mytab.delegate = self;
    mytab.dataSource = self;
    [self.view addSubview:mytab];
    
    
    NSLog(@"消息通知新消息是:%d",dataarr.count);
    NSLog(@"消息通知新消息是:%@",dataarr);
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataarr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"TableViewCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSMutableDictionary*    dict    =   [dataarr objectAtIndex:indexPath.row];
    
    if ([[dict objectForKey:@"isreader"] isEqualToString:@"1"]) {
        [FuncPublic InstanceImageView:@"msg_icon_b" Ect:@"png" RECT:CGRectMake(11, 14, 23, 16) Target:cell.contentView TAG:0];
    }else{
        [FuncPublic InstanceImageView:@"msg_icon_a" Ect:@"png" RECT:CGRectMake(11, 14, 23, 16) Target:cell.contentView TAG:0];
    }
    
    
    
    
    [FuncPublic InstanceLabel:[dict objectForKey:@"param"] RECT:CGRectMake(40, 10, 200, 21) FontName:@"" Red:0 green:0 blue:0 FontSize:16 Target:cell.contentView Lines:0 TAG:0 Ailgnment:2];
    return cell;
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中
    if([[[dataarr objectAtIndex:indexPath.row]objectForKey:@"module"]isEqualToString:@"1"])
    {
        MTNEwsDetailViewController *newsdetail = [[MTNEwsDetailViewController alloc]init];
        newsdetail.urlstr = [[dataarr objectAtIndex:indexPath.row]objectForKey:@"param"];
        [self.navigationController pushViewController:newsdetail animated:NO];
    }
    //NSMutableDictionary *dic = [dataarr objectAtIndex:indexPath.row];
   // [dic setObject:@"1" forKey:@"isreader"];
//    for (int i=0; i<dataarr.count; i++) {
//        NSMutableDictionary *savaDic = [dataarr objectAtIndex:i];
//        if (i == indexPath.row) {
//            [savaDic setObject:@"1" forKey:@"isreader"];
//        }
//    }
//    [FuncPublic SaveDefaultInfo:dataarr Key:@"MessageListData"];
//    [FuncPublic ShowAlert:[dic objectForKey:@"param"]];
//    [tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clear:(id)sender {
}

//- (IBAction)delete:(id)sender {
//
//    [dataarr removeAllObjects];
//    [mytab reloadData];
////    NSMutableArray *temparr = [FuncPublic GetDefaultInfo:@"MessageListData"];
////    [temparr removeAllObjects];
////   temparr = nil;
////    [FuncPublic SaveDefaultInfo:temparr Key:@"MessageListData"];
//    [FuncPublic SaveDefaultInfo:nil Key:@"MessageListData"];
//    
//    
//}
- (IBAction)cle:(id)sender {
    NSLog(@"clear....");
    [dataarr removeAllObjects];
    [mytab reloadData];
//        NSMutableArray *temparr = [[NSMutableArray alloc]initWithArray:[FuncPublic GetDefaultInfo:@"MessageListData"]];
//        [temparr removeAllObjects];
//       temparr = nil;

 //   [FuncPublic SaveDefaultInfo:nil Key:@"MessageListData"];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"savemesstest"];
    NSFileManager *file = [NSFileManager defaultManager];
    [file removeItemAtPath:filename error:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clearcache" object:nil userInfo:nil];

    
}
@end
