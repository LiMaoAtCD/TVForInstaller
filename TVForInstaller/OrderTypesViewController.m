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

#import "WXApi.h"
#import "WXUtil.h"

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
        
        
    } else if(_type == CASH_WECHAT){
        [SVProgressHUD show];
        [NetworkingManager FetchLocalCashPay:self.orderID WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"responseObject : %@",responseObject);
            
            if ([responseObject[@"success"] integerValue] == 1) {
                NSDictionary *dic = responseObject[@"data"];
                
                if ([dic[@"return_code"] isEqualToString:@"FAIL"]) {
                    [SVProgressHUD showErrorWithStatus:dic[@"return_msg"]];
                } else{
                    
                    [SVProgressHUD dismiss];
                    
                    NSString *pid = dic[@"prepay_id"];
                    
                    NSDictionary *paydemoDic = [self sendPay_demo:pid];
                    
                    if (paydemoDic) {
                        
                        NSString *stamp = paydemoDic[@"timestamp"];
                        
                        //调起微信支付
                        PayReq* req             = [[PayReq alloc] init];
                        req.openID              = paydemoDic[@"appid"];
                        req.partnerId           = [paydemoDic objectForKey:@"partnerid"];
                        req.prepayId            = [paydemoDic objectForKey:@"prepayid"];
                        req.nonceStr            = [paydemoDic objectForKey:@"noncestr"];
                        req.timeStamp           = stamp.intValue;
                        req.package             = [paydemoDic objectForKey:@"package"];
                        req.sign                = [paydemoDic objectForKey:@"sign"];
                        
                        [WXApi sendReq:req];
                    }
                }
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

#pragma mark - 微信支付相关

- ( NSMutableDictionary *)sendPay_demo:(NSString *)prePayid
{
    if ( prePayid != nil) {
        //获取到prepayid后进行第二次签名
        NSString    *package, *time_stamp, *nonce_str;
        //设置支付参数
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        nonce_str	= [WXUtil md5:time_stamp];
        //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
        //package       = [NSString stringWithFormat:@"Sign=%@",package];
        package         = @"Sign=WXPay";
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: @"wxd5cf5a03a579d6cb"        forKey:@"appid"];
        [signParams setObject: nonce_str    forKey:@"noncestr"];
        [signParams setObject: package      forKey:@"package"];
        [signParams setObject: @"1274446101"        forKey:@"partnerid"];
        [signParams setObject: time_stamp   forKey:@"timestamp"];
        [signParams setObject: prePayid     forKey:@"prepayid"];
        //[signParams setObject: @"MD5"       forKey:@"signType"];
        //生成签名
        NSString *sign  = [self createMd5Sign:signParams];
        //添加签名
        [signParams setObject: sign         forKey:@"sign"];
        //[debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
        //返回参数列表
        return signParams;
        
    }else{
        //[debugInfo appendFormat:@"获取prepayid失败！\n"];
    }
    return nil;
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=8a8080954cab7828014cab9c8ef60010"];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    //[debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}

-(void)paySuccess{
    [SVProgressHUD show];
    [NetworkingManager checkOrderPayedSuccessfullyByOrderID:self.orderID WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger data = [responseObject[@"data"] integerValue];
        if (data > 0) {
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            [SVProgressHUD showSuccessWithStatus:@"支付失败"];
        }
    } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络出错"];
    }];
}

@end
