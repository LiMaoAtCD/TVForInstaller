//
//  SettingViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "SettingViewController.h"
#import "ComminUtility.h"

#import "InfoViewController.h"
#import "AboutViewController.h"
#import "DeviceViewController.h"
#import "ModifyPasswordViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"设置" forViewController:self];
    
    self.navigationItem.leftBarButtonItem = nil;
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
- (IBAction)push:(id)sender {
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
//    
//    InfoViewController *info = [sb instantiateViewControllerWithIdentifier:@"InfoViewController"];
//    
//    info.hidesBottomBarWhenPushed = YES;
//    [self.navigationController showViewController:info sender:self];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    
    AboutViewController *info = [sb instantiateViewControllerWithIdentifier:@"AboutViewController"];
    
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:info sender:self];
//
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
////
//    DeviceViewController *info = [sb instantiateViewControllerWithIdentifier:@"DeviceViewController"];
//    
//    info.hidesBottomBarWhenPushed = YES;
//    [self.navigationController showViewController:info sender:self];
    
}
- (IBAction)ppp:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    
    ModifyPasswordViewController *info = [sb instantiateViewControllerWithIdentifier:@"ModifyPasswordViewController"];
    
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:info sender:self];
}

@end
