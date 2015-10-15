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
#import "NetworkingManager.h"
#import <SVProgressHUD.h>


#import "BNCoreServices.h"
#import <AVFoundation/AVFoundation.h>


typedef void (^searchResultBlock)(BOOL isExistOrder);

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


/**
 *  泡泡点击锁
 */
@property (nonatomic, assign) BOOL isSelectedPaoPaoView;




/**
 *  判断订单是否需要显示
 */
@property (nonatomic, assign) BOOL isNeedShowNearestOrder;


/**
 *  最近订单视图
 */
@property (nonatomic, strong) UIView *nearestOrderView;

/**
 *  最近订单uid
 */
@property (nonatomic, copy) NSString *nearestUid;

@property (nonatomic, copy) NSString *kiloMeters;



@end

@implementation OrderMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //定位服务初始化
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
//    [BMKLocationService setLocationDistanceFilter:kCLDistanceFilterNone];
    [BMKLocationService setLocationDistanceFilter:500.f];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
//        [_locationManager requestAlwaysAuthorization];
//    }
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//        _locationManager.allowsBackgroundLocationUpdates = YES;
//    }
//    [_locationManager startUpdatingLocation];

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
    
    
    self.isNeedShowNearestOrder = YES;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //如果有订单还未完成
    self.isOrderGoing = YES;
    if (!self.isOrderGoing) {
        
        if (self.isStopLocatingUser) {
            //定位到当前地址
            [_locService startUserLocationService];
            
            _mapView.showsUserLocation = NO;//先关闭显示的定位图层
            _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
            _mapView.showsUserLocation = YES;//显示定位图层
            self.isStopLocatingUser = NO;
        }
        
       
        
        [SVProgressHUD show];
        [self searchOnGoingOrderWithBlock:^(BOOL isExistOrder) {
            if (isExistOrder) {
                //存在
                [SVProgressHUD dismiss];

                [self removeAnnotions:self.mapView.annotations];
                [self noteOngoingOrderView:YES];

            } else{
                
//                [self addPointAnnotations];
                [self SearchNearByOrders];
            }
        }];
        
    } else {
        [self removeAnnotions:self.mapView.annotations];
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

    [SVProgressHUD dismiss];
    
    
    self.isNeedShowNearestOrder = NO;
    
}

#pragma mark - 添加标注

-(void)addPointAnnotations{

    //待增加的订单
    NSMutableArray *toAddAnnotations = [NSMutableArray array];
    //本地与服务器共同的订单
    NSMutableArray *tempArray = [NSMutableArray array];
    
    //遍历本地与服务器订单交集
    [self.pointAnnotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CustomPointAnnotation *annotation = obj;
        [self.Orders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            

            NSDictionary *temp = obj;
            NSString *tempUID = temp[@"uid"];

            if ([annotation.uid isEqualToString:tempUID]) {
                [tempArray addObject:annotation];
            }
            
        }];
    }];
    
    //本地删除交集，剩余就是失效的订单
    [self.pointAnnotations removeObjectsInArray:tempArray];
    
    //删除服务器上不存在的标注
    [self.mapView removeAnnotations:self.pointAnnotations];
    
    
    
    //遍历远程的订单，生成新的标注数组
    [self.Orders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *temp = obj;
        NSString *tempUID = temp[@"uid"];
        
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        annotation.uid = tempUID;
        CLLocationCoordinate2D coor;
        coor.latitude = [temp[@"latitude"] doubleValue];
        coor.longitude = [temp[@"longitude"] doubleValue];
        annotation.coordinate = coor;
        annotation.title = nil;
        
        [toAddAnnotations addObject:annotation];
    }];
    //先把本地最新的标注同步服务器的标注数组
    self.pointAnnotations = [toAddAnnotations mutableCopy];
    
    //服务器标注删除本地已经有的标注
    [toAddAnnotations removeObjectsInArray:tempArray];
    
    //剩余的就是待新增的标注
    [self.mapView addAnnotations:toAddAnnotations];
    
    //不显示正在进行
    [self noteOngoingOrderView:NO];
    
    
    //弹出最近的订单
    
    if (self.isNeedShowNearestOrder) {
        
        __block NSMutableDictionary *detailInfo =  [NSMutableDictionary dictionary];
        [self.Orders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *temp = obj;
            
            if ([temp[@"uid"] isEqualToString:self.nearestUid]) {
                detailInfo = [temp mutableCopy];
            }
        }];
    
        
        if ([detailInfo allKeys].count > 0) {
            ServiceType type = [detailInfo[@"orderType"] integerValue];
            NSString *address = detailInfo[@"homeAddress"];
            [self showNearestOrderWithKiloMeters:self.kiloMeters type:type address:address];
        }
       
    } else{
        
    }
    
    
    

    
    
    
    
    
