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
#import "AvatorDetailViewController.h"


@interface SettingViewController ()<AvatarSelectionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *DetailViews;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"设置" forViewController:self];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.avatarImageView.layer.cornerRadius = 40.0;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 2.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChangeAvator)];
    [self.avatarImageView addGestureRecognizer:tap];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.DetailViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view  = obj;
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDetailView:)];
        
        [view addGestureRecognizer:tap];

    }];
    
    
}

-(void)clickDetailView:(UITapGestureRecognizer *)gesture{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    switch (gesture.view.tag) {
        case 0:
        {
            DeviceViewController *device = [sb instantiateViewControllerWithIdentifier:@"DeviceViewController"];
            device.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:device sender:self];
        }
            break;
        case 1:
        {
            DeviceViewController *device = [sb instantiateViewControllerWithIdentifier:@"DeviceViewController"];
            [self.navigationController showViewController:device sender:self];
        }
            break;
        case 2:
        {
            DeviceViewController *device = [sb instantiateViewControllerWithIdentifier:@"DeviceViewController"];
            [self.navigationController showViewController:device sender:self];
        }
            break;
        case 3:
        {
            InfoViewController *info = [sb instantiateViewControllerWithIdentifier:@"InfoViewController"];
            info.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:info sender:self];
        }
            break;
        case 4:
        {
            ModifyPasswordViewController *pwd = [sb instantiateViewControllerWithIdentifier:@"ModifyPasswordViewController"];
            pwd.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController showViewController:pwd sender:self];
        }
            break;
        case 5:
        {
            AboutViewController *about = [sb instantiateViewControllerWithIdentifier:@"AboutViewController"];
            about.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:about sender:self];
        }
            break;

    }
}



-(void)tapToChangeAvator{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    
    
    AvatorDetailViewController *avatar = [sb instantiateViewControllerWithIdentifier:@"AvatorDetailViewController"];
    self.view.backgroundColor = [UIColor clearColor];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    avatar.delegate = self;
    [self showDetailViewController:avatar sender:self];
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


-(void)didSelectButtonAtIndex:(AvatarType)type{
    if (type == Camera) {
        //调用系统相机
        
        NSLog(@"xxx");
    } else {
        //调用相册
        
        NSLog(@"xxxx");

    }
}

@end
