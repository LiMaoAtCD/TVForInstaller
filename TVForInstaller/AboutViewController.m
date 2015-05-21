//
//  AboutViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/20.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "AboutViewController.h"
#import "ComminUtility.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"关于" forViewController:self];
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
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