//    self.pointAnnotations = [self.Orders mutableCopy];
    
//    [self.Orders removeObjectsInArray:tempArray];
    
//    [self.mapView addAnnotations:self.Orders];
    

    
    
    
//    self.pointAnnotations
//    self.Orders
    
    

    
}
-(void)removeAnnotions:(NSArray *)annotations{
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
    
//    NSDictionary *data = self.Orders[temp_annotation.tag];
    
    __block NSMutableDictionary *data =  [NSMutableDictionary dictionary];
    [self.Orders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *temp = obj;
        
        if ([temp[@"uid"] isEqualToString:temp_annotation.uid]) {
            data = [temp mutableCopy];
        }
    }];

    
    NSString *name = data[@"name"];
    NSString *address = data[@"homeAddress"];
    NSString *subscribe = data[@"orderTime"];
    ServiceType type = [data[@"orderType"] integerValue];
    
    NSString *AnnotationViewID = @"ImageAnnotation";
    CustomAnnotationView *annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

    if (type == TV) {
        annotationView.annotationImageView.image = [UIImage imageNamed:@"ui01_location_tv_button"];

    }else if (type == BROADBAND){
        annotationView.annotationImageView.image = [UIImage imageNamed:@"ui01_location_broadband_button"];

    } else{
        annotationView.annotationImageView.image = [UIImage imageNamed:@"ui01_btn_service"];
    }
    
    BMKActionPaopaoView *paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:[self paopaoView:name address:address subscribeDate:subscribe orderType:type]];
    annotationView.paopaoView = paopaoView;
    
    annotationView.uid = temp_annotation.uid;

    
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
            break;
        case SERVICE:{
            serviceImageView.image = [UIImage imageNamed:@"ui01_btn_service"];

        }
            break;

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
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    //先查看订单状态是否已被咱用
//    NSDictionary *detailInfo = self.Orders[view.tag];
    
    CustomAnnotationView *tempView = (CustomAnnotationView*)view;
    
    __block NSMutableDictionary *detailInfo =  [NSMutableDictionary dictionary];
    [self.Orders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *temp = obj;
        
        if ([temp[@"uid"] isEqualToString:tempView.uid]) {
            detailInfo = [temp mutableCopy];
        }
    }];

    
    //如果没有点击过泡泡
    if (!self.isSelectedPaoPaoView) {
        self.isSelectedPaoPaoView = YES;
        
        
        //TODO: 占用订单
        
        [SVProgressHUD show];
        [NetworkingManager OccupyOrderOrCancelByUID:detailInfo[@"uid"] engineerid:[AccountManager getTokenID] orderstate:@"1" WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.isSelectedPaoPaoView = NO;
            
            if ([responseObject[@"success"] integerValue] == 1) {

                [SVProgressHUD dismiss];
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Order" bundle:nil];
                
                OrderDetailViewController *detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
                
                BNPosition *originPostion = [[BNPosition alloc] init];
                originPostion.x = self.currentUserLocation.location.coordinate.longitude;
                originPostion.y = self.currentUserLocation.location.coordinate.latitude;
                
                detail.originalPostion = originPostion;
                
                BNPosition *destinationPostion = [[BNPosition alloc] init];
                destinationPostion.x = [detailInfo[@"longitude"] doubleValue];
                destinationPostion.y = [detailInfo[@"latitude"] doubleValue];
                
                detail.destinationPosition = destinationPostion;
                detail.info = detailInfo;
                
                detail.delegate = self;
                detail.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
            } else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.isSelectedPaoPaoView = NO;
            [SVProgressHUD showErrorWithStatus:@"网络出错"];

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

#pragma mark - 搜索正在进行中的订单

-(void)searchOnGoingOrderWithBlock:(searchResultBlock)block{
    [NetworkingManager FetchOnGoingOrderWithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"success"] integerValue] == 1) {
            //
            NSArray *tempArray = responseObject[@"obj"];
            
            if (tempArray.count > 0) {
                //有正在进行的订单
                NSDictionary *dic = tempArray[0];
                
                
                NSMutableDictionary *temp = [NSMutableDictionary dictionary];
                
                temp[@"name"] = dic[@"name"];
                temp[@"phone"] = dic[@"phone"];
                temp[@"homeAddress"] = dic[@"homeAddress"];
                temp[@"orderTime"] = dic[@"orderTime"];
                temp[@"orderType"]  = dic[@"orderType"];
                temp[@"uid"] = dic[@"uid"];
                
    

                if (block) {
                    block(YES);
                }
            } else{
                if (block) {
                    block(NO);
                }
            }
        } else{
            
        }
        
    } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];

        
    }];
}
#pragma mark - 搜索附近订单

