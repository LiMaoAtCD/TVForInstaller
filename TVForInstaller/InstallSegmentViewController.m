//
//  InstallSegmentViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "InstallSegmentViewController.h"

@interface InstallSegmentViewController ()

@end

@implementation InstallSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    @property (nonatomic, strong) NSMutableArray *viewControllerArray;
//    @property (nonatomic, weak) id<RKSwipeBetweenViewControllersDelegate> navDelegate;
//    @property (nonatomic, strong) UIView *selectionBar;
//    @property (nonatomic, strong)UIPageViewController *pageController;
//    @property (nonatomic, strong)UIView *navigationView;
//    @property (nonatomic, strong)NSArray *buttonText;
    
    self.buttonText = @[@"S1级用户",@"装机历史"];
    self.selectionBar.backgroundColor = [UIColor whiteColor];
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
