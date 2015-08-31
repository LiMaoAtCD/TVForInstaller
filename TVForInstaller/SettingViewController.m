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
#import <SVProgressHUD.h>
#import <SDImageCache.h>
#import <QiniuSDK.h>
#import <UIImageView+WebCache.h>


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
    
    [logout setAttributedTitle:[[NSAttributedString alloc]initWithString:@"注销" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0]}] forState:UIControlStateNormal];
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
    

    NSString *avatar = [AccountManager getAvatarUrlString];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"tou"]];

}


-(void)dealLogout{
    
    
    [AccountManager setLogin:NO];
    [AccountManager setName:nil];
    [AccountManager setRank:0];
    [AccountManager setScore:0];
    [AccountManager setgender:0];
    [AccountManager setIDCard:nil];
    [AccountManager setAddress:nil];
    [AccountManager setTokenID:nil];
    [AccountManager setLeaderID:nil];
    [AccountManager setAvatarUrlString:nil];
    [AccountManager setCellphoneNumber:nil];
    [AccountManager setPassword:nil];

    
    
    
    
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginNavigationController *login = [sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    
    [self showDetailViewController:login sender:nil];

}

-(void)logout{
    //TODO: 注销
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"" message:@"确认注销" preferredStyle:UIAlertControllerStyleAlert];
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
        
        UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [SVProgressHUD showWithStatus:@"正在上传头像"];
        
        [NetworkingManager fetchAvatarImageTokenWithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 0) {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                
            } else {
                //token获取成功
                NSString *token = responseObject[@"obj"];
                
                //七牛初始化
                QNUploadManager *upManager = [[QNUploadManager alloc] init];

                //获取图片并转换成NSData
                NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.2);
                
                //根据时间生成唯一Key
                NSDate *date = [NSDate date];
                
                NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YY-MM-dd-HH-mm-SS"];
                
                NSString *key = [formatter stringFromDate:date];
                
                //上传七牛
                [upManager putData:imageData key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    
                    NSLog(@"Qiniu callback   info：%@ \n key: %@ \n resp: %@",info,key,resp);
                    
                    //获取回调
                    
                    if ([resp[@"success"] integerValue] == 1) {
                        
                        [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
                        NSURL *url =[NSURL URLWithString:resp[@"obj"]];
                        [AccountManager setAvatarUrlString:resp[@"obj"]];
                        [self.avatarImageView sd_setImageWithURL:url placeholderImage:tempImage];
                    
                    } else{
                        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                    }
                    
                } option:nil];
            
            }
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
}

-(void)getInviteCode{
    //TODO:: 获取邀请码
    [SVProgressHUD showWithStatus:@"正在获取邀请码"];

    
    //
    [NetworkingManager fetchInviteByTokenID:[AccountManager getTokenID] withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            //error
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        } else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *code = responseObject[@"obj"];
                [SVProgressHUD dismiss];

                [self showInviteCode:code];
               
                
                
            });
        }
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
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
//        contentView.backgroundColor = [UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0];
        contentView.backgroundColor = [UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0];
        
        
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
