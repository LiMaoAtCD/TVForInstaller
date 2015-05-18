//
//  InstallViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "InstallViewController.h"
#import "InstallSegmentViewController.h"
@interface InstallViewController ()

@end

@implementation InstallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

-(void)viewWillAppear:(BOOL)animated{
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    InstallSegmentViewController *navigationController = [[InstallSegmentViewController alloc]initWithRootViewController:pageController];
    
    UIViewController *demo = [[UIViewController alloc]init];
    UIViewController *demo2 = [[UIViewController alloc]init];

    demo.view.backgroundColor = [UIColor redColor];
    demo2.view.backgroundColor = [UIColor whiteColor];

    [navigationController.viewControllerArray addObjectsFromArray:@[demo,demo2]];
    
    [self addChildViewController:navigationController];
    
    navigationController.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 44);

    [self.view addSubview:navigationController.view];
    
    
    
    [navigationController willMoveToParentViewController:self];
    [navigationController didMoveToParentViewController:self];
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
