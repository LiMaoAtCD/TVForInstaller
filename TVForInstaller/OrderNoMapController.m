//
//  OrderNoMapController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "OrderNoMapController.h"
#import "ComminUtility.h"
#import "OrderNoMapCell.h"
#import "OrderDetailNoMapViewController.h"
#import "OrderDetailFixViewController.h"
#import "NetworkingManager.h"
#import <MJRefresh.h>

#import <CoreLocation/CoreLocation.h>
#import "BNCoreServices.h"



@interface OrderNoMapController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, strong) BNPosition *currentPostion;

@end

@implementation OrderNoMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ComminUtility configureTitle:@"订单" forViewController:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf refreshToDayOrders];
    }];
    

    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.distanceFilter = kCLDistanceFilterNone;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // 获取经纬度
    NSLog(@"纬度:%f",locations[0].coordinate.latitude);
    NSLog(@"经度:%f",locations[0].coordinate.longitude);
    // 停止位置更新
    [manager stopUpdatingLocation];
    
    BNPosition *originPostion = [[BNPosition alloc] init];
    originPostion.x = locations[0].coordinate.longitude;
    originPostion.y = locations[0].coordinate.latitude;
    
    self.currentPostion = originPostion;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [_manager startUpdatingLocation];
        
    } else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"如需开启位置导航，请在设置-隐私开启地理位置访问" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }


}

-(void)refreshToDayOrders{
    //TODO：
    [NetworkingManager fetchTodayOrdersWithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];

        if ([responseObject[@"success"] integerValue] == 1) {
            //success
            
            NSArray *temp = responseObject[@"data"];
            
            if (temp.count > 0) {
                
                self.dataSource = [temp mutableCopy];
                
            } else{
                //没有
                self.dataSource = [NSMutableArray array];

            }
            
            [self.tableView reloadData];
            
        } else{
            
        }
        
        
    } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self.tableView.header endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderNoMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderNoMapCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    

    
    //订单时间
    cell.orderTimeLabel.text = self.dataSource[indexPath.row][@"orderTime"];
    
    //订单类型
    NSInteger type = [self.dataSource[indexPath.row][@"orderType"] integerValue];
    switch (type) {
        case 0:
        {
            cell.orderImageView.image = [UIImage imageNamed:@"ui08_tv"];
        }
            break;
        case 1:
        {
            cell.orderImageView.image = [UIImage imageNamed:@"ui08_broadband"];
        }
            break;

        case 2:
        {
            cell.orderImageView.image = [UIImage imageNamed:@"ui08_service"];
        }
            break;
        default:
            break;
    }
    
    //
    cell.nameLabel.text = self.dataSource[indexPath.row][@"name"];
    cell.cellphoneLabel.text = self.dataSource[indexPath.row][@"phone"];
    cell.addressLabel.text = self.dataSource[indexPath.row][@"homeAddress"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([self.dataSource[indexPath.row][@"orderType"] integerValue] == 2) {
            //维修
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OrderDetailFixViewController *detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailFixViewController"];
        
        detail.originPostion = self.currentPostion;
        detail.order = self.dataSource[indexPath.row];
        detail.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detail animated:YES];
    } else{
        //安装
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OrderDetailNoMapViewController *detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailNoMapViewController"];
        
        detail.originPostion = self.currentPostion;
        detail.order = self.dataSource[indexPath.row];
        detail.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    OrderDetailNoMapViewController *detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailNoMapViewController"];
//    
//    detail.originPostion = self.currentPostion;
//    detail.order = self.dataSource[indexPath.row];
//    detail.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:detail animated:YES];

}


@end
