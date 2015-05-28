//
//  SuspensionViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/28.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "SuspensionViewController.h"
#import "DeviceViewController.h"
@interface SuspensionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *deviceList;

@end

@implementation SuspensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popDeviceWindow:)];
    tap.numberOfTapsRequired = 1;
    
//    [self.view addGestureRecognizer:tap];
    
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.masksToBounds = YES;
    
    
}




-(void)popDeviceWindow:(UIButton*)button{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    
    DeviceViewController *device = [sb instantiateViewControllerWithIdentifier:@"DeviceViewController"];
    
    self.modalPresentationStyle =UIModalPresentationOverCurrentContext;
    
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

@end
