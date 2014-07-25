//
//  linianGZViewController.m
//  scrollview
//
//  Created by huxg on 14-6-18.
//  Copyright (c) 2014年 MingThink. All rights reserved.
//

#import "linianGZViewController.h"

@interface linianGZViewController ()

@end

@implementation linianGZViewController

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
    name.text = _namestr;
    number.text = _numberstr;
    info.text = _infostr;
    score.text = _scrostr;
    campus.text = _yuanxstr;
    specialty.text = _zhuanystr;
    // Do any additional setup after loading the view from its nib.
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
