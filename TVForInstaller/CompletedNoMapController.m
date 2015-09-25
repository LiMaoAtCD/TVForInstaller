//
//  CompletedNoMapController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import "CompletedNoMapController.h"
#import "CompletedNoMapTableViewCell.h"
#import "ComminUtility.h"
#import "CompletedNoMapDetailController.h"
#import "NetworkingManager.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>


@interface CompletedNoMapController ()



@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CompletedNoMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [ComminUtility configureTitle:@"已完成订单" forViewController:self];
    
    
    
    self.currentPage = 1;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        __strong typeof (self) strongSelf = weakSelf;
    
        [strongSelf fetchFinishedOrders:strongSelf.currentPage];
    }];
    
    [self.tableView.header beginRefreshing];
    
}

-(void)fetchFinishedOrders:(NSInteger)pageNumber{
    
        //请求数据
        [NetworkingManager FetchCompletedOrderByPageNumber:pageNumber WithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self handleResponseObject:responseObject];
            
        } failedHander:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.header endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"网络出错"];
        }];

}

-(void)handleResponseObject:(id)responseObject{
    
    if ([responseObject[@"success"] integerValue] == 1) {
        
        if (self.currentPage == 1) {
            
            [self.tableView.header endRefreshing];

            //header 刷新
            NSArray *temp = responseObject[@"data"];
            if (temp.count > 0) {
                
                self.dataSource = [temp mutableCopy];
                [self.tableView reloadData];
                
                
            } else{
                //没有数据
            }
        } else{
            // footer 刷新
            
            
        }
        
    
        
    } else{
        //出错
    }

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
    CompletedNoMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompletedNoMapTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *todayString = [formatter stringFromDate:today];
    
    if ([todayString isEqualToString: self.dataSource[indexPath.row][@"orderDate"] ]) {
        cell.timeLabel.text = @"今天";
    } else{
        cell.timeLabel.text = self.dataSource[indexPath.row][@"orderDate"];

    }
    
    
    cell.completedNumberLabel.text = self.dataSource[indexPath.row][@"finishedOrderNum"];
    cell.scanNumberLabel.text = self.dataSource[indexPath.row][@"scanCodeNum"];
    cell.totalCostLabel.text = self.dataSource[indexPath.row][@"totalFee"];

    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
    
    
    CompletedNoMapDetailController *detailVC = [sb instantiateViewControllerWithIdentifier:@"CompletedNoMapDetailController"];
    
    detailVC.infoDictionary = self.dataSource[indexPath.row];
    
    
    [self.navigationController showViewController:detailVC sender:self];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
