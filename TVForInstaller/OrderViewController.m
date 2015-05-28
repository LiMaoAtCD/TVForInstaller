//
//  OrderViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OrderViewController.h"
#import "UnSubmitViewController.h"
#import "CompleteTableViewController.h"
#import "PersonalOrderTableViewController.h"

#import "ComminUtility.h"

typedef enum : NSUInteger {
    OrderUnsubmit,
    OrderCompleted
    
} OrderType;

@interface OrderViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong) UnSubmitViewController *unsubmitViewController;
@property (nonatomic,strong) CompleteTableViewController *completeTableViewController;
@property (weak, nonatomic) IBOutlet UIButton *unsumitButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;



@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [ComminUtility configureTitle:@"订单" forViewController:self];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.translucent  = NO;

    [self selectIndex:OrderUnsubmit];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn addTarget:self action:@selector(clickToOpenPersonalOrder:) forControlEvents:UIControlEventTouchUpInside];

    btn.frame = CGRectMake(0, 0, 40, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}


-(void)clickToOpenPersonalOrder:(UIButton*)button{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    
    
    PersonalOrderTableViewController *pOrder = [sb instantiateViewControllerWithIdentifier:@"PersonalOrderTableViewController"];
    
    pOrder.hidesBottomBarWhenPushed  = YES;
    
    [self.navigationController showViewController:pOrder  sender:self];
    
    
    
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
        
        self.unsubmitViewController.view.frame = self.contentView.bounds;
        [self.contentView addSubview:self.unsubmitViewController.view];
        
        [self.unsubmitViewController didMoveToParentViewController:self];
        
        if (self.completeTableViewController) {
            
            [self.completeTableViewController removeFromParentViewController];
            [self.completeTableViewController.view removeFromSuperview];
        }
        
        
        UIColor *color = [UIColor colorWithRed:19./255 green:82./255 blue:115./255 alpha:1.0];

        [self.unsumitButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"未提交" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
        
        [self.unsumitButton setBackgroundImage:[UIImage imageNamed:@"zuo"] forState:UIControlStateNormal];
        
        self.unsumitButton.userInteractionEnabled = NO;
        self.unsumitButton.showsTouchWhenHighlighted = NO;
        
        
        [self.completeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"已完成" attributes:@{NSForegroundColorAttributeName:color}] forState:UIControlStateNormal];
        
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"you1"] forState:UIControlStateNormal];
        
        self.completeButton.userInteractionEnabled = YES;
        
        
    } else{
        
        if (!self.completeTableViewController) {
            
            self.completeTableViewController = [sb instantiateViewControllerWithIdentifier:@"CompleteTableViewController"];
        }
        
        [self addChildViewController:self.completeTableViewController];
        
        [self.completeTableViewController willMoveToParentViewController:self];
        
        self.completeTableViewController.view.frame = self.contentView.bounds;

        [self.contentView addSubview:self.completeTableViewController.view];
        
        [self.completeTableViewController didMoveToParentViewController:self];
        
        if (self.unsubmitViewController) {
            
            [self.unsubmitViewController removeFromParentViewController];
            [self.unsubmitViewController.view removeFromSuperview];
        }
        
        UIColor *color = [UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0];
        [self.unsumitButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"未提交" attributes:@{NSForegroundColorAttributeName:color}] forState:UIControlStateNormal];
        
        [self.unsumitButton setBackgroundImage:[UIImage imageNamed:@"zuo1"] forState:UIControlStateNormal];
        
        self.unsumitButton.userInteractionEnabled = YES;
        
        
        [self.completeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"已完成" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
        
        [self.completeButton setBackgroundImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
        
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
