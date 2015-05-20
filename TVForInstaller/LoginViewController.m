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

#import <JGProgressHUD.h>

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *CellularTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic,copy) NSString *Account;
@property (nonatomic,copy) NSString *password;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:recognizer];
    
    [ComminUtility configureTitle:@"电视管家" forViewController:self];
    
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
        }else{
            self.Account = [textField.text stringByAppendingString:string];
        }
    } else{
        
        if ([string isEqualToString:@""]) {
            self.password = [textField.text substringToIndex:[textField.text length] - 1];
        }else{
            self.password = [textField.text stringByAppendingString:string];
            
        }
    }
    return YES;
}

- (IBAction)Login:(id)sender {
    //TODO:
    
    
    if ([self checkTextFieldCompletion]) {
        
        JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        HUD.textLabel.text= @"登录中...";
        [HUD showInView:self.view animated:YES];
        [HUD dismissAfterDelay:2];

        
        
//        [NetworkingManager login:self.Account withPassword:[self.password sha1] withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//            [HUD dismiss];
//        }];
    }
    
    
}
-(BOOL)checkTextFieldCompletion{
    
    if ([self.Account isEqual: @""]|| self.Account == nil
        ) {
        [self alertWithMessage:@"账号不能为空" withCompletionHandler:^{
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
