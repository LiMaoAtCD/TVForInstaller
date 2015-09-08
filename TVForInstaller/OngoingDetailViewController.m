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
#import <SVProgressHUD.h>
#import "OngoingOrder.h"
#import "TotalFeeViewController.h"

#import "QRDecodeViewController.h"


@interface OngoingDetailViewController ()<UITextFieldDelegate,UIViewControllerTransitioningDelegate,SubmitDelegate,QRCodeCompletedDelegate>

//这里是订单信息视图
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//输入框
@property (weak, nonatomic) IBOutlet UITextField *InstallFeeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *accessoriesFeeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *ServiceFeeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *FlowTextfield;
//当前活跃的输入框
@property (nonatomic, strong) UITextField *activeTextfield;

//各种费用
@property (nonatomic, assign) float installCost;
@property (nonatomic, assign) float accessoryCost;
@property (nonatomic, assign) float serviceCost;
@property (nonatomic, assign) float flowCost;

//汇总费用
@property (nonatomic, assign) float totalCost;

//扫码结果
@property (nonatomic,copy) NSString * qrcode;

//微信&支付宝&现金按钮
@property (weak, nonatomic) IBOutlet UIButton *wechatPay;
@property (weak, nonatomic) IBOutlet UIButton *alipay;
@property (weak, nonatomic) IBOutlet UIButton *cashPay;
//支付类型
@property (nonatomic, assign) PayType currentPayType;


//滑动视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) TotalFeeViewController *totalFeeVC;


@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@end

@implementation OngoingDetailViewController


