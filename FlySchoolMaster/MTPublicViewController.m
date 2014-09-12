//
//  MTPublicViewController.m
//  FlySchoolMaster
//
//  Created by huxg on 14-9-11.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTPublicViewController.h"
#import "SVHTTPRequest.h"
@interface MTPublicViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrary;
    BOOL classSelect;
    UIImageView *view;
    UITableView *maintab;
    UIButton *but;
}
@end

@implementation MTPublicViewController

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
    [self getclassData];
    self.view.backgroundColor = [UIColor whiteColor];
    arrary = [[NSMutableArray alloc]initWithCapacity:0];
    [FuncPublic InstanceNavgationBar:@"公示栏" action:@selector(back) superclass:self isroot:NO];
    [FuncPublic InstanceLabel:@"请选择：" RECT:CGRectMake(80, 62, 70, 30) FontName:nil Red:0 green:0 blue:0 FontSize:16 Target:self.view Lines:1 TAG:0 Ailgnment:2];
    //but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    but = [FuncPublic InstanceButton:@"1" Ect:@"png" RECT:CGRectMake(150, 62, 160, 30) AddView:self.view ViewController:self SEL_:@selector(classSelect) Kind:1 TAG:0];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    maintab = [[UITableView alloc]initWithFrame:CGRectMake(0, 93, DEVW, DEVH-93)];
    maintab.delegate = self;
    maintab.dataSource = self;
    
    [self.view addSubview:maintab];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)classSelect
{
    classSelect = !classSelect;
    
    //view.backgroundColor = []
    
    NSLog(@"count is .%d",arrary.count);
    if(classSelect)
        view.hidden = NO;
    else
        view.hidden = YES;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* vii = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVW, 5)];
    vii.backgroundColor = [UIColor lightGrayColor];
    return vii;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

-(void)getList:(NSString*)ID
{
    
}
-(void)getclassData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    NSDictionary *userdic = [FuncPublic GetDefaultInfo:@"Newuser"];
    [dic setObject:[NSString stringWithFormat:@"%@",[userdic objectForKey:@"organID"]] forKey:@"oid"];
    [dic setObject:[NSString stringWithFormat:@"%@",[userdic objectForKey:@"uid"]] forKey:@"uid"];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    [SVHTTPRequest GET:@"/api/information/category.html" parameters:dic
 completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
     arrary = [response objectForKey:@"data"];
     NSLog(@"arr %@",arrary);
     view = [[UIImageView alloc]initWithFrame:CGRectMake(150, 92, 160, 30*arrary.count)];
     //view.backgroundColor = [UIColor blackColor];
     view.hidden = YES;
     view.userInteractionEnabled = YES;
    for (int i=0; i<arrary.count; i++) {
        UIButton *button = [FuncPublic InstanceButton:@"setting_btn_bg" Ect:@"png" RECT:CGRectMake(0, i*28, 160, 30) AddView:view ViewController:self SEL_:@selector(click:) Kind:1 TAG:i];
        [button setTitle:[NSString stringWithFormat:@"%@",[[arrary objectAtIndex:i] valueForKey:@"cateName"]] forState:UIControlStateNormal];
//        button.tintColor = [UIColor blackColor];
//        
        button.contentHorizontalAlignment = 1;
        
    }
     [self.view addSubview:view];
 }];
    
}

-(void)click:(UIButton*)sender
{
    NSLog(@"btn tag is %i",sender.tag);
    [but setTitle:[NSString stringWithFormat:@"%@",[sender currentTitle]] forState:UIControlStateNormal];
    but.contentHorizontalAlignment = 1;
    
    view.hidden = YES;
    classSelect = !classSelect;
    NSString *classID = [[arrary objectAtIndex:sender.tag]objectForKey:@"id"];
    NSLog(@"%@",classID);
    [self getList:classID];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [but resignFirstResponder];
}
-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
