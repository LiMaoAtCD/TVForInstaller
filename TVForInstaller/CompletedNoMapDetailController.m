//
//  CompletedNoMapDetailController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "CompletedNoMapDetailController.h"
#import "CompletedNoMapDetailCell.h"
#import "ComminUtility.h"

#import "NetworkingManager.h"
#import <SVProgressHUD.h>


@interface CompletedNoMapDetailController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CompletedNoMapDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [ComminUtility configureTitle:self.infoDictionary[@"orderDate"] forViewController:self];
    
    
    [SVProgressHUD show];
    [NetworkingManager fetchFinishedOrdersByDate:self.infoDictionary[@"orderDate"] WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];

        if ([responseObject[@"success"] integerValue] == 1) {
            //成功
            
            self.dataSource = [responseObject[@"data"] mutableCopy];
            
            [self.tableView reloadData];
            
        } else {
            
        }
        
        
    } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络出错"];

    }];
    
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompletedNoMapDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompletedNoMapDetailCell" forIndexPath:indexPath];
    

//    deviceTag = "<null>";
//    homeAddress = "\U6210\U90fd\U5e02\U9ad8\U65b0\U533a\U5965\U514b\U65af\U5e7f\U573a";
//    id = 8a8080be4fda3fd6014fde2fa9ed002f;
//    latitude = "30.58204899495";
//    longitude = "104.06927809813";
//    name = "\U53e4\U7b71\U5f64\U5f64";
//    orderState = 2;
//    orderTime = "2015-09-24 10:01:34";
//    orderType = 0;
//    phone = 13548097234;
//    totalFee = "<null>";
    
    
    cell.nameLabel.text = self.dataSource[indexPath.row][@"name"];
    cell.cellphoneLabel.text = self.dataSource[indexPath.row][@"phone"];
    
    if ([self.dataSource[indexPath.row][@"deviceTag"] isKindOfClass:[NSNull class]] || self.dataSource[indexPath.row][@"deviceTag"] == nil) {
        cell.scanLabel.hidden = YES;
    } else{
        cell.scanLabel.hidden = NO;
    }
    cell.addressLabel.text = self.dataSource[indexPath.row][@"homeAddress"];
    
    
    NSString *orderTime = self.dataSource[indexPath.row][@"orderTime"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:orderTime];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *convertible = [formatter stringFromDate:date];
    
    cell.timeLabel.text = convertible;
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



@end