#pragma mark - 视图生命周期
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
    
    [self registerForKeyboardNotifications];
    
    
    //添加关闭键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    
    
    [self.InstallFeeTextfield addTarget:self action:@selector(textfieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.accessoriesFeeTextfield addTarget:self action:@selector(textfieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.ServiceFeeTextfield addTarget:self action:@selector(textfieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.FlowTextfield addTarget:self action:@selector(textfieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.scanLabel.hidden = YES;
    [self.scanButton addTarget:self action:@selector(scanQRCode:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self configureTextFields];

}




-(void)configureTextFields{
    self.InstallFeeTextfield.text = @"60";
    self.InstallFeeTextfield.placeholder = @"请输入金额";
    self.accessoriesFeeTextfield.text = @"120";
    self.accessoriesFeeTextfield.placeholder = @"请输入金额";

    self.installCost = 60.0;
    self.accessoryCost = 120.0;
    self.serviceCost = 0.0;
    self.flowCost = 0.0;
    [self caculateTotalCost];

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
    
    self.OrderInfo = order;
    self.nameLabel.text = order[@"name"];
    self.telphoneLabel.text =  order[@"phone"];
    self.addressLabel.text =  order[@"homeAddress"];
    self.dateLabel.text = order[@"orderTime"];
    
    if ([order[@"orderType"] integerValue] == 0) {
        self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
    } else{
        self.typeImageView.image = [UIImage imageNamed:@"ui03_Broadband"];
    }
    
}

-(void)dismissKeyboard:(id)sender{
    [self.InstallFeeTextfield resignFirstResponder];
    [self.accessoriesFeeTextfield resignFirstResponder];
    [self.ServiceFeeTextfield resignFirstResponder];
    [self.FlowTextfield resignFirstResponder];
}

#pragma mark - 费用输入修改
-(void)textfieldDidChanged:(UITextField *)textField{
    if (textField == self.InstallFeeTextfield) {
        self.installCost = [self.InstallFeeTextfield.text  floatValue];
    }
    if (textField == self.accessoriesFeeTextfield) {
        self.accessoryCost = [self.accessoriesFeeTextfield.text floatValue];
    }
    if (textField == self.ServiceFeeTextfield) {
        self.serviceCost = [self.ServiceFeeTextfield.text floatValue];
    }
    if (textField == self.FlowTextfield) {
        self.flowCost = [self.FlowTextfield.text floatValue];
    }
    
    //修改完成，计算费用
    [self caculateTotalCost];
}
-(void)initialPayType{
    [self.wechatPay setImage:[UIImage imageNamed:@"ui03_check_h"] forState:UIControlStateNormal];
    [self.alipay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
    [self.cashPay setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
    self.currentPayType = WECHAT;
    
}
- (IBAction)clickPayType:(id)sender {
    UIButton *button = sender;
    
    if (button.tag == 0) {
        //点击微信支付
        [self initialPayType];

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
    
    [self caculateTotalCost];

}

-(void)caculateTotalCost{
    self.totalCost = self.installCost + self.accessoryCost + self.serviceCost + self.flowCost;
    if (self.currentPayType != CASH) {
        
        if (self.totalCost > 20.0) {
            self.totalCost -= 20.0;
        }
    }
    
    //ok
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.totalFeeVC.totalFeeLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalCost];
    });
    
}




-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击支付
-(void)didClickSubmitButton{
    
    if (self.currentPayType == WECHAT) {
        //发起微信支付
        [SVProgressHUD show];

        [NetworkingManager BeginWeChatPayForUID:self.OrderInfo[@"uid"] totalFee:[NSString stringWithFormat:@"%f",self.totalCost] tvid:self.qrcode WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 1) {

                NSString *url = responseObject[@"obj"];
                if ([url isKindOfClass:[NSNull class]]||!url || [url isEqualToString:@""]) {
                    [SVProgressHUD showErrorWithStatus:@"二维码生成失败"];
                    return;
                }
                [SVProgressHUD dismiss];

                NSError *error = nil;
                CGImageRef qrImage = nil;
                ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
                ZXBitMatrix* result = [writer encode:url
                                              format:kBarcodeFormatQRCode
                                               width:500
                                              height:500
                                               error:&error];
                if (result) {
            
                    qrImage = [[ZXImage imageWithMatrix:result] cgimage];
            
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                    QRCodeViewController *qrcodeVC = [sb instantiateViewControllerWithIdentifier:@"QRCodeViewController"];
                    qrcodeVC.transitioningDelegate = self;
                    qrcodeVC.delegate = self;
                    qrcodeVC.type = WECHAT;

                    qrcodeVC.image = [UIImage imageWithCGImage:qrImage];
                    qrcodeVC.modalTransitionStyle = UIModalPresentationOverCurrentContext;
                    [self showDetailViewController:qrcodeVC sender:self];
                    
                    
//                    NSDictionary *order = [OngoingOrder onGoingOrder];
                    [OngoingOrder setExistOngoingOrder:NO];
                    [OngoingOrder setOrder:nil];

                    
                } else {
                    
                }
                
            } else{
                //未成功
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }];
        
        
     } else if (self.currentPayType == ALIPAY){
         //支付宝
         
         //发起支付
         [SVProgressHUD show];
         
         [NetworkingManager BeginAliPayForUID:self.OrderInfo[@"uid"] totalFee:[NSString stringWithFormat:@"%.2f",self.totalCost] tvid:self.qrcode WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([responseObject[@"success"] integerValue] == 1) {
                 
                 NSString *url = responseObject[@"obj"];
                 
                 if ([url isKindOfClass:[NSNull class]]||!url || [url isEqualToString:@""]) {
                     [SVProgressHUD showErrorWithStatus:@"二维码生成失败"];
                 } else{
                     [SVProgressHUD dismiss];

                     
                     NSError *error = nil;
                     CGImageRef qrImage = nil;
                     ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
                     ZXBitMatrix* result = [writer encode:url
                                                   format:kBarcodeFormatQRCode
                                                    width:500
                                                   height:500
                                                    error:&error];
                     if (result) {
                         
                         qrImage = [[ZXImage imageWithMatrix:result] cgimage];
                         
                         UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                         QRCodeViewController *qrcodeVC = [sb instantiateViewControllerWithIdentifier:@"QRCodeViewController"];
                         qrcodeVC.transitioningDelegate = self;
                         qrcodeVC.delegate = self;
                         qrcodeVC.type = ALIPAY;

                         qrcodeVC.image = [UIImage imageWithCGImage:qrImage];
                         qrcodeVC.modalTransitionStyle = UIModalPresentationOverCurrentContext;
                         [self showDetailViewController:qrcodeVC sender:self];
                         
                         [OngoingOrder setExistOngoingOrder:NO];
                         [OngoingOrder setOrder:nil];

                     }
                 }

                 
                 
             } else{
                 //未成功
                 [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
             }
         } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"网络出错"];
         }];

     } else{
         //现金
         //发起支付
         [SVProgressHUD showWithStatus:@"正在提交支付结果"];
         
         [NetworkingManager BeginCashPayForUID:self.OrderInfo[@"uid"] totalFee:[NSString stringWithFormat:@"%f",self.totalCost] tvid:self.qrcode WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             if ([responseObject[@"success"] integerValue] == 1) {
                 
                 [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popToRootViewControllerAnimated:YES];
                     
                     [OngoingOrder setExistOngoingOrder:NO];
                     [OngoingOrder setOrder:nil];
                 });
             } else{
                 //未成功
                 [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
             }
         } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"网络出错"];
         }];

         
    }

}
#pragma mark -keyboard deal
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

#pragma mark -segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"TotalFeeSegue"]) {
        //
        self.totalFeeVC = (TotalFeeViewController*)segue.destinationViewController;
        self.totalFeeVC.delegate = self;
    }
}


#pragma mark - ViewController Transition Delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[QRCodeAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[QRCodeDismissAnimator alloc] init];

}


#pragma mark - scan qrcode

-(void)scanQRCode:(UIButton *)button{
    QRDecodeViewController *qrcode = [[QRDecodeViewController alloc] init];
    
    [self showDetailViewController:qrcode sender:self];
    //    [self presentViewController:qrcode animated:YES completion:^{
    //        self.navigationController.tabBarController.view.frame = CGRectMake(0, 0, self.navigationController.tabBarController.view.frame.size.width, self.navigationController.tabBarController.view.frame.size.height);
    //    }];
    
    __weak OngoingDetailViewController *weakSelf = self;
    
    qrcode.qrUrlBlock = ^(NSString * code) {
        
//        [weakSelf postNewRemoteTV:code];
        self.qrcode = code;
        weakSelf.scanLabel.text = code;
        weakSelf.scanLabel.hidden = NO;
        weakSelf.scanButton.hidden = YES;
    };
}

#pragma mark -关闭二维码

-(void)didClickCloseQRCode{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
