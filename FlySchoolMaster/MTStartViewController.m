//
//  MTStartViewController.m
//  FlySchoolMaster
//
//  Created by caiyc on 14-6-10.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "MTStartViewController.h"
#import "SVHTTPRequest.h"
#import "UIImageView+webimage.h"
#import "FuncPublic.h"
#import "WToast.h"
#import "MTLoginViewController.h"
#import "MTAppDelegate.h"
@interface MTStartViewController ()
{
    UIImageView *image;
}
@end

@implementation MTStartViewController

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
    [self getvision];
     image = [[UIImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:image];
    [self loaddata];
    if([FuncPublic GetDefaultInfo:@"startimage"]==nil)
    {
         [self loaddata];
    }
   else
   {
       NSDictionary *dic = [FuncPublic GetDefaultInfo:@"startimage"];
       NSString *url = [dic objectForKey:@"url"];
        [image setLoadingImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.1.1:91%@",url]] placeholderImage:nil];
       
       
   }
    [self performSelector:@selector(pushnext) withObject:nil afterDelay:2];
   
}
-(void)loaddata
{
   
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dic setObject:[FuncPublic createUUID] forKey:@"r"];
    NSString *url = @"/api/startup/";
    
    [SVHTTPRequest GET:url parameters:dic completion:^(NSMutableDictionary * response, NSHTTPURLResponse *urlResponse, NSError *error) {
       
        if(error!=nil)
        {
            
            [WToast showWithText:kMessage];
            return ;
        }
        if([[response objectForKey:@"status"]isEqualToString:@"true"])
        {
            [FuncPublic SaveDefaultInfo:[response objectForKey:@"data"] Key:@"startimage"];
            NSString *url = [[response objectForKey:@"data"]objectForKey:@"url"];
           
            [image setLoadingImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://172.16.1.1:91%@",url]] placeholderImage:nil];
           

            
        }
    }];
    
   // [self performSelector:@selector(pushnext) withObject:nil afterDelay:2];

}
-(void)pushnext
{
    if([FuncPublic GetDefaultInfo:@"Newuser"]==NULL)
    {
        MTLoginViewController *login = [[MTLoginViewController alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
    else
    {
        MTAppDelegate *app = [[UIApplication sharedApplication]delegate];
        [app changeroot];
    }
}
-(void)getvision
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[FuncPublic createUUID] forKey:@"r"];//uuid
    
    [SVHTTPRequest GET:@"/api/base/iosUpdate.html"
            parameters:param
            completion:^(NSMutableDictionary *response, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                NSString *status = [FuncPublic tryObject:response Key:@"status" Kind:1]  ;
                if ([status isEqualToString:@"true"]) {
                    NSDictionary *dic = [response objectForKey:@"data"];
                    [FuncPublic SaveDefaultInfo:dic Key:@"APPVersion"];
                }
            }];

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
