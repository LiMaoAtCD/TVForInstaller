//
//  CompleteTableViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/26.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "CompleteTableViewController.h"
#import "CompleteCell.h"

#import "NetworkingManager.h"
#import <MJRefresh.h>
#import <JGProgressHUD.h>
#import "UIColor+HexRGB.h"

@interface CompleteTableViewController ()

@property (nonatomic,assign)NSInteger currentRow;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation CompleteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = nil;
    
    [self fetchCompletionOrder];

    __weak CompleteTableViewController *weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf fetchCompletionOrder];
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf fetchMoreCompletionOrder];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)fetchCompletionOrder{
    
    [NetworkingManager fetchCompletedOrderListByRow:0 withComletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == 0) {
            
            JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
            hud.textLabel.text = @"获取失败";
            hud.indicatorView = nil;
            [hud showInView:self.tableView];
            
            [hud dismissAfterDelay:1];
            
        } else{
            NSArray *array = responseObject[@"obj"];
            _currentRow = [responseObject[@"attributes"][@"row"] integerValue];
            if (array.count > 0) {
                self.data = [array mutableCopy];
                [self.tableView reloadData];
            }else{
                JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
                hud.textLabel.text = @"没有数据";
                hud.indicatorView = nil;
                [hud showInView:self.tableView];
                
                [hud dismissAfterDelay:1];
            }
            
        }
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
    
}

-(void)fetchMoreCompletionOrder{
    if (_currentRow == 0) {
        [self fetchCompletionOrder];
    } else{
        [NetworkingManager fetchCompletedOrderListByRow:_currentRow withComletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject[@"success"] integerValue] == 0) {
                
                JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
                hud.textLabel.text = @"获取失败";
                hud.indicatorView = nil;
                [hud showInView:self.tableView];
                
                [hud dismissAfterDelay:1];
                
            } else{
                NSArray *array = responseObject[@"obj"];
                _currentRow = [responseObject[@"attributes"][@"row"] integerValue];
                if (array.count > 0) {
                    [self.data addObjectsFromArray:array];
                    [self.tableView reloadData];
                }
                
                
            }
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        }];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompleteCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if ([self.data[indexPath.row][@"type"] integerValue] == 0) {
        cell.tvImageView.image = [UIImage imageNamed:@"zuoshi"];
        cell.tvTypeLabel.text = @"坐式";
        cell.tvTypeLabel.textColor = [UIColor colorWithHex:@"00c3d4"];

    } else{
        cell.tvImageView.image = [UIImage imageNamed:@"guashi"];
        cell.tvTypeLabel.text = @"挂式";
        cell.tvTypeLabel.textColor = [UIColor colorWithHex:@"cd7ff5"];

    }
    

    cell.nameLabel.text = self.data[indexPath.row][@"host"];
    
    
    cell.cellphoneLabel.text = self.data[indexPath.row][@"phone"];
    cell.addressLabel.text = self.data[indexPath.row][@"address"];
    
    cell.dateLabel.text = self.data[indexPath.row][@"createdate"];
    
    cell.tvSizeLabel.text = self.data[indexPath.row][@"size"];
    cell.tvBrandLabel.text = self.data[indexPath.row][@"brand"];
    
    if ([self.data[indexPath.row][@"status"] integerValue] == 4) {
        //等待支付
        cell.payStatus.text =@"等待支付";

        
    } else if ([self.data[indexPath.row][@"status"] integerValue] == 5){
        //已完成
        cell.payStatus.text =@"已完成";

    }
    
    if ([self.data[indexPath.row][@"paymodel"] integerValue] == 0) {
        //等待支付
        cell.paymodelLabel.text =@"现金";
        
        
    } else if ([self.data[indexPath.row][@"paymodel"] integerValue] == 1){
        //已完成
        cell.paymodelLabel.text =@"微信";
        
    }
    
    if (indexPath.row %2 == 0) {
        cell.backgroundColor = [UIColor colorWithHex:@"00c3d4" alpha:0.3];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
