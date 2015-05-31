//
//  SuspensionViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/28.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "SuspensionViewController.h"
#import "DeviceViewController.h"
#import "Animator.h"
#import "DeviceSuspensionController.h"
#import "DLNAManager.h"
#import "ComminUtility.h"

@interface SuspensionViewController ()<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIButton *deviceList;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

@end

@implementation SuspensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popDeviceWindow:)];
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
    [self showSuspensionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSuspensionView) name:[ComminUtility kSuspensionWindowShowNotification] object:nil];

}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    NSString *renderer = [[DLNAManager DefaultManager] getCurrentSpecifiedRenderer];
//    
//    if ([renderer isEqualToString:@"None"]||
//        renderer == nil) {
//        self.deviceNameLabel.text = @"未连接";
//        
//    }else{
//        self.deviceNameLabel.text = renderer;
//        
//    }
//}

-(void)showSuspensionView{
    
    NSString *renderer = [[DLNAManager DefaultManager] getCurrentSpecifiedRenderer];

    if ([renderer isEqualToString:@"无"]) {
        self.deviceNameLabel.text = @"未连接";

    }else{
        self.deviceNameLabel.text = @"已连接";

    }
}



-(void)popDeviceWindow:(UIButton*)button{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DeviceSuspensionController *device = [sb instantiateViewControllerWithIdentifier:@"DeviceSuspensionController"];
    
    device.transitioningDelegate = self;
    
    
    
    [self showDetailViewController:device sender:self];
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

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[Animator alloc] init];
}

//- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
//    return [[Animator alloc] init];
//
//}
//


@end
