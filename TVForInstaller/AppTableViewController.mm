//
//  AppTableViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/20.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "AppTableViewController.h"

#import "ComminUtility.h"

#import "AppOneInstallCell.h"
#import "AppCollectionTableCell.h"
#import "APPCollectionViewCell.h"

#import "NetworkingManager.h"
#import <JGProgressHUD.h>

#import <UIImageView+WebCache.h>

#import <MJRefresh.h>
#import "DLNAManager.h"

typedef void(^alertBlock)(void);


@interface AppTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic,strong) NSMutableArray *appLists;


@end

@implementation AppTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [ComminUtility configureTitle:@"应用" forViewController:self];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.translucent = NO;
    
    __weak AppTableViewController *weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf fetchApplicationList];

    }];
    
    [self.tableView.header beginRefreshing];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


-(void)fetchApplicationList{
    
    
//    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
//    hud.textLabel.text = @"正在获取应用列表";
//    [hud showInView:self.tableView animated:YES];
    
    
    
    [NetworkingManager fetchApplicationwithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"success"] integerValue] == 0) {
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [hud dismiss];
//            });
            
            
        } else{
            //获取成功
            
            
//            [hud dismiss];
            
            NSArray *temp = responseObject[@"obj"];
            [self dealResponseData:temp];

            
        }
        [self.tableView.header endRefreshing];

        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud dismiss];
        [self.tableView.header endRefreshing];

    }];
}

-(void)dealResponseData:(NSArray *)obj{

    if (obj.count >0) {
        
        _appLists = [obj mutableCopy];
        
        [self.tableView reloadData];
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source &delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _appLists.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
        AppOneInstallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppOneInstallCell" forIndexPath:indexPath];
        [cell.OneInstall addTarget:self action:@selector(onekeyInstall) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else{
        AppCollectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCollectionTableCell" forIndexPath:indexPath];
        
        cell.collectionView.tag = indexPath.section -1;
        
        return cell;

    }
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
    if (section ==0 ) {
        return nil;
    } else{
        return _appLists[section -1][@"classify"];
    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 20)];
    label.text = [self tableView:self.tableView titleForHeaderInSection:section];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    
    UIView *view = [[UIView alloc] init];
    
    [view addSubview:label];
    
    return view;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 83;
    }else {
        return 150;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}





#pragma mark - colleciton dataSource & delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSArray *softList = _appLists[collectionView.tag][@"softlist"];
    return softList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    APPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"APPCollectionViewCell" forIndexPath:indexPath];
    
    
    NSString *url = _appLists[collectionView.tag][@"softlist"][indexPath.row][@"softicon"];
    
    NSURL *imageURL = [NSURL URLWithString:url];
    [cell.appImageView sd_setImageWithURL:imageURL placeholderImage:nil];
    
    cell.appNameLabel.text =  _appLists[collectionView.tag][@"softlist"][indexPath.row][@"softname"];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    NSString *softwareAddress = _appLists[collectionView.tag][@"softlist"][indexPath.row][@"softaddr"];

    NSString *ipAddress = [[DLNAManager DefaultManager] getCurRenderIpAddress];
    
    if ([ipAddress isEqualToString:@""]||
        ipAddress == nil) {
        //TODO::
        [self alertWithMessage:@"无法获取到设备" withCompletionHandler:^{}];
    }else{
        
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        hud.textLabel.text = [NSString stringWithFormat:@"%@ 即将安装", _appLists[collectionView.tag][@"softlist"][indexPath.row][@"softname"]];
        hud.indicatorView=  nil;
        [hud showInView:self.view];
        
        [NetworkingManager selectAppToInstall:softwareAddress ipaddress:ipAddress WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
//                id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments|NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:&error];
                NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                NSLog(@"response: %@",result);
                
                if ([result isEqualToString:@"success"]) {
                    hud.textLabel.text = @"安装请求成功";
                    hud.indicatorView = nil;
                } else if([result isEqualToString:@"busy"]){
                    hud.textLabel.text = @"电视正忙，请稍后再试";
                    hud.indicatorView = nil;
                }
                
                [hud dismissAfterDelay:2];
            });

            
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.textLabel.text = @"安装请求失败～";
                [hud dismissAfterDelay:2];
            });
        }];
    }
}

-(void)onekeyInstall{
    
    NSString *ipAddress = [[DLNAManager DefaultManager] getCurRenderIpAddress];
    
    if ([ipAddress isEqualToString:@""]||
        ipAddress == nil) {
        //TODO::
        [self alertWithMessage:@"无法获取到设备" withCompletionHandler:^{}];
    }else{
        
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        hud.textLabel.text = @"即将安装";
        hud.indicatorView =  nil;
        [hud showInView:self.view];
        [NetworkingManager OneKeyInstall:ipAddress WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                 NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([result isEqualToString:@"success"]) {
                    hud.textLabel.text = @"安装请求成功";
                    hud.indicatorView = nil;
                } else if([result isEqualToString:@"busy"]){
                    hud.textLabel.text = @"电视正忙，请稍后再试";
                    hud.indicatorView = nil;
                }


                
                
                [hud dismissAfterDelay:2];
            });
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                hud.textLabel.text = @"安装请求失败～";
                [hud dismissAfterDelay:2];
            });
        }];
    }
}


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
