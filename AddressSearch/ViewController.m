//
//  ViewController.m
//  AddressSearch
//
//  Created by 贺乾龙 on 2017/5/9.
//  Copyright © 2017年 HQL. All rights reserved.
//

#import "ViewController.h"
#import "AddressBookViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(70, 150, 200, 70)];
    [btn setTitle:@"获取通讯录" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)btnClick{

    AddressBookViewController *vc = [[AddressBookViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
