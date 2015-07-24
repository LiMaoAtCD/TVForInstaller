//
//  OrderMapViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/15.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OrderMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "CustomAnnotationView.h"
#import "CustomPointAnnotation.h"
#import "OrderDetailViewController.h"
#import "AccountManager.h"
#import "OngoingOrder.h"
#import "NetworkingManager.h"
#import <JGProgressHUD.h>


#import "BNCoreServices.h"

@interface OrderMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKCloudSearchDelegate,BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate,DidConfirmOrderDelegate>


/**
 *  云检索服务
 */
@property (nonatomic, strong) BMKCloudSearch *cloudSearch;
/**
 *  位置编码服务
 */
@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
/**
 *  位置定位服务
 */
@property (nonatomic, strong) BMKLocationService *locService;
/**
 *  地图视图
 */
@property (nonatomic, strong) BMKMapView *mapView;

/**
 *  自定义标注视图
 */
@property (nonatomic, strong) CustomPointAnnotation *pointAnnotation;

/**
 *  标注数组
 */
@property (nonatomic, strong) NSMutableArray *pointAnnotations;

/**
 *  订单数据集合
 */
@property (nonatomic, strong) NSMutableArray *Orders;

/**
 *  百度地图停止了定位
 */
@property (nonatomic ,assign) BOOL isStopLocatingUser;

/**
 *  当前用户位置
 */
@property (nonatomic,strong) BMKUserLocation * currentUserLocation;

/**
 *  是否有订单进行中
 */
@property (nonatomic, assign) BOOL isOrderGoing;

/**
 *  是否正在POI检索附近
 */
@property (nonatomic, assign) BOOL isFetchOrder;


/**
 *  订单进行中-提示
 */
@property (nonatomic, strong) UIView *orderGoingNoteView;

@property (nonatomic, assign) BOOL isSelectedPaoPaoView;


@end

@implementation OrderMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //定位服务初始化
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    [BMKLocationService setLocationDistanceFilter:100.f];
    _locService = [[BMKLocationService alloc] init];
    
    //地址转经纬度
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    
    //地图视图初始化
    _mapView =[[BMKMapView alloc] initWithFrame:self.view.bounds];
    
    //云检索服务
    _cloudSearch = [[BMKCloudSearch alloc] init];
    
    
    [self.view addSubview:_mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    
    _mapView.delegate = self;
    _locService.delegate = self;
    _geocodesearch.delegate = self;
    _cloudSearch.delegate = self;

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isStopLocatingUser) {
        //定位到当前地址
        [_locService startUserLocationService];
        
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
        self.isStopLocatingUser = NO;
    }

    //如果有订单还未完成
    self.isOrderGoing = [OngoingOrder existOngoingOrder];
    if (!self.isOrderGoing) {
        //        [self addPointAnnotations];
        [self noteOngoingOrderView:NO];
        [self SearchNearByOrders];
        
    } else {
        [self removeAnnotions];
        [self noteOngoingOrderView:YES];
    }

    
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
    _cloudSearch.delegate = nil;
    
}

#pragma mark - 添加标注

-(void)addPointAnnotations{

    self.pointAnnotations = [NSMutableArray array];
    [self.Orders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *temp = obj;
        
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        annotation.tag = idx;
        CLLocationCoordinate2D coor;
        
        coor.latitude = [temp[@"location"][1] doubleValue];
        coor.longitude = [temp[@"location"][0] doubleValue];
        
        annotation.coordinate = coor;
        annotation.title = nil;
        [self.pointAnnotations addObject:annotation];
        
    }];
    
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:self.pointAnnotations];
    
}
-(void)removeAnnotions{
    NSArray *annotations= self.mapView.annotations;
    [self.mapView removeAnnotations:annotations];
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    self.currentUserLocation = userLocation;
    self.currentUserLocation.title = nil;
    [self SearchNearByOrders];
}

- (void)didStopLocatingUser{
    self.isStopLocatingUser = YES;
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    CustomPointAnnotation *temp_annotation = (CustomPointAnnotation *)annotation;
    
    NSDictionary *data = self.Orders[temp_annotation.tag];
    
    NSString *name = data[@"name"];
    NSString *address = data[@"home_address"];
    NSString *subscribe = data[@"order_time"];
    ServiceType type = [data[@"order_type"] integerValue];
    
    NSString *AnnotationViewID = @"ImageAnnotation";
    CustomAnnotationView *annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

    if (type == TV) {
        annotationView.annotationImageView.image = [UIImage imageNamed:@"ui01_location_tv_button"];

    } else{
        annotationView.annotationImageView.image = [UIImage imageNamed:@"ui01_location_broadband_button"];

    }
    
    BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:[self paopaoView:name address:address subscribeDate:subscribe orderType:type]];
    annotationView.paopaoView = paopaoView;
    
    annotationView.tag = temp_annotation.tag;

    
    return annotationView;

}

