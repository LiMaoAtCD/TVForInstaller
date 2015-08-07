//
//  ModifyPasswordViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "ComminUtility.h"
#import <SVProgressHUD.h>
#import "AccountManager.h"
#import "NetworkingManager.h"
#import "NSString+Hashes.h"



@interface ModifyPasswordViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *IdentityTF;
@property (weak, nonatomic) IBOutlet UIButton *IdentifyButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;

@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *verifyCode;


@end

typedef void(^alertBlock)(void);


@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureTextField];
    
    [ComminUtility configureTitle:@"修改密码" forViewController:self];
    
    
}

-(void)pop{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configureTextField{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:recognizer];

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


-(void)timerCount:(id)sender{
    _count--;
    
    if (_count > 0) {
        [self.IdentifyButton setTitle:[NSString stringWithFormat:@"%ld S",self.count] forState:UIControlStateNormal];
        self.IdentifyButton.userInteractionEnabled = NO;
    } else{
        
        [self.IdentifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.IdentifyButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    }
}


-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)getIdentityCode:(id)sender {
    
    _count = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCount:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    [SVProgressHUD showWithStatus:@"正在获取验证码"];
    
    
    
    [NetworkingManager fetchRegisterVerifyCode:[AccountManager getCellphoneNumber] withComletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            //error
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            
        } else{
            
            
            [SVProgressHUD showSuccessWithStatus:@"验证码获取成功"];

        }

    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (IBAction)modifyPassword:(id)sender {
    
    if ([self checkCompletion]) {
        
        [SVProgressHUD showWithStatus:@"正在修改"];
        
        [NetworkingManager ModifyPasswordwithNewPassword:[self.password sha1] verifyCode:self.verifyCode withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 0) {
                //error
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];

            } else{
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [AccountManager setPassword:self.password];
            }
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
    
}



-(BOOL)checkCompletion{
    
    if ([self.password isEqualToString:@""]||
        self.password == nil) {
        [self alertWithMessage:@"密码不能为空" withCompletionHandler:^{
            
        }];
        
        return NO;
    }
    
    
    
    if (![ComminUtility checkPassword:self.password]) {
        
        [self alertWithMessage:@"密码为4~16位字母数字组合" withCompletionHandler:^{
            
        }];
        return NO;

    }
    
    if (![self.confirmPasswordTF.text isEqualToString:self.password]) {
        
        [self alertWithMessage:@"二次密码不一致" withCompletionHandler:^{
            
        }];
        return NO;
    }
    
    if ([self.verifyCode isEqualToString:@""]||
        self.verifyCode == nil) {
        
        [self alertWithMessage:@"验证码不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }
    
    return YES;
    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.passwordTextField) {
        
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.password = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.password = textField.text;
            
        }else{
            self.password = [textField.text stringByAppendingString:string];
        }
    } else if(textField == self.IdentityTF){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.verifyCode = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.verifyCode = textField.text;
            
        }else{
            self.verifyCode = [textField.text stringByAppendingString:string];
            
        }
    }
    return YES;
}

-(void)alertWithMessage:(NSString*)message withCompletionHandler:(alertBlock)handler{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (handler) {
            handler();
        }
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)dismissKeyboard:(id)sender{
    
    [self.confirmPasswordTF resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.IdentityTF resignFirstResponder];
}

@end
