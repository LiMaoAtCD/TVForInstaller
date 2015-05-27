//
//  UnSubmitViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/25.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "UnSubmitViewController.h"
#import "UnSubmitCell.h"
#import "SavedOrderCell.h"
#import "OrderDetailController.h"

#import "NetworkingManager.h"
#import "UIColor+HexRGB.h"
#import "AccountManager.h"
#import <MJRefresh.h>

@interface UnSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *orderList;
@property (nonatomic,strong) NSArray *localOrders;
@property (nonatomic,assign) BOOL hasRefresh;
@end

@implementation UnSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([AccountManager isLogin]) {
        
        [self.tableView addLegendHeaderWithRefreshingBlock:^{
            [self fetchOrder];
            
        }];
    }
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (!self.hasRefresh) {
        self.hasRefresh = YES;
        [self.tableView.header beginRefreshing];

    }
}
-(void)fetchOrder{
    [NetworkingManager fetchOrderwithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"success"] integerValue] ==0) {

            
        } else{
            
            NSArray *data = responseObject[@"obj"];
            NSLog(@"received data: %@",data);
            
            if (data.count >0) {
                
                self.orderList = [data mutableCopy];
                [self.tableView reloadData];
            } else{
            
            }
            
            [self.tableView.header endRefreshing];
        }
        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];

    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -tableView delegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.orderList.count;

    } else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UnSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnSubmitCell" forIndexPath:indexPath];
        
        [cell.cellphoneButton addTarget:self action:@selector(clickToCall:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.cellphoneButton.tag = indexPath.row;
        
        //    //TODO:坐式
        //    if (<#condition#>) {
        //        <#statements#>
        //    }
        cell.TVImageView.image = [UIImage imageNamed:@"zuoshi"];
        cell.TVTypeLabel.text = @"坐式";
        cell.TVTypeLabel.textColor = [UIColor colorWithHex:@"00c3d4"];
        
        //    cell.TVImageView.image = [UIImage imageNamed:@"guashi"];
        //    cell.TVTypeLabel.text = @"挂式";
        //    cell.TVTypeLabel.textColor = [UIColor colorWithHex:@"cd7ff5"];
        
        
        [cell.cellphoneButton setTitle:self.orderList[indexPath.row][@"phone"] forState:UIControlStateNormal];
        [cell.noUseButton addTarget:self action:@selector(clickNoUseOrder:) forControlEvents:UIControlEventTouchUpInside];
        cell.noUseButton.tag = indexPath.row;
        [cell.retreatButton addTarget:self action:@selector(clickRetreatOrder:) forControlEvents:UIControlEventTouchUpInside];
        cell.retreatButton.tag = indexPath.row;
        
        
        cell.nameLabel.text = self.orderList[indexPath.row][@"hoster"];
        cell.tvBrandLabel.text  =self.orderList[indexPath.row][@"brand"];
        cell.tvSizeLabel.text = self.orderList[indexPath.row][@"size"];
        cell.customerAddress.text =self.orderList[indexPath.row][@"address"];
        
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        NSString *dateString = [formatter stringFromDate:date];
        cell.dateLabel.text= dateString;
        
        
        
        return cell;
    } else{
        
        SavedOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedOrderCell" forIndexPath:indexPath];
        
        
        
        
        return cell;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Order" bundle:nil];
    OrderDetailController *detail =[sb instantiateViewControllerWithIdentifier:@"OrderDetailController"];
    
    detail.hidesBottomBarWhenPushed = YES;
    
   

    if (indexPath.section ==0) {
        detail.orderInfo = self.orderList[indexPath.row];
    }else{
        detail.orderInfo = self.localOrders[indexPath.row];
    }
    
    
    [self.navigationController showViewController:detail sender:self];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        return 182.0;
    } else{
        return 115.0;

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"新的订单";
    } else{
        return @"已保存订单";
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel *label=  [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    
    label.font = [UIFont boldSystemFontOfSize:12.0];
    
    [view addSubview:label];
    
    return  view;
    
}

#pragma mark - actions


-(void)clickToCall:(UIButton*)btn{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:self.orderList[btn.tag][@"phone"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //TODO: 拨打电话
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:13568927473"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.orderList[btn.tag][@"phone"]]]];
        
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)clickNoUseOrder:(UIButton *)button{
    NSLog(@"nouse");
}

-(void)clickRetreatOrder:(UIButton *)button{
    NSLog(@"retreat");
}

@end
