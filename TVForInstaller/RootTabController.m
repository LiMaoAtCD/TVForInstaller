//
//  RootTabController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "RootTabController.h"
#import "AccountManager.h"

#import "LoginNavigationController.h"

@interface RootTabController ()

@end

@implementation RootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self manageLogState];
   
    
}

-(void)manageLogState{
    
    if ([AccountManager isLogin]) {
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginNavigationController *login  =[sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        
        [self showDetailViewController:login sender:self];
        
    } else{
        //
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginNavigationController *login  =[sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
//        
//        [self showDetailViewController:login sender:self];
//        
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