-(UIView *)paopaoView:(NSString *)name address:(NSString *)address subscribeDate:(NSString *)date orderType:(ServiceType)type{
    UIImage *backgroundImage = [UIImage imageNamed:@"ui01_client_button"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    UIImageView *serviceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 14, 37, 37)];
    switch (type) {
        case TV:
        {
            serviceImageView.image = [UIImage imageNamed:@"ui01_tv"];

        }
            break;
        case BROADBAND:
        {
            serviceImageView.image = [UIImage imageNamed:@"ui01_Broadband"];

        }
        default:
            break;
    }
    
    UILabel *nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(47, 14, 42, 17)];
    nameLabel.text = name;
    nameLabel.font =[UIFont boldSystemFontOfSize:14.0];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *addressLabel =[[UILabel alloc] initWithFrame:CGRectMake(90, 9, 115, 33)];
    addressLabel.text = address;
    addressLabel.font =[UIFont systemFontOfSize:10.0];
    addressLabel.textColor = [UIColor lightGrayColor];
//    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.numberOfLines = 2;
    
    UILabel *subscribeTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(53, 40, 50, 12)];
    subscribeTimeLabel.text = @"预约时间:";
    subscribeTimeLabel.font =[UIFont systemFontOfSize:10.0];
    subscribeTimeLabel.textColor = [UIColor lightGrayColor];
    subscribeTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *subscribeContentTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(105, 40, 101, 12)];
    subscribeContentTimeLabel.text = date;
    subscribeContentTimeLabel.font =[UIFont systemFontOfSize:10.0];
    subscribeContentTimeLabel.textColor = [UIColor lightGrayColor];
    subscribeContentTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(214, 22, 8, 14)];
    accessoryView.image = [UIImage imageNamed:@"ui01_arrows"];
    
    
    [view addSubview:backImageView];
    [view addSubview:serviceImageView];
    [view addSubview:nameLabel];
    [view addSubview:addressLabel];

    [view addSubview:subscribeContentTimeLabel];
    [view addSubview:subscribeTimeLabel];
    [view addSubview:accessoryView];

    return view;
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    //先查看订单状态是否已被咱用
    NSDictionary *detailInfo = self.Orders[view.tag];
    
    //如果没有点击过泡泡
    if (!self.isSelectedPaoPaoView) {
        self.isSelectedPaoPaoView = YES;
        [NetworkingManager CheckOrderisOccupiedByID:detailInfo[@"uid"] WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *poi = responseObject[@"poi"];
            if ([poi[@"order_state"] integerValue] == 0) {
                //如果没有被占用，就占用
                [NetworkingManager ModifyOrderStateByID:detailInfo[@"uid"] latitude:[detailInfo[@"location"][1] doubleValue] longitude:[detailInfo[@"location"][0] doubleValue] order_state:@"1" WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSLog(@"responseObject %@",responseObject);
                    if ([responseObject[@"status"] integerValue] == 0) {
                        //占用成功，跳到详情界面
                        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Order" bundle:nil];
                        
                        OrderDetailViewController *detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
                        
                        BNPosition *originPostion = [[BNPosition alloc] init];
                        originPostion.x = self.currentUserLocation.location.coordinate.longitude;
                        originPostion.y = self.currentUserLocation.location.coordinate.latitude;
                        
                        detail.originalPostion = originPostion;
                        
                        BNPosition *destinationPostion = [[BNPosition alloc] init];
                        destinationPostion.x = [detailInfo[@"location"][0] doubleValue];
                        destinationPostion.y = [detailInfo[@"location"][1] doubleValue];
                        
                        detail.destinationPosition = destinationPostion;
                        detail.info = detailInfo;
                        
                        detail.delegate = self;
                        detail.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:detail animated:YES];
                        self.isSelectedPaoPaoView = NO;

                    }
                    
                } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
                    self.isSelectedPaoPaoView = NO;

                }];
                
                
            } else if([poi[@"order_state"] integerValue] == 1){
                //TODO该订单已被占用
                [self alertWithMessage:@"此订单被其他工程师占用中，请稍后再试" withCompletionHandler:^{
                    self.isSelectedPaoPaoView = NO;

                }];
                
            }
            
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
            hud.textLabel.text = @"网络不稳定,请稍后再试";
            hud.indicatorView = nil;
            
            [hud showInView:self.view];
            [hud dismissAfterDelay:1.0];
            
            hud.tapOnHUDViewBlock = ^(JGProgressHUD *hud){[hud dismiss];};
            hud.tapOutsideBlock = ^(JGProgressHUD *hud){[hud dismiss];};
            self.isSelectedPaoPaoView = NO;

        }];

    }
    
    
    
    
    
   
    
}


