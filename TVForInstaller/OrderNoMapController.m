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
#import "NetworkingManager.h"
#import <MJRefresh.h>

@interface OrderNoMapController ()

@property (nonatomic, strong) NSMutableArray *dataSource;


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
    
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            cell.orderImageView.image = [UIImage imageNamed:@"ui08_tv"];
        }
            break;

        case 2:
        {
            cell.orderImageView.image = [UIImage imageNamed:@"ui08_tv"];
        }
            break;
        default:
            break;
    }
    
    //姓名
    cell.nameLabel.text = self.dataSource[indexPath.row][@"name"];
    
    cell.cellphoneLabel.text = self.dataSource[indexPath.row][@"phone"];
    
    cell.addressLabel.text = self.dataSource[indexPath.row][@"homeAddress"];

    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrderDetailNoMapViewController *detail = [sb instantiateViewControllerWithIdentifier:@"OrderDetailNoMapViewController"];
    
    detail.order = self.dataSource[indexPath.row];
    detail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];

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
