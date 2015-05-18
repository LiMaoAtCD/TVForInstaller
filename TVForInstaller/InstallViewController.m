//
//  InstallViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "InstallViewController.h"
#import "InstallSegmentViewController.h"

#import "S1ViewController.h"
#import "InstallHistoryViewController.h"
@interface InstallViewController ()

@end



@implementation InstallViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    InstallSegmentViewController *navigationController = [[InstallSegmentViewController alloc]initWithRootViewController:pageController];
    
    
    S1ViewController *vc1 = [[S1ViewController alloc]initWithNibName:@"S1ViewController" bundle:nil];
    vc1.view.backgroundColor = [UIColor yellowColor];
    
    
    InstallHistoryViewController *vc2 = [[InstallHistoryViewController alloc]initWithNibName:@"InstallHistoryViewController" bundle:nil];
    
    vc2.view.backgroundColor = [UIColor redColor];
    
    [navigationController.viewControllerArray addObjectsFromArray:@[vc1,vc2]];
    
    
    [self addChildViewController:navigationController];
    
    navigationController.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64 - 44);
    
    [self.view addSubview:navigationController.view];
    
    
    
    [navigationController willMoveToParentViewController:self];
    [navigationController didMoveToParentViewController:self];

}

-(void)viewWillAppear:(BOOL)animated{
   
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
