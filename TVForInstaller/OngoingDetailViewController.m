//
//  OngoingDetailViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/16.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OngoingDetailViewController.h"

#import "ComminUtility.h"

#import "OngoingOrder.h"

#import <ZXingObjC/ZXingObjC.h>
#import "QRCodeViewController.h"
#import "QRCodeAnimator.h"
#import "QRCodeDismissAnimator.h"

#import "NetworkingManager.h"
#import <JGProgressHUD.h>
#import "OngoingOrder.h"
#import "TotalFeeViewController.h"

typedef enum : NSUInteger {
    WECHAT,
    ALIPAY,
    CASH,
} PayType;

@interface OngoingDetailViewController ()<UITextFieldDelegate,UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UITextField *InstallFeeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *accessoriesFeeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *ServiceFeeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *FlowTextfield;

@property (nonatomic, strong) UITextField *activeTextfield;


@property (nonatomic, copy) NSString *installCost;
@property (nonatomic, copy) NSString *accessoryCost;
@property (nonatomic, copy) NSString *serviceCost;
@property (nonatomic, copy) NSString *flowCost;

//@property (nonatomic, copy) NSString *Cost;



@property (weak, nonatomic) IBOutlet UIButton *wechatPay;
@property (weak, nonatomic) IBOutlet UIButton *alipay;
@property (weak, nonatomic) IBOutlet UIButton *cashPay;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@property (nonatomic, copy) NSString * installFee;
@property (nonatomic, copy) NSString * accessoryFee;
@property (nonatomic, copy) NSString * serviceFee;
@property (nonatomic, copy) NSString * flowFee;
@property (nonatomic, assign) PayType currentPayType;

@property (nonatomic, strong) UILabel *totalFeeLabel;
@property (nonatomic, strong) UIButton *submitButton;






@end

@implementation OngoingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"订单详情" forViewController:self];
    
    if (self.OrderInfo) {
        //如果是点击支付进行中的订单入口
        [self configOngoingOrderInfo];
    }else{
        //如果是点击正在进行中的订单入口
        [self configOrderInfo];
    }
    
    //初始化微信支付
    [self initialPayType];
    [self configureTextFields];
    [self registerForKeyboardNotifications];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
//    [self.view addGestureRecognizer:tap];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
}

-(void)configureTextFields{
    self.InstallFeeTextfield.text = @"60";
    self.accessoriesFeeTextfield.text = @"120";
    
}

/**
 *  支付进行中的订单
 */
-(void)configOngoingOrderInfo{
    self.nameLabel.text = self.OrderInfo[@"name"];
    self.telphoneLabel.text =  self.OrderInfo[@"phone"];
    self.addressLabel.text =  self.OrderInfo[@"home_address"];
    self.dateLabel.text = self.OrderInfo[@"order_endtime"];
    
    if ([self.OrderInfo[@"order_type"] integerValue] == 0) {
        self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
    } else{
        self.typeImageView.image = [UIImage imageNamed:@"ui03_Broadband"];
    }
}
/**
 *  正在进行中的订单
 */
-(void)configOrderInfo{
    
    NSDictionary *order = [OngoingOrder onGoingOrder];
    
    self.nameLabel.text = order[@"name"];
    self.telphoneLabel.text =  order[@"phone"];
    self.addressLabel.text =  order[@"home_address"];
    self.dateLabel.text = order[@"order_time"];
    
    if ([order[@"order_type"] integerValue] == 0) {
        self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
    } else{
        self.typeImageView.image = [UIImage imageNamed:@"ui03_Broadband"];
    }
    
}
//
//-(void)dismissKeyboard:(id)sender{
//}

