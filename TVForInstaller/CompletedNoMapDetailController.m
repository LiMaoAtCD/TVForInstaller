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

#import "OrderTypesViewController.h"
#import "OrderTypeNoScanViewController.h"


@interface CompletedNoMapDetailController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CompletedNoMapDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isTodayOrder) {
        [ComminUtility configureTitle:self.infoDictionary[@"orderDate"] forViewController:self];

    } else{
        [ComminUtility configureTitle:@"今日订单" forViewController:self];

    }
    
    
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
    
    
    cell.starImageView.image = [UIImage imageNamed:@"ui08_star1"];
    
    if (![self.dataSource[indexPath.row][@"deviceTag"] isKindOfClass:[NSNull class]]) {
        cell.scanLabel.hidden= NO;
    } else{
        cell.scanLabel.hidden= YES;
    }
    
//    0待分配（没有分配工程师的状态）、1已分配（可以查看到分配的工程师）、2已提交待付款（订单已提交等待支付状态）、3已完成
    
    if ([self.dataSource[indexPath.row][@"orderState"] integerValue] == 2) {
        cell.yuanLabel.textColor = [UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0];
        cell.payTypeLabel.textColor = [UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0];
        cell.costLabel.textColor = [UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0];
        cell.payTypeLabel.text = @"等待支付";

    } else if ([self.dataSource[indexPath.row][@"orderState"] integerValue] == 3) {
        cell.payTypeLabel.text = @"已支付";

        cell.yuanLabel.textColor = [UIColor blackColor];
        cell.payTypeLabel.textColor = [UIColor blackColor];
        cell.costLabel.textColor = [UIColor blackColor];
    }
    
    
    if (![self.dataSource[indexPath.row][@"totalFee"] isKindOfClass:[NSNull class]]) {
        cell.costLabel.text = self.dataSource[indexPath.row][@"totalFee"];
    }
    
    cell.orderIDLabel.text = self.dataSource[indexPath.row][@"id"];
    
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.dataSource[indexPath.row][@"orderState"] integerValue] == 2) {
        if ([self.dataSource[indexPath.row][@"deviceTag"] isKindOfClass:[NSNull class]] || self.dataSource[indexPath.row][@"deviceTag"] == nil) {
            //进入没有扫码支付的界面
            
            
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];

            OrderTypeNoScanViewController *scanVC = [sb instantiateViewControllerWithIdentifier:@"OrderTypeNoScanViewController"];
               scanVC.orderID = self.dataSource[indexPath.row][@"id"];
            scanVC.isFromCompletionList = YES;
            [self.navigationController pushViewController:scanVC animated:YES];
        } else{
            //进入有扫码支付的界面
            UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            OrderTypesViewController *orderVC = [sb instantiateViewControllerWithIdentifier:@"OrderTypesViewController"];
            orderVC.qrcode = self.dataSource[indexPath.row][@"deviceTag"];
            orderVC.cost = self.dataSource[indexPath.row][@"totalFee"];
            orderVC.orderID = self.dataSource[indexPath.row][@"id"];
            orderVC.isFromCompletionList = YES;

            [self.navigationController pushViewController:orderVC animated:YES];
        }
    }
}


@end
