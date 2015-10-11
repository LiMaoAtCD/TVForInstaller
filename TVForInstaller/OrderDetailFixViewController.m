//
//  OrderDetailFixViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/10/11.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "OrderDetailFixViewController.h"
#import "ComminUtility.h"
#import "QRDecodeViewController.h"
#import "NetworkingManager.h"
#import <SVProgressHUD.h>
#import "OrderTypesViewController.h"
#import "OrderTypeNoScanViewController.h"
#import <Masonry.h>

@interface OrderDetailFixViewController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
 *  第二个模块
 */
@property (weak, nonatomic) IBOutlet UILabel *fixTypeLabel;


/**
 *  第三个模块
 */
@property (weak, nonatomic) IBOutlet UIView *reasonView;


/**
 *  第四个视图模块
 */

@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (nonatomic,copy) NSString * costNumber;

/**
 *  第五个模块
 */
@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation OrderDetailFixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"订单详情" forViewController:self];
    
    
    
    [self configBackGroundView];
    [self configFirstModuleView];
    [self configSecondModuleView];
    [self configThirdModuleView];
    [self configFourthModuleView];
    [self configFivethModuleView];

    [self registerForKeyboardNotifications];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        self.typeImageView.image = [UIImage imageNamed:@"ui03_service"];
        
        //订单时间
        
        self.NoLabel.text = self.order[@"id"];
        
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
    if (self.order) {
    
        NSString *orderInfo = self.order[@"orderInfo"];
        
        NSArray *arr = [orderInfo componentsSeparatedByString:@" "];
        
        if (arr.count > 0) {
            
            self.fixTypeLabel.text = arr[0];
        }
    }
}

-(void)configThirdModuleView{
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat margin_Horizontal = 20.0;
    CGFloat margin_Vertical = 10.0;
    
    CGFloat tagWidth = (screenWidth - margin_Horizontal * 6 ) / 3;

    CGFloat tagHeight = 30.0;
    if (self.order) {
        
        NSString *orderInfo = self.order[@"orderInfo"];
        
        NSArray *arr = [orderInfo componentsSeparatedByString:@" "];
        
        
        if (arr.count > 0) {
            
            
            
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx != 0) {
                    
                    NSString *info = obj;
                    
                    if (![info isEqualToString:@""]) {
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.userInteractionEnabled = NO;
                        [btn setAttributedTitle:[[NSAttributedString alloc]initWithString:info attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:12.0]}] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"ui08_rectangle"] forState:UIControlStateNormal];
                        [self.reasonView addSubview:btn];
                        
                        
                        NSInteger index = (idx - 1) % 3;
                        CGFloat leftConstraint = margin_Horizontal + index * (margin_Horizontal + tagWidth);
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.top.equalTo(self.reasonView.mas_topMargin).offset(tagHeight + idx/4 * (tagHeight + margin_Vertical));
                            make.left.equalTo(self.reasonView.mas_left).offset(leftConstraint);
                            make.width.greaterThanOrEqualTo(@(tagWidth));
                            make.height.equalTo(@(tagHeight));
                            
                        }];

                    }
                    
                    
                }
            }];
        }
        
        
    }

    
    
    
   
}

-(void)configFourthModuleView{
    
    self.costTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.costTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)configFivethModuleView{
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
        
        [self alertWithMessage:@"无法导航" withCompletionHandler:^{
            
        }];
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
                    OrderTypeNoScanViewController *scanVC = [sb instantiateViewControllerWithIdentifier:@"OrderTypeNoScanViewController"];
                    scanVC.cost = self.costNumber;
                    scanVC.orderID = self.order[@"id"];
                    [self.navigationController pushViewController:scanVC animated:YES];
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
    if (!CGRectContainsPoint(aRect, self.costTextField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.costTextField.frame animated:YES];
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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}






@end
