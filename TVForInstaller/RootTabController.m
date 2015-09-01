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
#import "ComminUtility.h"
@interface RootTabController ()

@property(nonatomic,strong) UIView * suspensionView;

@end

@implementation RootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
      [self.tabBar setTranslucent:NO];
    
   
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [self suspensionWindow:NO];

}

//-(void)manageLogState{
//    
//    if (![AccountManager isLogin]) {
//        
//        
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginNavigationController *login  =[sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
//        
//        [self showDetailViewController:login sender:self];
//        
//    } else{
//        
//    }
//
//}






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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