- (IBAction)clickPayType:(id)sender {
    UIButton *button = sender;
    
    if (button.tag == 0) {
        //点击微信支付
        [self.wechatPay setImage:[UIImage imageNamed:@"ui03_check_h"] forState:UIControlStateNormal];
        [self.alipay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
        [self.cashPay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
        self.currentPayType = WECHAT;


    } else if(button.tag == 1){
        //支付宝
        [self.wechatPay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
        [self.alipay setImage:[UIImage imageNamed:@"ui03_check_h"] forState:UIControlStateNormal];
        [self.cashPay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
        self.currentPayType = ALIPAY;

    } else{
        [self.wechatPay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
        [self.alipay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
        [self.cashPay setImage:[UIImage imageNamed:@"ui03_check_h"] forState:UIControlStateNormal];
        self.currentPayType = CASH;

    }
    
    
}



-(void)initialPayType{
    [self.wechatPay setImage:[UIImage imageNamed:@"ui03_check_h"] forState:UIControlStateNormal];
    [self.alipay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
    [self.cashPay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
    self.currentPayType = WECHAT;

}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)clickCreatePayOrder:(id)sender {

    
//    if ([self.moneyTextField.text isEqualToString:@""]) {
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"支付金额不可为空" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            
//        }];
//        [alert addAction:action];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }else {
//        NSDictionary *info = [OngoingOrder onGoingOrder];
//        
//        NSString *pay_type = @"0";
//        if (_iswechatPay) {
//            pay_type = @"0";
//        } else{
//            pay_type = @"1";
//        }
//        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
//        hud.textLabel.text = @"正在生成订单";
//        [hud showInView:self.view];
//        
//        
//        [NetworkingManager BeginPayForUID:info[@"uid"] byEngineerID:info[@"engineer_id"] totalFee:self.moneyTextField.text pay_type:pay_type WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if ([responseObject[@"success"] integerValue] == 1) {
//                NSString *url = responseObject[@"obj"];
//                NSError *error = nil;
//                CGImageRef qrImage = nil;
//                ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
//                ZXBitMatrix* result = [writer encode:url
//                                              format:kBarcodeFormatQRCode
//                                               width:500
//                                              height:500
//                                               error:&error];
//                if (result) {
//                    
//                    qrImage = [[ZXImage imageWithMatrix:result] cgimage];
//                    
//                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
//                    QRCodeViewController *qrcodeVC = [sb instantiateViewControllerWithIdentifier:@"QRCodeViewController"];
//                    qrcodeVC.transitioningDelegate = self;
//                    qrcodeVC.image = [UIImage imageWithCGImage:qrImage];
//                    qrcodeVC.modalTransitionStyle = UIModalPresentationOverCurrentContext;
//                    [self showDetailViewController:qrcodeVC sender:self];
//                    NSDictionary *order = [OngoingOrder onGoingOrder];
//
//                    [NetworkingManager ModifyOrderStateByID:order[@"uid"] latitude:[order[@"location"][1] doubleValue] longitude:[order[@"location"][0] doubleValue] order_state:@"3" WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        if ([responseObject[@"status"] integerValue] == 0) {
//                            //修改订单为完成未支付
//                            
//                            [OngoingOrder setExistOngoingOrder:NO];
//                            [OngoingOrder setOrder:nil];
//                            
//                            
//                        }
//                    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        
//                    }];
//                    
//                } else {
//                    
////                    NSString *errorMessage = [error localizedDescription];
//                }
//                
//                
//            }
//            [hud dismissAfterDelay:1.0];
//
//        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [hud dismissAfterDelay:1.0];
//        }];
//
//    }
//}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"QRCodeSegue"]) {
//        
//        
//        NSDictionary *info = [OngoingOrder onGoingOrder];
//        
//        NSString *pay_type = @"0";
//        if (_iswechatPay) {
//            pay_type = @"0";
//        } else{
//            pay_type = @"1";
//        }
//        
//        [NetworkingManager BeginPayForUID:info[@"uid"] byEngineerID:info[@"engineer_id"] totalFee:self.moneyTextField.text pay_type:pay_type WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if ([responseObject[@"success"] integerValue] == 1) {
//                NSString *url = responseObject[@"obj"];
//                NSError *error = nil;
//                CGImageRef qrImage = nil;
//                ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
//                ZXBitMatrix* result = [writer encode:url
//                                              format:kBarcodeFormatQRCode
//                                               width:500
//                                              height:500
//                                               error:&error];
//                if (result) {
//                    
//                    qrImage = [[ZXImage imageWithMatrix:result] cgimage];
//                    
//                    QRCodeViewController *qrcodeVC = segue.destinationViewController;
//                    qrcodeVC.transitioningDelegate = self;
//                    qrcodeVC.image = [UIImage imageWithCGImage:qrImage];
//                    qrcodeVC.modalTransitionStyle = UIModalPresentationOverCurrentContext;
//                } else {
//                    
//                    NSString *errorMessage = [error localizedDescription];
//                }
//
//                
//            }
//        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//        }];
//
//    }
//}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShown:(NSNotification*)aNotification
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
    if (!CGRectContainsPoint(aRect, self.activeTextfield.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeTextfield.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextfield = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextfield = nil;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.InstallFeeTextfield) {
        
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.installCost = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.installCost = textField.text;
            
        }else{
            self.installCost = [textField.text stringByAppendingString:string];
        }
    } else if (textField == self.accessoriesFeeTextfield){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.accessoryCost = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.accessoryCost= textField.text;
            
        }else{
            self.accessoryCost = [textField.text stringByAppendingString:string];
            
        }
    }else if (textField == self.ServiceFeeTextfield){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.serviceCost = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.serviceCost= textField.text;
            
        }else{
            self.serviceCost = [textField.text stringByAppendingString:string];
            
        }
    }else if (textField == self.FlowTextfield){
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.flowCost = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.flowCost= textField.text;
            
        }else{
            self.flowCost = [textField.text stringByAppendingString:string];
            
        }
    }
    return YES;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"TotalFeeSegue"]) {
        //
        
        TotalFeeViewController *feeVC = segue.destinationViewController;
        
        self.totalFeeLabel = feeVC.totalFeeLabel;
        self.submitButton = feeVC.submitButton;
        
    }
}


#pragma mark - ViewController Transition Delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[QRCodeAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[QRCodeDismissAnimator alloc] init];

}


@end
