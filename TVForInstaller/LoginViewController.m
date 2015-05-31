//
//  LoginViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "LoginViewController.h"
#import "ComminUtility.h"
#import "NetworkingManager.h"
#import "NSString+Hashes.h"
#import "AccountManager.h"

#import <JGProgressHUD.h>

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *CellularTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) JGProgressHUD *HUD;

@property (nonatomic,copy) NSString *Account;
@property (nonatomic,copy) NSString *password;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:recognizer];
    
    [ComminUtility configureTitle:@"电视极客" forViewController:self];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.CellularTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

-(void)dismissKeyboard:(id)sender{
    
    [self.CellularTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.CellularTextField) {
        
        
        if ([string isEqualToString:@""]) {
            self.Account = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.Account = textField.text;
            
        }else{
            self.Account = [textField.text stringByAppendingString:string];
        }
    } else{
        
        if ([string isEqualToString:@""]) {
            self.password = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.password = textField.text;
            
        }else{
            self.password = [textField.text stringByAppendingString:string];
            
        }
    }
    return YES;
}

- (IBAction)Login:(id)sender {
    //TODO:
    
    
    if ([self checkTextFieldCompletion]) {
        
        [self.CellularTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];

        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        self.HUD.textLabel.text= @"登录中";
        [self.HUD showInView:self.view animated:YES];

        [NetworkingManager login:self.Account withPassword:[self.password sha1] withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {

            
            if ([responseObject[@"success"] integerValue] == 0) {
                //error
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.HUD.indicatorView = nil;
                    self.HUD.textLabel.text =@"用户名或密码错误";
                    
                    [self.HUD dismissAfterDelay:2.0];
                });
               
                
            } else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.HUD.textLabel.text =@"登录成功";
                    self.HUD.indicatorView = nil;
                    [self.HUD dismissAfterDelay:2.0];
                    [self dealLoginMessages:(NSDictionary*)responseObject];
                });
                

            }
            
        } FailHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.HUD dismiss];

        }];
    }
    
    
}

-(void)dealLoginMessages:(NSDictionary*)responseObject{
    
    //TODO: 登录成功处理数据
    
    NSDictionary *data = responseObject[@"obj"];
    NSLog(@"返回的数据: %@",data);
    
    if (![data[@"name"] isKindOfClass:[NSNull class]]) {
        [AccountManager setName:data[@"name"]];
    }
    if (![data[@"phone"] isKindOfClass:[NSNull class]]) {
        [AccountManager setCellphoneNumber:data[@"phone"]];
    }
    if (![data[@"leaderid"] isKindOfClass:[NSNull class]]) {
        [AccountManager setLeaderID:data[@"leaderid"]];
    }
    if (![data[@"headimg"] isKindOfClass:[NSNull class]]) {
        [AccountManager setAvatarUrlString:data[@"headimg"]];
    }
    if (![data[@"idcard"] isKindOfClass:[NSNull class]]) {
        [AccountManager setIDCard:data[@"idcard"]];
    }
    if (![data[@"score"] isKindOfClass:[NSNull class]]) {
        [AccountManager setScore:[data[@"score"] integerValue]];
    }
    if (![data[@"id"] isKindOfClass:[NSNull class]]) {
        [AccountManager setTokenID:data[@"id"]];
    }
    if (![data[@"address"] isKindOfClass:[NSNull class]]) {
        [AccountManager setAddress:data[@"address"]];
    }
    
    if (![data[@"gender"] isKindOfClass:[NSNull class]]) {
        [AccountManager setgender:[data[@"gender"] integerValue]];
    }
    
    [AccountManager setPassword:self.password];
    [AccountManager setLogin:YES];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)checkTextFieldCompletion{
    
    if ([self.Account isEqual: @""]|| self.Account == nil
        ) {
        [self alertWithMessage:@"手机号不能为空" withCompletionHandler:^{
            self.CellularTextField.text = nil;
            [self.CellularTextField becomeFirstResponder];

        }];
        
        return NO;
    }
    
    if (![ComminUtility checkTel:self.Account]
        ) {
        [self alertWithMessage:@"手机号不合法" withCompletionHandler:^{
            self.CellularTextField.text = nil;
            [self.CellularTextField becomeFirstResponder];
            
        }];
        
        return NO;
    }
    
    if ([self.password isEqualToString:@""] || self.password == nil){

        [self alertWithMessage:@"密码不能为空" withCompletionHandler:^{
            self.passwordTextField.text = nil;
            [self.passwordTextField becomeFirstResponder];
            
        }];
        return NO;

    }
    
    return YES;
}

-(void)alertWithMessage:(NSString*)message withCompletionHandler:(alertBlock)handler{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        handler();
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
