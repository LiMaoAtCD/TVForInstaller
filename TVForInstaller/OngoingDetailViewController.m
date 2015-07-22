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

@interface OngoingDetailViewController ()<UITextFieldDelegate,UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *wechatPay;
@property (weak, nonatomic) IBOutlet UIButton *alipay;

@property (nonatomic, assign) BOOL iswechatPay;
@end

@implementation OngoingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"订单详情" forViewController:self];
    [self configOrderInfo];
    [self initialPayType];
    self.moneyTextField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard:(id)sender{
    [self.moneyTextField resignFirstResponder];
}

- (IBAction)clickPayType:(id)sender {
    UIButton *button = sender;
    
    if (button.tag == 0) {
        [self.wechatPay setImage:[UIImage imageNamed:@"ui03_WeChat-Payment_h"] forState:UIControlStateNormal];
        [self.alipay setImage:[UIImage imageNamed:@"ui03_-Alipay-Payment"] forState:UIControlStateNormal];
        _iswechatPay = YES;
    } else{
        [self.wechatPay setImage:[UIImage imageNamed:@"ui03_WeChat-Payment"] forState:UIControlStateNormal];
        [self.alipay setImage:[UIImage imageNamed:@"ui03_-Alipay-Payment_h"] forState:UIControlStateNormal];
        _iswechatPay = NO;

    }
}

-(void)configOrderInfo{
    
    NSDictionary *order = [OngoingOrder onGoingOrder];
    
    self.nameLabel.text = order[@"name"];
    self.telphoneLabel.text =  order[@"phone"];
    self.addressLabel.text =  order[@"home_address"];
    self.runningLabel.text = order[@"order_id"];
    self.dateLabel.text = order[@"order_time"];

    if ([order[@"order_type"] integerValue] == 0) {
        self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
    } else{
        self.typeImageView.image = [UIImage imageNamed:@"ui03_Broadband"];
    }

}

-(void)initialPayType{
    [self.wechatPay setImage:[UIImage imageNamed:@"ui03_WeChat-Payment_h"] forState:UIControlStateNormal];
    [self.alipay setImage:[UIImage imageNamed:@"ui03_-Alipay-Payment"] forState:UIControlStateNormal];
    _iswechatPay = YES;

}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([self.moneyTextField.text isEqualToString:@""] && [identifier isEqualToString:@"QRCodeSegue"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"支付金额不可为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    } else{
        return YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"QRCodeSegue"]) {
        
        
        NSDictionary *info = [OngoingOrder onGoingOrder];
    [NetworkingManager BeginPayForUID:info[@"uid"] byEngineerID:info[@"engineer_id"] totalFee:self.moneyTextField.text WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
        
        
        NSError *error = nil;
        CGImageRef qrImage = nil;
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:@"A string to encode"
                                      format:kBarcodeFormatQRCode
                                       width:500
                                      height:500
                                       error:&error];
        if (result) {
            
            qrImage = [[ZXImage imageWithMatrix:result] cgimage];
            
            // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
            
            
        } else {
            
            NSString *errorMessage = [error localizedDescription];
        }
        

        QRCodeViewController *qrcodeVC = segue.destinationViewController;
        qrcodeVC.transitioningDelegate = self;
        qrcodeVC.image = [UIImage imageWithCGImage:qrImage];
        
        
        
        
        qrcodeVC.modalTransitionStyle = UIModalPresentationOverCurrentContext;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImageWriteToSavedPhotosAlbum(qrcodeVC.image, nil, nil, nil);
        });
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[QRCodeAnimator alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[QRCodeDismissAnimator alloc] init];

}


@end
