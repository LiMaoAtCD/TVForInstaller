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

#import <SVProgressHUD.h>

#import "OngoingOrder.h"

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
    
    [ComminUtility configureTitle:@"极客快服" forViewController:self];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.CellularTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    
    self.CellularTextField.text = [AccountManager getCellphoneNumber];
    self.passwordTextField.text = [AccountManager getPassword];
    self.Account = [AccountManager getCellphoneNumber];
    self.password = [AccountManager getPassword];

    
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
        
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.Account = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.Account = textField.text;
        }else{
            NSMutableString *temp = [textField.text mutableCopy];
            [temp insertString:string atIndex:range.location];
            self.Account = temp;
        }
    } else{
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.password = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            self.password = textField.text;
            
        }else{
            NSMutableString *temp = [textField.text mutableCopy];
            [temp insertString:string atIndex:range.location];
            self.password = temp;
//            self.password = [textField.text stringByAppendingString:string];
            
        }
    }
    return YES;
}

- (IBAction)Login:(id)sender {
    //TODO:
    
    
    if ([self checkTextFieldCompletion]) {
        
        [self.CellularTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];

        [SVProgressHUD showWithStatus:@"正在登录"];

        [NetworkingManager login:self.Account withPassword:[self.password sha1] withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {

            
            if ([responseObject[@"success"] integerValue] == 0) {
                //error
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                    
                    self.passwordTextField.text = @"";
                    self.password = @"";
                });
               
                
            } else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    [self dealLoginMessages:(NSDictionary*)responseObject];
                });
                

            }
            
        } FailHandler:^(AFHTTPRequestOperation *operation, NSError *error) {

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
    if (![data[@"rank"] isKindOfClass:[NSNull class]]) {
        [AccountManager setRank:[data[@"rank"] integerValue]];
    }
    
    [AccountManager setPassword:self.password];
    [AccountManager setLogin:YES];
    
    [self fetchOngoingOrder];
    
   
}


-(void)fetchOngoingOrder{
    //检查是否是登录状态,没有登录就不检查是否有正在执行订单
    if ([AccountManager isLogin]) {
        
        [NetworkingManager FetchOngongOrderWithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"status"] integerValue] == 0) {
                
                NSArray *pois =responseObject[@"pois"];
                //如果获取到有正在执行的订单
                if (!pois  && pois.count > 0) {
                    NSMutableDictionary *temp = [pois[0] mutableCopy];
                    if (temp[@"id"]) {
                        temp[@"uid"] = temp[@"id"];
                    }
                    //添加执行中的订单
                    
                    [OngoingOrder setOrder:temp];
                    [OngoingOrder setExistOngoingOrder:YES];
                }else {
                }
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
            }
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    
}

-(BOOL)checkTextFieldCompletion{
    
    if ([self.Account isEqual: @""]|| self.Account == nil
        ) {
        [self alertWithMessage:@"手机号不能为空" withCompletionHandler:^{
            self.CellularTextField.text = nil;
            self.Account = @"";
            [self.CellularTextField becomeFirstResponder];

        }];
        
        return NO;
    }
    
    if (![ComminUtility checkTel:self.Account]
        ) {
        [self alertWithMessage:@"手机号不合法" withCompletionHandler:^{
            self.CellularTextField.text = nil;
            self.Account = @"";
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
        if (handler) {
            handler();
        }
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
