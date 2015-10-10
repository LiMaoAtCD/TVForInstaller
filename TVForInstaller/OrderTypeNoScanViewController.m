//
//  OrderTypeNoScanViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/28.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "OrderTypeNoScanViewController.h"
#import "ComminUtility.h"
#import "NetworkingManager.h"
#import "OrderPayTypeSelectionController.h"
#import "PayType.h"

#import "NetworkingManager.h"
#import <SVProgressHUD.h>
#import "WXUtil.h"
#import "WXApi.h"

@interface OrderTypeNoScanViewController ()<DetailPayTypeDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectionButtons;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (nonatomic, assign) PAY_TYPE type;


@end

@implementation OrderTypeNoScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [ComminUtility configureTitle:@"订单支付" forViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"checkWXPayIsSuccessed" object:nil];
    self.type = NONE;

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)pop{
    
    if (_isFromCompletionList) {
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choose:(id)sender {
    
    UIButton *btn = sender;
    
    if (btn.tag == 0) {
        self.type = APP;
        [self.selectionButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button  = obj;
            if (button.tag == 0) {
                [button setImage:[UIImage imageNamed:@"ui03_check"] forState:UIControlStateNormal];
            } else{
                [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
            }
            self.typeImageView.image = nil;
        }];
        

    } else {
        
        [self.selectionButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
}

-(void)didSelectedPayType:(DetailPayType)type{
    if (type == WECHAT) {
        self.typeImageView.image = [UIImage imageNamed:@"ui03_wechat"];
        self.type = CASH_WECHAT;

    } else if(type == ALIPay){
        self.typeImageView.image = [UIImage imageNamed:@"ui03_alipay"];
        self.type = CASH_ALIPAY;

    } else{
        self.typeImageView.image = nil;
        [self.selectionButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button  = obj;
            [button setImage:[UIImage imageNamed:@"ui03_check0"] forState:UIControlStateNormal];
        }];
        self.type = NONE;

    }
}


- (IBAction)confirmPay:(id)sender {
    
    //TODO：根据选择不同，进行不同操作
    
    
    if (_type == APP) {
        [SVProgressHUD show];
        [NetworkingManager uploadOrderInfoToAPPByOrderID:self.orderID WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
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
