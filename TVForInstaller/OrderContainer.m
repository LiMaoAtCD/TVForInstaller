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
@interface OrderContainer ()

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

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
    self.segmentedControl.verticalDividerColor = [UIColor colorWithHex:@"d8006c"];
    self.segmentedControl.verticalDividerWidth = 2.0;
//    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHex:@"d8006c"]};
//    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
//    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.view addSubview:self.segmentedControl];
}

-(void)segmentedControlChangedValue:(id)sender{
    
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
