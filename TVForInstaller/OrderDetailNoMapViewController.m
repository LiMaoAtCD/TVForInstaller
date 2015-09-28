//
//  OrderDetailNoMapViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "OrderDetailNoMapViewController.h"
#import "ComminUtility.h"
#import "QRDecodeViewController.h"
#import "NetworkingManager.h"
#import <SVProgressHUD.h>
#import "OrderTypesViewController.h"
#import "OrderTypeNoScanViewController.h"

@interface OrderDetailNoMapViewController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>



@property (weak, nonatomic) IBOutlet UIView *backGroundView;

/**
 *  第一个视图模块
 */
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cellphoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *NoLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneCallButton;

@property (weak, nonatomic) IBOutlet UIButton *navigateButton;

/**
 *  第二个视图模块
 */

@property (weak, nonatomic) IBOutlet UIButton *scanButton;

@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@property (nonatomic,copy) NSString * qrcode;


/**
 *  第三个视图模块
 */

@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (nonatomic,copy) NSString * costNumber;

/**
 *  第四个模块
 */
@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation OrderDetailNoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"订单详情" forViewController:self];
    
    
    
    [self configBackGroundView];
    [self configFirstModuleView];
    [self configSecondModuleView];
    [self configThirdModuleView];
    [self configFourthModuleView];



    
}

-(void)configBackGroundView{
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    
    [self.backGroundView addGestureRecognizer:recognizer];
}

-(void)dismissKeyboard:(id)sender{
    [self.costTextField resignFirstResponder];
}


-(void)configFirstModuleView{
    
    if (self.order) {
        
        NSInteger type = [self.order[@"orderType"] integerValue];
        
        self.typeImageView.image = [UIImage imageNamed:@""];
        switch (type) {
            case 0:
            {
                self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
            }
                break;
            case 1:
            {
                self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
            }
                break;
            case 2:
            {
                self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
            }
                break;
                
            default:
                break;
        }
        
        //订单时间
        
        self.dateLabel.text = self.order[@"orderTime"];
        
        self.nameLabel.text = self.order[@"name"];
        
        self.cellphoneLabel.text = self.order[@"phone"];
        
        self.addressLabel.text = self.order[@"homeAddress"];
        
        [self.phoneCallButton addTarget:self action:@selector(callAlert:) forControlEvents:UIControlEventTouchUpInside];
        
        //TODO：导航
        [self.navigateButton addTarget:self action:@selector(beginNavigate:) forControlEvents:UIControlEventTouchUpInside];
    } else{
    //
    }
    
}


-(void)configSecondModuleView{
    
    _scanLabel.hidden = YES;
    [_scanButton addTarget:self action:@selector(scanQRCode:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)configThirdModuleView{
    
    self.costTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.costTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)configFourthModuleView{
    self.totalCostLabel.text = @"0";
    [self.submitButton addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];

}






#pragma mark - target action

-(void)beginNavigate:(id)sender{
    if (![self.order[@"longitude"] isKindOfClass:[NSNull class]] && ![self.order[@"latitude"] isKindOfClass:[NSNull class]] && self.originPostion != nil) {
        
       
        BNPosition *destinationPostion = [[BNPosition alloc] init];
        destinationPostion.x = [self.order[@"longitude"] floatValue];
        destinationPostion.y = [self.order[@"latitude"] floatValue];
        
        if ([self checkServicesInited]) {
            [self startNavigatingFromOriginalAddress:self.originPostion ToDestinationAddress:destinationPostion];
        }
        
        
        
    } else{
    
       
    }
    
    
}

-(void)textFieldEditChanged:(UITextField *)textfield{
    
    self.costNumber = textfield.text;
    self.totalCostLabel.text = self.costNumber;
}

-(void)submitOrder:(id)sender{
    
    if (self.costNumber == nil ||[self.costNumber isEqualToString:@"0"]) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:@"请填写正确的金额" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    } else{
        
        [SVProgressHUD show];
        
        [NetworkingManager sumitOrderID:self.order[@"id"] andFee:self.costNumber WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 1) {
                [SVProgressHUD dismiss];
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                if ([self.qrcode isEqualToString:@""]|| self.qrcode == nil) {
                    OrderTypeNoScanViewController *scanVC = [sb instantiateViewControllerWithIdentifier:@"OrderTypeNoScanViewController"];
                    scanVC.cost = self.costNumber;
                    scanVC.orderID = self.order[@"id"];
                    [self.navigationController pushViewController:scanVC animated:YES];
                    
                } else {
                    OrderTypesViewController *orderVC = [sb instantiateViewControllerWithIdentifier:@"OrderTypesViewController"];
                    orderVC.qrcode = self.qrcode;
                    orderVC.cost = self.costNumber;
                    orderVC.orderID = self.order[@"id"];
                    
                    [self.navigationController pushViewController:orderVC animated:YES];
                }
            } else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }];
    }
}

-(void)callAlert:(id)sender{
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:self.order[@"phone"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.order[@"phone"]]]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - scan qrcode

-(void)scanQRCode:(UIButton *)button{
    QRDecodeViewController *qrcode = [[QRDecodeViewController alloc] init];
    
    [self showDetailViewController:qrcode sender:self];
    //    [self presentViewController:qrcode animated:YES completion:^{
    //        self.navigationController.tabBarController.view.frame = CGRectMake(0, 0, self.navigationController.tabBarController.view.frame.size.width, self.navigationController.tabBarController.view.frame.size.height);
    //    }];
    
    __weak OrderDetailNoMapViewController *weakSelf = self;
    
    qrcode.qrUrlBlock = ^(NSString * code) {
        [weakSelf uploadDeviceID:code];
        weakSelf.scanLabel.text = code;
        weakSelf.scanLabel.hidden = NO;
        weakSelf.scanButton.hidden = YES;
    };
}

-(void)uploadDeviceID:(NSString *)deviceID{
    if (deviceID) {
        
        [SVProgressHUD showWithStatus:@"正在上传设备编码"];
        [NetworkingManager uploadDeviceNumber:deviceID orderID:self.order[@"id"] WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 1) {
                self.scanLabel.text = deviceID;
                self.scanLabel.hidden = NO;
                self.scanButton.hidden = YES;
                [SVProgressHUD showSuccessWithStatus:@"二维码上传成功"];
                self.qrcode = deviceID;

            } else{
            }
            
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
        }];
    }else{
        //没有获取到
        
    }
}



#pragma mark -关闭二维码

-(void)didClickCloseQRCode{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark --导航

- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        [self alertWithMessage:@"引擎尚未初始化完成，请稍后再试" withCompletionHandler:^{
            
        }];
        return NO;
    }
    return YES;
}
-(void)startNavigatingFromOriginalAddress:(BNPosition *)originalAddress ToDestinationAddress:(BNPosition *)destinationAddress{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = [originalAddress x];
    startNode.pos.y = [originalAddress y];
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //也可以在此加入1到3个的途经点
    
    //    BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
    //    midNode.pos = [[BNPosition alloc] init];
    //    midNode.pos.x = 113.977004;
    //    midNode.pos.y = 22.556393;
    //    midNode.pos.eType = BNCoordinate_BaiduMapSDK;
    //    [nodesArray addObject:midNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = [destinationAddress x];
    endNode.pos.y = [destinationAddress y];
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}


#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed) {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航");
    [BNCoreServices_Instance stopServices];
}

//退出导航声明页面回调
- (void)onExitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
}

-(void)onExitDigitDogUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出电子狗页面");
}

#pragma mark - 提示消息方法
typedef void(^alertBlock)(void);

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
