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
#import <JGProgressHUD.h>
@interface OrderMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKCloudSearchDelegate>


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
 *  当前城市名
 */
@property (nonatomic, copy) NSString *cityName;

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
    
    //获取数据
    
//    self.Orders = [ @[@{@"latitude":@30.576,@"longitude":@104.069,@"name":@"李敏",@"address":@"高新区环球中心乐天百货旁边LOL工作室0",@"subscribe":@"01-01 09:00 - 10:10",@"type":@0,@"running":@"SSA00001",@"telephone":@"13513833324"},
//                      @{@"latitude":@30.578,@"longitude":@104.071,@"name":@"董帅",@"address":@"高新区环球中心乐天百货旁边LOL工作室1",@"subscribe":@"01-01 09:00 - 10:10",@"type":@0,@"running":@"SSA00002",@"telephone":@"13513833324"},
//                      
//                      @{@"latitude":@30.574,@"longitude":@104.063,@"name":@"杨敏",@"address":@"高新区环球中心乐天百货旁边",@"subscribe":@"01-01 09:00 - 10:10",@"type":@1,@"running":@"SSA00003",@"telephone":@"13513833324"},
//                      
//                      @{@"latitude":@30.579,@"longitude":@104.065,@"name":@"罗祖根",@"address":@"高新区环球中心乐天百货旁边",@"subscribe":@"01-01 09:00 - 10:10",@"type":@0,@"running":@"SSA00004",@"telephone":@"13513833324"},
//                      
//                      @{@"latitude":@30.577,@"longitude":@104.069,@"name":@"于波",@"address":@"高新区环球中心乐天百货旁边",@"subscribe":@"01-01 09:00 - 10:10",@"type":@1,@"running":@"SSA00005",@"telephone":@"13513833324"},
//                      @{@"latitude":@30.590,@"longitude":@104.071,@"name":@"于波",@"address":@"高新区环球中心乐天百货旁边",@"subscribe":@"01-01 09:00 - 10:10",@"type":@1,@"running":@"SSA00005",@"telephone":@"13513833324"}
//                      
//                      ] mutableCopy];
    
    //如果有订单还未完成
    self.isOrderGoing = [AccountManager existOngoingOrder];
    if (!self.isOrderGoing) {
//        [self addPointAnnotations];
//        [self noteOngoingOrderView:NO];
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

-(void)getCurrentCityByLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude{
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
//    if (_coordinateXText.text != nil && _coordinateYText.text != nil) {
//        pt = (CLLocationCoordinate2D){[_coordinateYText.text floatValue], [_coordinateXText.text floatValue]};
//    }
//    
    pt = (CLLocationCoordinate2D){latitude,longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
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
        //        _pointAnnotation.title = @"test";
        //        _pointAnnotation.subtitle = @"此Annotation可拖拽!";
        [self.pointAnnotations addObject:annotation];
        
    }];
    
    [_mapView addAnnotations:self.pointAnnotations];
    
    
    //
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
    
    if (!self.cityName || [self.cityName isEqualToString: @""]) {
        [self getCurrentCityByLatitude:userLocation.location.coordinate.latitude Longitude:userLocation.location.coordinate.longitude];
    }
    self.currentUserLocation = userLocation;
    self.currentUserLocation.title = nil;
    [self SearchNearByOrders];

}

- (void)didStopLocatingUser{
//    NSLog(@"didStopLocatingUser");
    self.isStopLocatingUser = YES;
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    array = [NSArray arrayWithArray:_mapView.overlays];
//    [_mapView removeOverlays:array];
    if (error == 0) {
//        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//        item.coordinate = result.location;
//        item.title = result.address;
//        [_mapView addAnnotation:item];
//        _mapView.centerCoordinate = result.location;
//        NSString* titleStr;
//        NSString* showmeg;
//        titleStr = @"反向地理编码";
//        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        [myAlertView show];
        self.cityName = result.addressDetail.city;

        
    }
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    CustomPointAnnotation *temp_annotation = (CustomPointAnnotation *)annotation;
    
    NSDictionary *data = self.Orders[temp_annotation.tag];
    NSString *name = data[@"name"];
    NSString *address = data[@"detailAddress"];
    NSString *subscribe = data[@"subscribe"];
    ServiceType type = [data[@"servicetype"] integerValue];
    
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
    NSLog(@"%ld",(long)view.tag);
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Order" bundle:nil];
    
    OrderDetailViewController *detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    NSDictionary *detailInfo = self.Orders[view.tag];
    
    if ([detailInfo[@"type"] integerValue] == 0) {
        detail.type = TV;
    } else{
        detail.type = BROADBAND;
    }
    
    detail.name = detailInfo[@"name"];
    detail.telphone = detailInfo[@"telephone"];
    detail.address = detailInfo[@"detailAddress"];
    detail.runningNumber = detailInfo[@"running"];
    detail.date = detailInfo[@"subscribe"];
//    detail.originalPostion = detailInfo[@"la"]
    BNPosition *originPostion = [[BNPosition alloc] init];
    originPostion.x = self.currentUserLocation.location.coordinate.longitude;
    originPostion.y = self.currentUserLocation.location.coordinate.latitude;

    detail.originalPostion = originPostion;
    
    BNPosition *destinationPostion = [[BNPosition alloc] init];
    destinationPostion.x = [detailInfo[@"location"][0] doubleValue];
    destinationPostion.y = [detailInfo[@"location"][1] doubleValue];
    
    detail.destinationPosition = destinationPostion;
    detail.info = detailInfo;
    
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void)mapStatusDidChanged:(BMKMapView *)mapView{
    
    if (mapView.zoomLevel < 12) {
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
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请在设置-隐私-定位里打开极客快服访问权限" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
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
    self.isOrderGoing = [AccountManager existOngoingOrder];
    if (!self.isOrderGoing) {
        
        
        //是否已经在请求(不发出多次请求)
        if (!self.isFetchOrder) {
            self.isFetchOrder = YES;
            
            NSString *location = [NSString stringWithFormat:@"%.6f,%.6f", self.currentUserLocation.location.coordinate.longitude, self.currentUserLocation.location.coordinate.latitude];
            [NetworkingManager fetchNearbyOrdersByAK:@"GZXZUzmp3ZXLWYfEvQN6rbOr" geoTableId:114231 location:location radius:1000 tags:@"Marcoli" pageIndex:0 pageSize:10 WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *results = responseObject;
                
                self.Orders = results[@"contents"];
                
                [self addPointAnnotations];
                [self noteOngoingOrderView:NO];

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
@end
