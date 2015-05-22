//
//  MyAccoutViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/22.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "MyAccoutViewController.h"
#import "ComminUtility.h"
@interface MyAccoutViewController ()

@end

@implementation MyAccoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"我的账户" forViewController:self];
    
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
