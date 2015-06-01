//
//  RegisterViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "RegisterViewController.h"
#import "ComminUtility.h"
#import "NetworkingManager.h"
#import <JGProgressHUD.h>
#import "NSString+Hashes.h"
#import "AccountManager.h"

typedef void(^alertBlock)(void);

@interface RegisterViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *cellphoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *inviteTextField;
@property (weak, nonatomic) IBOutlet UITextField *ChinaIdentifyTextfield;
@property (weak, nonatomic) IBOutlet UITextField *identityCodeTextFIeld;


@property (weak, nonatomic) IBOutlet UIButton *getIdentitycodeButton;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) UITextField *activeField;
@property (nonatomic,copy)NSString * cellphoneNumber;
@property (nonatomic,copy)NSString * password;
@property (nonatomic,copy)NSString * verifycode;
@property (nonatomic,copy)NSString * chinaID;
@property (nonatomic,copy)NSString * inviteCode;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSUInteger count;
@property (nonatomic,strong) JGProgressHUD *hud;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"注册" forViewController:self];
    
    [self configureTextFields];
    [self registerForKeyboardNotifications];
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{

    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64, 0, 0, 0);

    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.cellphoneTextfield) {
        
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.cellphoneNumber = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.cellphoneNumber= textField.text;
            
        }else{
            self.cellphoneNumber = [textField.text stringByAppendingString:string];
        }
    } else if (textField == self.confirmPassword){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.password = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.password= textField.text;
            
        }else{
            self.password = [textField.text stringByAppendingString:string];
            
        }
    }else if (textField == self.inviteTextField){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.inviteCode = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.inviteCode= textField.text;
            
        }else{
            self.inviteCode = [textField.text stringByAppendingString:string];
            
        }
    }else if (textField == self.ChinaIdentifyTextfield){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.chinaID = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.chinaID= textField.text;
            
        }else{
            self.chinaID = [textField.text stringByAppendingString:string];
            
        }
    }else if (textField == self.identityCodeTextFIeld){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.verifycode = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.verifycode= textField.text;
            
        }else{
            self.verifycode = [textField.text stringByAppendingString:string];
            
        }
    }

    return YES;
}




-(void)configureTextFields{
    
    self.cellphoneTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.confirmPassword.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"确认密码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.inviteTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"邀请码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.ChinaIdentifyTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"身份证" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    self.identityCodeTextFIeld.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
}


-(void)pop{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)count:(id)sender{
    self.count--;
    
    if (self.count > 0) {
        
        [self getcode:NO];
    } else{
        [self getcode:YES];
    }
}

- (IBAction)getVerifyCode:(id)sender {
    
    self.count = 60;
    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    self.hud.textLabel.text = @"获取验证码";
    [self.hud showInView:self.view];

    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(count:) userInfo:nil repeats:YES];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        hud.textLabel.text = @"验证码获取成功";
//        hud.indicatorView = nil;
//        [hud dismissAfterDelay:1.0];
//        
//        [self getcode:YES];
//        
//    });
//
    
    if (self.cellphoneNumber != nil&&
        ![self.cellphoneNumber isEqualToString:@""]) {
        
        [NetworkingManager fetchRegisterVerifyCode:self.cellphoneNumber withComletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 0) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   
                    self.hud.textLabel.text =responseObject[@"msg"];
                    self.hud.indicatorView = nil;
                    [self.hud dismissAfterDelay:2.0];
                });
               
            }else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.hud.textLabel.text = @"验证码获取成功";
                    self.hud.indicatorView = nil;
                    [self.hud dismissAfterDelay:2.0];

                });
                
            }
            
            
            
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.hud dismissAnimated:YES];
            
        }];
    }
    
    
}

/**
 *  获取验证码成功
 *
 *  @param isSuccess 是否成功
 */
-(void)getcode:(BOOL)isSuccess{
    if (isSuccess) {
        [self.timer invalidate];
        [self.getIdentitycodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getIdentitycodeButton.userInteractionEnabled = YES;

    } else{
        [self.getIdentitycodeButton setTitle:[NSString stringWithFormat:@"%ld s",self.count] forState:UIControlStateNormal];
        self.getIdentitycodeButton.userInteractionEnabled = NO;

    }
}



/**
 *  检查注册信息是否完整
 *
 *  @return    none
 */
-(BOOL)checkRegisterInfoCompletion{
    
    if (![ComminUtility checkTel:self.cellphoneNumber]) {
        [self alertWithMessage:@"手机号码不合法" withCompletionHandler:^{
        }];
        return NO;
    }

    if (![ComminUtility checkPassword:self.passwordTextField.text]) {
        [self alertWithMessage:@"密码为4~16为数字字母组合" withCompletionHandler:^{
            
        }];
        return NO;
    }
    
    if (![ComminUtility checkPassword:self.confirmPassword.text]) {
        [self alertWithMessage:@"确认密码为4~16为数字字母组合" withCompletionHandler:^{
            
        }];
        return NO;
    }

    
    if (![self.confirmPassword.text isEqualToString:self.password]||
        self.password == nil) {
        [self alertWithMessage:@"二次密码输入不一致" withCompletionHandler:^{
            
        }];
        return NO;
        
    }
    if ([self.inviteCode isEqualToString:@""]||
        self.inviteCode == nil) {
        [self alertWithMessage:@"邀请码不能为空" withCompletionHandler:^(){}];
        return NO;

    }
    
    if ([self.verifycode isEqualToString:@""]||
        self.verifycode == nil) {
        [self alertWithMessage:@"验证码不能为空" withCompletionHandler:^{
            
        }];
        return NO;
    }
    
    if (![ComminUtility validateIdentityCard:self.chinaID]||
        self.chinaID == nil) {
        [self alertWithMessage:@"身份证号不合法" withCompletionHandler:^{

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

/**
 *  注册
 *
 *  @param sender
 */
- (IBAction)submitForRegister:(id)sender {
    
    if ([self checkRegisterInfoCompletion]) {
        self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        self.hud.textLabel.text =@"注册中";
        [self.hud showInView:self.view];
        [NetworkingManager registerCellphone:self.cellphoneNumber password:[self.password sha1] inviteCode:self.inviteCode chinaID:self.chinaID verifyCode:self.verifycode withCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 0) {
                //error
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.hud.textLabel.text =responseObject[@"msg"];
                    self.hud.indicatorView = nil;
                    
                    [self.hud dismissAfterDelay:2.0];
                });
              
                
            } else{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.hud.textLabel.text =@"注册成功";
                    self.hud.indicatorView = nil;
                    [self.hud dismissAfterDelay:2.0];
                    NSDictionary *data = responseObject[@"obj"];
                    
                    [self dealRegister:data];
                });
            }
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.hud dismiss];
        }];
    }
}


-(void)dealRegister:(NSDictionary*)data{
    if (![data[@"name"] isKindOfClass:[NSNull class]]) {
        [AccountManager setName:data[@"name"]];
    }
    if (![data[@"headimg"] isKindOfClass:[NSNull class]]) {
        [AccountManager setAvatarUrlString:data[@"headimg"]];
    }
    if (![data[@"idcard"] isKindOfClass:[NSNull class]]) {
        [AccountManager setIDCard:data[@"idcard"]];
    }
    if (![data[@"leaderid"] isKindOfClass:[NSNull class]]) {
        [AccountManager setLeaderID:data[@"leaderid"]];
    }
    
    if (![data[@"phone"] isKindOfClass:[NSNull class]]) {
        [AccountManager setCellphoneNumber:data[@"phone"]];
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

-(void)dealloc{
    [self.timer invalidate];
    self.timer=  nil;
    
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
