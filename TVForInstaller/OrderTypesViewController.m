//
//  OrderTypesViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/24.
//  Copyright © 2015年 AlienLi. All rights reserved.
//



#import "OrderTypesViewController.h"
#import "ComminUtility.h"
#import "OrderPayTypeSelectionController.h"

#import <Masonry.h>
#import "NetworkingManager.h"
#import <SVProgressHUD.h>
#import "PayType.h"

@interface OrderTypesViewController ()<DetailPayTypeDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *PayButtons;


@property (assign, nonatomic) PAY_TYPE type;

@property (assign, nonatomic) NSInteger selectedTag;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView2;

@end

@implementation OrderTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"订单支付" forViewController:self];
    self.type = NONE;
}

-(void)pop{
    
    if (_isFromCompletionList) {
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (IBAction)clickType:(id)sender {
    
    UIButton *btn = sender;
    _selectedTag = btn.tag;

    switch (btn.tag) {
        case 0:
        {
            [self.PayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button  = obj;
                if (button.tag == 0) {
                    [button setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
                } else{
                [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
                }
                
            }];
            
            self.type = APP;
        }
            break;
        case 1:
        {
            [self.PayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button  = obj;
                if (button.tag == 1) {
                    [button setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
                } else{
                    [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
                }
                
            }];
            

            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            OrderPayTypeSelectionController * detail = [sb instantiateViewControllerWithIdentifier:@"OrderPayTypeSelectionController"];
            detail.delegate = self;
            detail.modalPresentationStyle = UIModalPresentationOverCurrentContext;

            
            [self showDetailViewController:detail sender:self];
            
        }
            break;
        case 2:
        {
            [self.PayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button  = obj;
                if (button.tag == 2) {
                    [button setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
                } else{
                    [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
                }
            }];
            
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            OrderPayTypeSelectionController * detail = [sb instantiateViewControllerWithIdentifier:@"OrderPayTypeSelectionController"];
            detail.delegate = self;
            detail.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            
            [self showDetailViewController:detail sender:self];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)didSelectedPayType:(DetailPayType)type{
    
    switch (_selectedTag) {
        case 1:
        {
            if (type == WECHAT) {
                
                self.typeImageView.image = [UIImage imageNamed:@"ui03_wechat"];
                self.typeImageView2.image = nil;
                self.type = SCAN_WECHAT;
                
            } else if (type == ALIPay){
                self.typeImageView.image = [UIImage imageNamed:@"ui03_alipay"];
                self.typeImageView2.image = nil;
                self.type = SCAN_ALIPAY;

            } else{
                self.typeImageView.image = nil;
                self.typeImageView2.image = nil;
                
                self.type = NONE;
                [self.PayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIButton *button  = obj;
                    [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
                }];
            }
        }
            break;
        case 2:
        {
            if (type == WECHAT) {
                
                self.typeImageView2.image = [UIImage imageNamed:@"ui03_wechat"];
                self.typeImageView.image = nil;
                self.type = CASH_WECHAT;
                
            } else if (type == ALIPay){
                self.typeImageView2.image = [UIImage imageNamed:@"ui03_alipay"];
                self.typeImageView.image = nil;
                self.type = CASH_ALIPAY;
                
            } else{
                self.typeImageView.image = nil;
                self.typeImageView2.image = nil;
                
                self.type = NONE;
                [self.PayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIButton *button  = obj;
                    [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
                }];
                
            }
        }
            break;
    }
}

- (IBAction)confirmPay:(id)sender {
    
    if (_type == APP) {
        [SVProgressHUD show];
        [NetworkingManager uploadOrderInfoToAPPByOrderID:self.orderID WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_isFromCompletionList) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
            } else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
            
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }];
    } else if(_type == SCAN_WECHAT){
        [SVProgressHUD show];
        [NetworkingManager scanQRCodeWeXin:self.orderID WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"success"] integerValue] == 1) {
                [SVProgressHUD showSuccessWithStatus:@"发送成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_isFromCompletionList) {
                        [self.navigationController popViewControllerAnimated:YES];
                    } else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                
            }
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];

        }];
        
        
          }
    
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
