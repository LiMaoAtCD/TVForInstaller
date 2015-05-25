//
//  OrderViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OrderViewController.h"
#import "UnSubmitViewController.h"
#import "CompletionOrderViewController.h"


#import "ComminUtility.h"

typedef enum : NSUInteger {
    OrderUnsubmit,
    OrderCompleted
    
} OrderType;

@interface OrderViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong) UnSubmitViewController *unsubmitViewController;
@property (nonatomic,strong) CompletionOrderViewController *completionOrderViewController;
@property (weak, nonatomic) IBOutlet UIButton *unsumitButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;



@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [ComminUtility configureTitle:@"订单" forViewController:self];
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [self selectIndex:OrderUnsubmit];

}


- (IBAction)clickUnsubmit:(id)sender {
    [self selectIndex:OrderUnsubmit];
}
- (IBAction)clickCompletionButton:(id)sender {
    [self selectIndex:OrderCompleted];

}

-(void)selectIndex:(OrderType)type{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    
    if (type == OrderUnsubmit) {
        
        if (!self.unsubmitViewController) {
            
            self.unsubmitViewController = [sb instantiateViewControllerWithIdentifier:@"UnSubmitViewController"];
        }
        
        [self addChildViewController:self.unsubmitViewController];
    
        [self.unsubmitViewController willMoveToParentViewController:self];
        
        [self.contentView addSubview:self.unsubmitViewController.view];
        
        [self.unsubmitViewController didMoveToParentViewController:self];
        
        if (self.completionOrderViewController) {
            
            [self.completionOrderViewController removeFromParentViewController];
            [self.completionOrderViewController.view removeFromSuperview];
        }
        
        
        UIColor *color = [UIColor colorWithRed:19./255 green:82./255 blue:115./255 alpha:1.0];

        [self.unsumitButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"未提交" attributes:@{NSForegroundColorAttributeName:color}] forState:UIControlStateNormal];
        
        [self.unsumitButton setBackgroundImage:[UIImage imageNamed:@"zuo1"] forState:UIControlStateNormal];
        
        self.unsumitButton.userInteractionEnabled = NO;
        self.unsumitButton.showsTouchWhenHighlighted = NO;
        
        
        [self.completeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"已完成" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
        
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        
        self.completeButton.userInteractionEnabled = YES;
        
        
    } else{
        
        if (!self.completionOrderViewController) {
            
            self.completionOrderViewController = [sb instantiateViewControllerWithIdentifier:@"CompletionOrderViewController"];
        }
        
        [self addChildViewController:self.completionOrderViewController];
        
        [self.completionOrderViewController willMoveToParentViewController:self];
        
        [self.contentView addSubview:self.completionOrderViewController.view];
        
        [self.completionOrderViewController didMoveToParentViewController:self];
        
        if (self.unsubmitViewController) {
            
            [self.unsubmitViewController removeFromParentViewController];
            [self.unsubmitViewController.view removeFromSuperview];
        }
        
        UIColor *color = [UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0];
        [self.unsumitButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"未提交" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
        
        [self.unsumitButton setBackgroundImage:[UIImage imageNamed:@"zuo"] forState:UIControlStateNormal];
        
        self.unsumitButton.userInteractionEnabled = YES;
        
        
        [self.completeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"已完成" attributes:@{NSForegroundColorAttributeName:color}] forState:UIControlStateNormal];
        
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"you1"] forState:UIControlStateNormal];
        
        self.completeButton.userInteractionEnabled = NO;

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