-(void)mapStatusDidChanged:(BMKMapView *)mapView{
    
    if (mapView.zoomLevel < 11) {
        //缩放等级太小，隐藏订单
        [mapView removeAnnotations:mapView.annotations];
    } else{
        
        //如果已经有在进行中的订单，并且标注等于0
        if (!self.isOrderGoing) {
            if (mapView.annotations.count == 0) {
                [mapView addAnnotations:self.pointAnnotations];
            }
        }
        
    }
}

-(void)mapViewDidFinishLoading:(BMKMapView *)mapView{
   CLAuthorizationStatus status =  [CLLocationManager authorizationStatus];
//    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (status == kCLAuthorizationStatusDenied) {
        
        [self alertWithMessage:@"请在设置-隐私-定位里打开极客快服访问权限" withCompletionHandler:^{
            
        }];
    } else{
        
        //配置mapView
        _mapView.zoomLevel = 14.f;
        _mapView.showMapScaleBar = YES;
        _mapView.mapScaleBarPosition = CGPointMake(_mapView.frame.size.width - 70, _mapView.frame.size.height - 40);
        
        
        
        //定位到当前地址
        [_locService startUserLocationService];
        
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
        _mapView.isSelectedAnnotationViewFront = NO;
    }
}

#pragma mark - 搜索附近订单

-(void)SearchNearByOrders{
    //判断本地位置是否已经获取到
    if (!self.currentUserLocation) {
        return;
    }
    
    //是否存在进行中订单
    self.isOrderGoing = [OngoingOrder existOngoingOrder];
    if (!self.isOrderGoing) {
        
        
        //是否已经在请求(不发出多次请求)
        if (!self.isFetchOrder) {
            self.isFetchOrder = YES;
            
            NSString *location = [NSString stringWithFormat:@"%.6f,%.6f", self.currentUserLocation.location.coordinate.longitude, self.currentUserLocation.location.coordinate.latitude];
            [NetworkingManager fetchNearbyOrdersByLocation:location radius:5000 tags:@"" pageIndex:0 pageSize:10 WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *results = responseObject;
                
                NSMutableArray *tempOrders = [NSMutableArray array];
                NSArray *resultArray  = results[@"contents"];
                [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *temp = obj;
                    if ([temp[@"order_state"] integerValue] == 0) {
                        //空闲订单
                        [tempOrders addObject:temp];
                    } else if ([temp[@"order_state"] integerValue] == 2 && [temp[@"engineer_id"] isEqualToString:[AccountManager getCellphoneNumber]]){
                        //正在进行中的订单
                        [OngoingOrder setExistOngoingOrder:YES];
                        [OngoingOrder setOrder:temp];
                        
                    }
                    
                }];
                
                if (![OngoingOrder existOngoingOrder]) {
                    self.Orders = tempOrders;
                    [self addPointAnnotations];
                    [self noteOngoingOrderView:NO];
                    
                    if (self.Orders.count == 0) {
                        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
                        hud.textLabel.text = @"暂未找到附近订单";
                        hud.indicatorView = nil;
                        [hud showInView:self.view];
                        [hud dismissAfterDelay:2.0];
                    }
                } else{
                    [self removeAnnotions];
                    [self noteOngoingOrderView:YES];
                }
                self.isFetchOrder = NO;

            } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.isFetchOrder = NO;

            }];
            
        }
    } else {
        //存在
        [self removeAnnotions];
        [self noteOngoingOrderView:YES];
    }
}

#pragma mark - 正在进行的订单视图

-(void)noteOngoingOrderView:(BOOL)show{
    if (show) {
        [self.orderGoingNoteView removeFromSuperview];
        self.orderGoingNoteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        self.orderGoingNoteView.backgroundColor = [UIColor whiteColor];
        self.orderGoingNoteView.layer.cornerRadius = 5.0;
        self.orderGoingNoteView.layer.masksToBounds = YES;
        UILabel *label = [[UILabel alloc] initWithFrame:self.orderGoingNoteView.bounds];
        
        label.text = @"订单正在进行中";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:254./255 green:118.0/255 blue:118./255 alpha:1.0];
        
        [self.orderGoingNoteView addSubview:label];
        
        [self.view addSubview:self.orderGoingNoteView];
        self.orderGoingNoteView.center = self.view.center;
        self.mapView.userInteractionEnabled = NO;
    } else{
        [self.orderGoingNoteView removeFromSuperview];
        self.mapView.userInteractionEnabled = YES;
    }
}

#pragma mark - dealloc
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
    if (_locService) {
        _locService = nil;
    }
    if (_cloudSearch) {
        _cloudSearch = nil;
    }
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


-(void)didConfirmOrderFrom:(BNPosition *)originalAddress to:(BNPosition *)destinationAddress{
    if ([self checkServicesInited]) {
        [self startNavigatingFromOriginalAddress:originalAddress ToDestinationAddress:destinationAddress];
    }
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
