//
//  ForgetViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "ForgetViewController.h"
#import "ComminUtility.h"
#import "AccountManager.h"
#import "NetworkingManager.h"
#import <SVProgressHUD.h>
#import "NSString+Hashes.h"

@interface ForgetViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cellphoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UIButton *verfifyCodeButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger count;


@property (nonatomic,copy) NSString *cellphone;

@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *verifyCode;

@end

typedef void(^alertBlock)(void);


@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"忘记密码" forViewController:self];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:recognizer];
    [self configuretextfields];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

-(void)dismissKeyboard:(id)sender{
    
    [self.cellphoneTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.confirmTF resignFirstResponder];

    [self.verifyTF resignFirstResponder];

}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
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


- (IBAction)getVerifyCode:(id)sender {
    
    if (![ComminUtility checkTel:self.cellphone]) {
        [self alertWithMessage:@"手机号码不合法" withCompletionHandler:^{
            
        }];
        return;
    } else {
        _count = 60;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCount:) userInfo:nil repeats:YES];
        [self.timer fire];
        
        [SVProgressHUD showWithStatus:@"正在获取验证码"];
      
        
        
        [NetworkingManager fetchForgetPasswordVerifyCode:self.cellphone withComletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                //error
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            } else{
                [SVProgressHUD showSuccessWithStatus:@"验证码获取成功"];
            }
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
   
   
}

- (IBAction)submit:(id)sender {
    
    if ([self checkCompletion]) {
    
        [SVProgressHUD showWithStatus:@"正在重置密码"];

        
        [NetworkingManager forgetPasswordOnCellPhone:self.cellphone password:[self.password sha1] verifyCode:self.verifyCode withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 0) {
                //error
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            
            } else{
                
                [SVProgressHUD showSuccessWithStatus:@"重置成功,请重新登录"];
               

            }
        }failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}




-(void)configuretextfields{
    
//    self.cellphoneTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
//    self.passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
//    self.confirmTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认密码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
//    self.verifyTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}


-(BOOL)checkCompletion{
    
    if ([self.cellphone isEqualToString:@""]||
        self.cellphone == nil
        ) {
        [self alertWithMessage:@"手机号码不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }
    
    if (![ComminUtility checkTel:self.cellphone]) {
        [self alertWithMessage:@"手机号码不合法" withCompletionHandler:^{
            
        }];
        return NO;
    }
    
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
    
    if (![self.confirmTF.text isEqualToString:self.password]) {
        
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






-(void)timerCount:(id)sender{
    _count--;
    
    if (_count > 0) {
        [self.verfifyCodeButton setTitle:[NSString stringWithFormat:@"%ld S",self.count] forState:UIControlStateNormal];
        self.verfifyCodeButton.userInteractionEnabled = NO;
    } else{
        
        [self.verfifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verfifyCodeButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    }
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.passwordTF) {
        
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.password = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.password = textField.text;

        }else{
            self.password = [textField.text stringByAppendingString:string];
        }
    } else if(textField == self.verifyTF){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.verifyCode = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.verifyCode = textField.text;
            
        }else{
            self.verifyCode = [textField.text stringByAppendingString:string];
            
        }
    } else if(textField == self.cellphoneTF){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.cellphone = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.cellphone = textField.text;
            
        }else{
            self.cellphone = [textField.text stringByAppendingString:string];
            
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

@end
