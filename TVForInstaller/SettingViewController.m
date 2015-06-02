//
//  SettingViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "SettingViewController.h"
#import "ComminUtility.h"

#import "InfoTableViewController.h"
#import "AboutViewController.h"
#import "DeviceViewController.h"
#import "ModifyPasswordViewController.h"
#import "AvatorDetailViewController.h"
#import "GradeViewController.h"
#import "MyAccoutViewController.h"
#import "InvatationViewController.h"
#import "MyChildrenViewController.h"
#import "InstallHistoryViewController.h"

#import "AccountManager.h"
#import "LoginNavigationController.h"

#import "NetworkingManager.h"
#import <JGProgressHUD.h>
#import <SDImageCache.h>


@interface SettingViewController ()<AvatarSelectionDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *DetailViews;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"设置" forViewController:self];
    self.navigationController.navigationBar.translucent = NO;
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [logout setAttributedTitle:[[NSAttributedString alloc]initWithString:@"注销" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}] forState:UIControlStateNormal];
    logout.frame = CGRectMake(0, 0, 40, 30);
    [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logout];
    
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.avatarImageView.layer.cornerRadius = 40.0;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 2.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToChangeAvator)];
    [self.avatarImageView addGestureRecognizer:tap];
    

    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:@"kLocalAvatarImage"];
    
    if (image) {
        self.avatarImageView.image  = image;

    }else{
        self.avatarImageView.image = [UIImage imageNamed:@"tou"];
    }
    
    
}


-(void)dealLogout{
    
    [AccountManager setLogin:NO];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginNavigationController *login = [sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    
    [self showDetailViewController:login sender:nil];

}

-(void)logout{
    //TODO: 注销
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"" message:@"确认注销吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dealLogout];
    }];
    [alert addAction:action];
    [alert addAction:loginAction];
    
    [self showDetailViewController:alert sender:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.nameLabel.text = [AccountManager getName];
    self.gradeLabel.text = [NSString stringWithFormat:@"%ld",[AccountManager getScore]];
    
    NSInteger level =  [AccountManager getRank];
    if (level == 0) {
        
      
        self.rankLabel.text = @"银卡";
        self.rankImageView.image = [UIImage imageNamed:@"yinka"];

    } else if (level ==1){
        self.rankLabel.text = @"金卡";
        self.rankImageView.image = [UIImage imageNamed:@"jinka"];

    } else{
        self.rankLabel.text = @"钻石";
        self.rankImageView.image = [UIImage imageNamed:@"zuanshi"];

    }
    
   
    
    
    
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
            MyAccoutViewController *account = [sb instantiateViewControllerWithIdentifier:@"MyAccoutViewController"];
            account.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:account sender:self];
        }
            break;
        case 2:
        {
            GradeViewController *grade = [sb instantiateViewControllerWithIdentifier:@"GradeViewController"];
            grade.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:grade sender:self];
        }
            break;
        case 3:
        {
            MyChildrenViewController *child = [sb instantiateViewControllerWithIdentifier:@"MyChildrenViewController"];
            child.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:child sender:self];
        }
            break;
        case 4:
        {
//            InvatationViewController *invate = [sb instantiateViewControllerWithIdentifier:@"InvatationViewController"];
//            invate.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController showViewController:invate sender:self];
            
            [self getInviteCode];
            
        }
            break;
        case 5:
        {
            InfoTableViewController *info = [sb instantiateViewControllerWithIdentifier:@"InfoTableViewController"];
            info.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:info sender:self];
        }
            break;
        case 6:
        {
            ModifyPasswordViewController *pwd = [sb instantiateViewControllerWithIdentifier:@"ModifyPasswordViewController"];
            pwd.hidesBottomBarWhenPushed = YES;
            [self.navigationController showViewController:pwd sender:self];

        }
            break;
        case 7:
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
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    avatar.delegate = self;
    [self showDetailViewController:avatar sender:self];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)launchImagePickerWithType:(AvatarType)type{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;

    if (type == Camera) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;

    } else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self showDetailViewController:picker sender:self];
}


-(void)didSelectButtonAtIndex:(AvatarType)type{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if (type == Camera) {
        //调用系统相机
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] ) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
       
    
    } else {
        //调用相册
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    picker.delegate = self;
    
    picker.allowsEditing = YES;
    
    [self showDetailViewController:picker sender:self];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    @autoreleasepool {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //TODO: deal image;
        self.avatarImageView.image = image;
        
        [[SDImageCache sharedImageCache] storeImage:image forKey:@"kLocalAvatarImage" toDisk:YES];
        
        
        
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)getInviteCode{
    //TODO:: 获取邀请码
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    hud.textLabel.text = @"获取邀请码";
//    hud.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
    hud.tapOnHUDViewBlock = ^(JGProgressHUD *hud){
        
        [hud dismiss];
    };
    hud.tapOutsideBlock = ^(JGProgressHUD *hud){
        
        [hud dismiss];
    };
    [hud showInRect:CGRectMake(0, 0, 200, 200) inView:self.view];
    hud.center = self.view.center;
    

    
    //
    [NetworkingManager fetchInviteByTokenID:[AccountManager getTokenID] withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            //error
            [hud dismiss];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                hud.indicatorView = nil;
                hud.textLabel.text = responseObject[@"msg"];
                
                [hud dismissAfterDelay:2.0];
            });
            
            
        } else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *code = responseObject[@"obj"];
                NSLog(@"%@",code);
                [hud dismiss];

                [self showInviteCode:code];
               
                
                
            });
        }
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud dismiss];
        
    }];


    
}

-(void)showInviteCode:(NSString*)code{
    
    @autoreleasepool {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        view.alpha = 0.0;
        view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
        contentView.center = view.center;
        contentView.backgroundColor =[UIColor whiteColor];
        contentView.layer.cornerRadius = 10.0;
        contentView.layer.masksToBounds = YES;
        contentView.backgroundColor = [UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0];
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, contentView.frame.size.width, 30)];
        title.text = @"邀请码";
        title.font = [UIFont boldSystemFontOfSize:14.0];
        title.textColor =[UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        
        [contentView addSubview:title];
        
        UILabel *codeView = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, contentView.frame.size.width, 30)];
        codeView.text = code;
        codeView.textAlignment = NSTextAlignmentCenter;
        codeView.textColor =[UIColor whiteColor];

        [contentView addSubview:codeView];
        
        [view addSubview:contentView];
        
        [self.view addSubview:view];
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissInviteView:)];
        [view addGestureRecognizer:tap];
        
        contentView.frame = CGRectMake(0, 0, 1, 1);
        contentView.center = view.center;
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            view.alpha = 1.0;
            contentView.frame = CGRectMake(0, 0, 200, 150);

            contentView.center = view.center;
        } completion:^(BOOL finished) {
            
        }];

    }

}

-(void)tapToDismissInviteView:(UITapGestureRecognizer*)ges{
    
    UIView *view = ges.view;
    
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end
