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
typedef enum ServiceType: NSUInteger {
    TV,
    BROADBAND
} ServiceType;

@interface OrderMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>


@property (nonatomic, strong) BMKGeoCodeSearch *geocodesearch;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) CustomPointAnnotation *pointAnnotation;

@property (nonatomic, strong) NSMutableArray *pointAnnotations;



@property (nonatomic, copy) NSString *cityName;


@property (nonatomic, strong) NSMutableArray *Orders;


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
    
    _mapView =[[BMKMapView alloc] initWithFrame:self.view.bounds];
    
    self.view = _mapView;
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

-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _geocodesearch.delegate = self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (!locationAllowed) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"没有打开访问地图权限,请在设置-隐私里切换应用位置访问权限" preferredStyle:UIAlertControllerStyleAlert];
        
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
        
        
        //添加标注
//        [self addPointAnnotation];
        
        self.Orders = [ @[@{@"latitude":@30.576,@"longitude":@104.069,@"name":@"李敏",@"address":@"高新区环球中心乐天百货旁边LOL工作室0",@"subscribe":@"01-01 09:00 - 10:10",@"type":@0},
                          @{@"latitude":@30.578,@"longitude":@104.071,@"name":@"董帅",@"address":@"高新区环球中心乐天百货旁边LOL工作室1",@"subscribe":@"01-01 09:00 - 10:10",@"type":@0},
                          
                          @{@"latitude":@30.574,@"longitude":@104.063,@"name":@"杨敏",@"address":@"高新区环球中心乐天百货旁边",@"subscribe":@"01-01 09:00 - 10:10",@"type":@1},
                          
                          @{@"latitude":@30.579,@"longitude":@104.065,@"name":@"罗祖根",@"address":@"高新区环球中心乐天百货旁边",@"subscribe":@"01-01 09:00 - 10:10",@"type":@0},
                          
                          @{@"latitude":@30.577,@"longitude":@104.069,@"name":@"于波",@"address":@"高新区环球中心乐天百货旁边",@"subscribe":@"01-01 09:00 - 10:10",@"type":@1}
                          
                          ] mutableCopy];
        
        [self addPointAnnotations];

    }
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
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
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    if (!self.cityName || [self.cityName isEqualToString: @""]) {
        [self getCurrentCityByLatitude:userLocation.location.coordinate.latitude Longitude:userLocation.location.coordinate.longitude];
        
    }
   
    
    
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

//添加标注
- (void)addPointAnnotation
{
    
    NSMutableArray *addresses = [ @[@"环球中心",@"世纪城"] mutableCopy];
    
    
    
    [addresses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        annotation.tag = idx;
        CLLocationCoordinate2D coor;
        if (idx == 0) {
            coor.latitude = 30.577 ;
            coor.longitude = 104.069;
        } else{
            coor.latitude = 30.777 ;
            coor.longitude = 104.069;

        }
        annotation.coordinate = coor;
        //        _pointAnnotation.title = @"test";
        //        _pointAnnotation.subtitle = @"此Annotation可拖拽!";
        [_mapView addAnnotation:annotation];
        
    }];
}

//添加标注s
-(void)addPointAnnotations{
    
  
    self.pointAnnotations = [NSMutableArray array];
    [self.Orders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *temp = obj;
        
        CustomPointAnnotation *annotation = [[CustomPointAnnotation alloc] init];
        annotation.tag = idx;
        CLLocationCoordinate2D coor;
//        double latitude = [temp[@"latitude"] doubleValue];
//        double longitude = [temp[@"long"]]
        coor.latitude = [temp[@"latitude"] doubleValue];
        coor.longitude =  [temp[@"longitude"] doubleValue];
       
        annotation.coordinate = coor;
        //        _pointAnnotation.title = @"test";
        //        _pointAnnotation.subtitle = @"此Annotation可拖拽!";
        [self.pointAnnotations addObject:annotation];
        
    }];
    
    [_mapView addAnnotations:self.pointAnnotations];

    
//
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    CustomPointAnnotation *temp_annotation = (CustomPointAnnotation *)annotation;
    
    NSDictionary *data = self.Orders[temp_annotation.tag];
    NSString *name = data[@"name"];
    NSString *address = data[@"address"];
    NSString *subscribe = data[@"subscribe"];
    ServiceType type = [data[@"type"] integerValue];
    
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
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void)mapStatusDidChanged:(BMKMapView *)mapView{
    
    if (mapView.zoomLevel < 12) {
        [mapView removeAnnotations:mapView.annotations];
    } else{
        if (mapView.annotations.count == 0) {
            [mapView addAnnotations:self.pointAnnotations];
        }
    }
}

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
    
}


@end
