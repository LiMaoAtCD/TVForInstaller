//
//  OrderDetailViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/16.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ComminUtility.h"

#import "BNCoreServices.h"

#import "AccountManager.h"

#import "OngoingOrder.h"

@interface OrderDetailViewController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ComminUtility configureTitle:@"订单详情" forViewController:self];
    
    [self configOrderContent];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [BNCoreServices_Instance initServices:@"8Nep3BNORZ9DaTyU0Cp5GUnn"];
    [BNCoreServices_Instance startServicesAsyn:^{
        NSLog(@"success");
    } fail:^{
        NSLog(@"fail");
    }];
}

-(void)pop{
    
    [BNCoreServices_Instance stopServices];

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
- (IBAction)call:(id)sender {
    
     UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:self.telphone preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //TODO: 拨打电话
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:13568927473"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.telphone]]];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}
- (IBAction)confirmOrder:(id)sender {
//    [self startNavi];
    [AccountManager setExistOngoingOrder:YES];
    

    [OngoingOrder setOngoingOrderName:self.info[@"name"]];
    [OngoingOrder setOngoingOrderDate:self.info[@"subscribe"]];
    [OngoingOrder setOngoingOrderType:[self.info[@"servicetype"] integerValue]];
    [OngoingOrder setOngoingOrderAddress:self.info[@"detailAddress"]];
    [OngoingOrder setOngoingOrderTelephone:self.info[@"telephone"]];
    [OngoingOrder setOngoingOrderRunningNumber:self.info[@"running"]];
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否开始导航？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self checkServicesInited]) {
            [self startNavigatingFromOriginalAddress:_originalPostion ToDestinationAddress:_destinationPosition];
        }

    }];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)configOrderContent{
    if (self.type == TV) {
        self.typeImageView.image = [UIImage imageNamed:@"ui03_tv"];
    } else{
        self.typeImageView.image = [UIImage imageNamed:@"ui03_Broadband"];
    }
    self.nameLabel.text = self.name;
    self.telphoneLabel.text = self.telphone;
    self.addressLabel.text = self.address;
    self.runningNumberLabel.text =self.runningNumber;
    self.dateLabel.text= self.date;
}

- (BOOL)checkServicesInited
{
    if(![BNCoreServices_Instance isServicesInited])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
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
- (void)startNavi
{
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    startNode.pos.x = 113.948222;
    startNode.pos.y = 22.549555;
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:startNode];
    
    //也可以在此加入1到3个的途经点
    
    BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
    midNode.pos = [[BNPosition alloc] init];
    midNode.pos.x = 113.977004;
    midNode.pos.y = 22.556393;
    midNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:midNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    endNode.pos.x = 114.089863;
    endNode.pos.y = 22.546236;
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    [nodesArray addObject:endNode];
    
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Highway naviNodes:nodesArray time:nil delegete:self userInfo:nil];
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



@end
