//
//  OrderContainer.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/15.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OrderContainer.h"
#import <HMSegmentedControl.h>
#import "ComminUtility.h"
#import "UIColor+HexRGB.h"

#import "OrderMapViewController.h"
#import "MyOrderViewController.h"

@interface OrderContainer ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) MyOrderViewController *myOrderViewController;
@property (nonatomic, strong) OrderMapViewController *orderMapViewController;

@end

@implementation OrderContainer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"订单" forViewController:self];
    self.navigationItem.leftBarButtonItem = nil;
    

    CGFloat viewWidth = CGRectGetWidth([UIScreen mainScreen].bounds);

    self.segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64.0, viewWidth, 35.0)];
    self.segmentedControl.sectionTitles = @[@"抢 单       ", @"我的订单"];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    self.segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    self.segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]};
    self.segmentedControl.selectionIndicatorColor = [UIColor blackColor];
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.selectionIndicatorHeight = 4.0;
    
    self.segmentedControl.verticalDividerEnabled = YES;
    self.segmentedControl.verticalDividerColor = [UIColor colorWithHex:@"fe7676"];
    self.segmentedControl.verticalDividerWidth = 2.0;
//    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHex:@"d8006c"]};
//    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
//    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:self.segmentedControl];
    
    
    
    
    
    if (!self.orderMapViewController) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];

        self.orderMapViewController = [sb instantiateViewControllerWithIdentifier:@"OrderMapViewController"];
    }
    
    [self addChildViewController:self.orderMapViewController];
    
    [self.orderMapViewController willMoveToParentViewController:self];
    
    self.orderMapViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.orderMapViewController.view];
    
    [self.orderMapViewController didMoveToParentViewController:self];
    
    if (self.myOrderViewController) {
        
        [self.myOrderViewController removeFromParentViewController];
        [self.myOrderViewController.view removeFromSuperview];
    }

}


-(void)segmentedControlChangedValue:(id)sender{
    HMSegmentedControl *control = (HMSegmentedControl*)sender;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    
    if (control.selectedSegmentIndex == 0) {
        //抢单
        
        if (!self.orderMapViewController) {
            
            self.orderMapViewController = [sb instantiateViewControllerWithIdentifier:@"OrderMapViewController"];
        }
        
        [self addChildViewController:self.orderMapViewController];
        
        [self.orderMapViewController willMoveToParentViewController:self];
        
        self.orderMapViewController.view.frame = self.contentView.bounds;
        [self.contentView addSubview:self.orderMapViewController.view];
        
        [self.orderMapViewController didMoveToParentViewController:self];
        
        if (self.myOrderViewController) {
            
            [self.myOrderViewController removeFromParentViewController];
            [self.myOrderViewController.view removeFromSuperview];
        }

    } else{
        //我的订单
        
        if (!self.myOrderViewController) {
            
            self.myOrderViewController = [sb instantiateViewControllerWithIdentifier:@"MyOrderViewController"];
        }
        
        [self addChildViewController:self.myOrderViewController];
        
        [self.myOrderViewController willMoveToParentViewController:self];
        
        self.myOrderViewController.view.frame = self.contentView.bounds;
        [self.contentView addSubview:self.myOrderViewController.view];
        
        [self.orderMapViewController didMoveToParentViewController:self];
        
        if (self.orderMapViewController) {
            
            [self.orderMapViewController removeFromParentViewController];
            [self.orderMapViewController.view removeFromSuperview];

        }

    }
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