-(void)SearchNearByOrders{
    //判断本地位置是否已经获取到
    if (!self.currentUserLocation) {
        return;
    }
    
    //是否存在进行中订单
    if (!YES) {
        
        //是否已经在请求(不发出多次请求)
        if (!self.isFetchOrder) {
            self.isFetchOrder = YES;
            
            NSMutableArray *tempOrders = [NSMutableArray array];

            [NetworkingManager fetchNearByOrdersByLatitude:self.currentUserLocation.location.coordinate.latitude Logitude:self.currentUserLocation.location.coordinate.longitude WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {

                
                if ([responseObject[@"success"] integerValue] == 1) {
                    //附近订单获取成功
                    [SVProgressHUD dismiss];
                    
                    NSArray *array = responseObject[@"attributes"][@"nearest"];
                    if (array.count != 0) {
                        self.nearestUid = responseObject[@"attributes"][@"nearest"][@"uid"];
                        self.kiloMeters = responseObject[@"attributes"][@"distance"];
                    }
                   

                    NSArray *resultArray = responseObject[@"obj"];
                    for (NSDictionary *temp in resultArray) {
                        
                        if ([temp[@"orderState"] integerValue] == 0) {
                            //空闲订单
                            [tempOrders addObject:temp];
                        }else if ([temp[@"orderState"] integerValue] == 2 && [temp[@"engineerId"] isEqualToString:[AccountManager getTokenID]]){
                            //正在进行中的订单
                          
                        }
                    }
                    
                    
                 
                    
                } else{
                    self.isFetchOrder = NO;

                    //附近订单获取失败
                    [SVProgressHUD showErrorWithStatus:@"获取订单失败"];

                }
            } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.isFetchOrder = NO;
                [SVProgressHUD dismiss];

            }];

        }
    } else {
        //存在执行中的订单
        [SVProgressHUD dismiss];

        [self removeAnnotions:self.mapView.annotations];
        [self noteOngoingOrderView:YES];
    }
}

#pragma mark - 显示最近订单

-(void)showNearestOrderWithKiloMeters:(NSString *)km type:(ServiceType)type address:(NSString *)address{
    self.isNeedShowNearestOrder = NO;
    
    if (!self.nearestOrderView) {
        self.nearestOrderView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.nearestOrderView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        bgView.backgroundColor = [UIColor blackColor];
        
        bgView.alpha = 0.3;
        
        [_nearestOrderView addSubview:bgView];
        
        
        UIView *nearestView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
        nearestView.layer.cornerRadius = 20.0;
        nearestView.layer.masksToBounds = YES;
        nearestView.backgroundColor = [UIColor blackColor];
        
        
        [_nearestOrderView addSubview:nearestView];
        
        
        nearestView.center = _nearestOrderView.center;
        
        
        UIImageView *serviceTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 53, 66)];
        
        [nearestView addSubview:serviceTypeImageView];

        
        if (type == TV) {
            serviceTypeImageView.image =[UIImage imageNamed:@"ui10_location_tv"];
        } else if (type == BROADBAND){
            serviceTypeImageView.image =[UIImage imageNamed:@"ui10_location_broadband"];
        } else{
            serviceTypeImageView.image =[UIImage imageNamed:@"ui10_service"];
        }
        
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 51, 60, 24)];
        label1.text = @"距离您";
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont boldSystemFontOfSize:17.0];
        
        
        [nearestView addSubview:label1];
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(161, 49, 60, 24)];
        
        label2.text = km;
        label2.textColor = [UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0];
        label2.font = [UIFont boldSystemFontOfSize:28.0];
        
        
        [nearestView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(229, 51, 50, 24)];
        
        
        label3.text = @"公里";
        label3.textColor = [UIColor whiteColor];
        label3.font = [UIFont boldSystemFontOfSize:17.0];
        
        
        [nearestView addSubview:label3];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 105, 149, 45);
        
        cancelButton.backgroundColor = [UIColor whiteColor];
        
        [cancelButton addTarget:self action:@selector(dismissNearestAlert) forControlEvents:UIControlEventTouchUpInside];
        
        [cancelButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"取消" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}] forState:UIControlStateNormal];
        
        [nearestView addSubview:cancelButton];
        
        UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        orderButton.frame = CGRectMake(151, 105, 149, 45);
        
        orderButton.backgroundColor = [UIColor whiteColor];
        
        [orderButton addTarget:self action:@selector(rabOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [orderButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"抢单" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}] forState:UIControlStateNormal];
        [nearestView addSubview:orderButton];
        
        
        
        AVSpeechSynthesizer * speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
        
        //    NSString * utteranceString = @"距离您0.23千米,有一个订单";
        NSString * utteranceString =[NSString stringWithFormat:@"最近订单,距离您%@公里,地址:%@",km,address];
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:utteranceString];
        
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        
        utterance.preUtteranceDelay = 0.2f;
        utterance.postUtteranceDelay = 0.2f;
        
        [speechSynthesizer speakUtterance:utterance];

    }
}

-(void)dismissNearestAlert{
    
    [self.nearestOrderView removeFromSuperview];
    self.nearestOrderView = nil;
}

-(void)rabOrder:(id)sender{

    __block NSMutableDictionary *detailInfo =  [NSMutableDictionary dictionary];
    [self.Orders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *temp = obj;
        
        if ([temp[@"uid"] isEqualToString:self.nearestUid]) {
            detailInfo = [temp mutableCopy];
        }
    }];
    
    
    //如果没有点击过泡泡
    if (!self.isSelectedPaoPaoView) {
        self.isSelectedPaoPaoView = YES;
        
        
        //TODO: 占用订单
        
        [SVProgressHUD show];
        [NetworkingManager OccupyOrderOrCancelByUID:detailInfo[@"uid"] engineerid:[AccountManager getTokenID] orderstate:@"1" WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.isSelectedPaoPaoView = NO;
            
            if ([responseObject[@"success"] integerValue] == 1) {
                
                [SVProgressHUD dismiss];
                UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Order" bundle:nil];
                
                OrderDetailViewController *detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
                
                BNPosition *originPostion = [[BNPosition alloc] init];
                originPostion.x = self.currentUserLocation.location.coordinate.longitude;
                originPostion.y = self.currentUserLocation.location.coordinate.latitude;
                
                detail.originalPostion = originPostion;
                
                BNPosition *destinationPostion = [[BNPosition alloc] init];
                destinationPostion.x = [detailInfo[@"longitude"] doubleValue];
                destinationPostion.y = [detailInfo[@"latitude"] doubleValue];
                
                detail.destinationPosition = destinationPostion;
                detail.info = detailInfo;
                
                detail.delegate = self;
                detail.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detail animated:YES];
            } else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.isSelectedPaoPaoView = NO;
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
            
        }];
        
    }
    
    [self.nearestOrderView removeFromSuperview];
    self.nearestOrderView = nil;

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
        label.textColor = [UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0];
        
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
