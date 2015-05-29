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

#import "OrderDataManager.h"
#import "Order.h"

#import <JGProgressHUD.h>

@interface UnSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *orderList;
@property (nonatomic,strong) NSMutableArray *localOrders;
@property (nonatomic,assign) BOOL hasRefresh;

@end

@implementation UnSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.localOrders = [@[] mutableCopy];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRefreshList) name:@"kSavedOrderToLocal" object:nil];

    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [self fetchLocalOrder];
        [self fetchOrder];
    }];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (!self.hasRefresh && [AccountManager isLogin]) {
        self.hasRefresh = YES;
        [self.tableView.header beginRefreshing];
        
       
        
        
        

    }
}
-(void)needRefreshList{
    self.hasRefresh = NO;
}

-(void)fetchOrder{
    
    
    [NetworkingManager fetchOrderwithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"success"] integerValue] ==0) {

        } else{
            
            NSArray *data = responseObject[@"obj"];
            NSLog(@"received data: %@",data);
            
            
            if (data.count > 0) {
                
                self.orderList = [data mutableCopy];
                NSMutableArray *toDelete = [NSMutableArray array];

                
                [self.localOrders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSDictionary *dictionary = obj;
                    
                    [self.orderList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                       
                        if ([self.orderList[idx][@"orderid"] isEqualToString:dictionary[@"orderid"]]) {
                            NSLog(@"此订单已经保存");
                            
                            [toDelete addObject:obj];
                            
                        }
                    }];
                    
                }];
                
                [self.orderList removeObjectsInArray:toDelete];
                
                [self.tableView reloadData];

                
                
            } else{
            
            }
            
            [self.tableView.header endRefreshing];
        }
        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];

    }];

}

-(void)fetchLocalOrder{
    
    [self.localOrders removeAllObjects];
    [self.orderList removeAllObjects];

    NSManagedObjectContext *context = [[OrderDataManager sharedManager] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:context];
    
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"orderid" ascending:NO];
    
    NSError *error =  nil;
    
    request.sortDescriptors = @[sorter];
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error: %@",[error description]);
    }else{
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Order *order = obj;
            NSLog(@"order: %@",order);
            
            NSDictionary *dic = @{@"address":order.address,
                                  @"brand":order.brand,
                                  @"createdate":order.createdate,
                                  @"hoster":order.hoster,
                                  @"type":order.type,
                                  @"phone":order.phone,
                                  @"size":order.size,
                                  @"orderid":order.orderid
                                  };
            
            [self.localOrders addObject:dic];
            
            
        }];
    }
    
    

    
    
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
        return self.localOrders.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UnSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnSubmitCell" forIndexPath:indexPath];
        
        [cell.cellphoneButton addTarget:self action:@selector(clickToCall:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.cellphoneButton.tag = indexPath.row;
        
        
        //               {
        //            address = "\U9ad8\U65b0\U533a\U73af\U7403\U4e2d\U5fc3W3";
        //            brand = "\U521b\U7ef4";
        //            createdate = "2015-05-27 14:18:16";
        //            engineer = 8a8080f44d83d991014d83dee5d60004;
        //            hoster = "\U674e\U4e8c\U725b";
        //            id = 8a8080f44d8472bc014d848fb87a000d;
        //            mac = "<null>";
        //            paymodel = "<null>";
        //            phone = 13678964561;
        //            size = "49\U5bf8";
        //            source = 0;
        //            type = 0;
        //            version = COOCAALDFJ;
        //        }

        
        
        NSInteger type = [self.orderList[indexPath.row][@"type"] integerValue];
        
        if (type == 0 ) {
            cell.TVImageView.image = [UIImage imageNamed:@"zuoshi"];
            cell.TVTypeLabel.text = @"坐式";
            cell.TVTypeLabel.textColor = [UIColor colorWithHex:@"00c3d4"];
        } else{
            cell.TVImageView.image = [UIImage imageNamed:@"guashi"];
            cell.TVTypeLabel.text = @"挂式";
            cell.TVTypeLabel.textColor = [UIColor colorWithHex:@"cd7ff5"];
        }
        
        [cell.cellphoneButton setTitle:self.orderList[indexPath.row][@"phone"] forState:UIControlStateNormal];
        [cell.noUseButton addTarget:self action:@selector(clickNoUseOrder:) forControlEvents:UIControlEventTouchUpInside];
        cell.noUseButton.tag = indexPath.row;
        [cell.retreatButton addTarget:self action:@selector(clickRetreatOrder:) forControlEvents:UIControlEventTouchUpInside];
        cell.retreatButton.tag = indexPath.row;
        
        
        cell.nameLabel.text = self.orderList[indexPath.row][@"hoster"];
        cell.tvBrandLabel.text  =self.orderList[indexPath.row][@"brand"];
        cell.tvSizeLabel.text = self.orderList[indexPath.row][@"size"];
        cell.customerAddress.text =self.orderList[indexPath.row][@"address"];
        cell.dateLabel.text= self.orderList[indexPath.row][@"createdate"];
 
        
        return cell;
    } else{
        
        SavedOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SavedOrderCell" forIndexPath:indexPath];
        NSInteger type = [self.localOrders[indexPath.row][@"type"] integerValue];
        if (type == 0 ) {
            cell.tvImageView.image = [UIImage imageNamed:@"zuoshi"];
            cell.tvTypeLabel.text = @"坐式";
            cell.tvTypeLabel.textColor = [UIColor colorWithHex:@"00c3d4"];
        } else{
            cell.tvImageView.image = [UIImage imageNamed:@"guashi"];
            cell.tvTypeLabel.text = @"挂式";
            cell.tvTypeLabel.textColor = [UIColor colorWithHex:@"cd7ff5"];
        }
        
        [cell.cellphoneButton setTitle:self.localOrders[indexPath.row][@"phone"] forState:UIControlStateNormal];
        cell.nameLabel.text = self.localOrders[indexPath.row][@"hoster"];
        cell.tvBrandLabel.text  =self.localOrders[indexPath.row][@"brand"];
        cell.tvSizeLabel.text = self.localOrders[indexPath.row][@"size"];
        cell.addressLabel.text =self.localOrders[indexPath.row][@"address"];
        cell.dateLabel.text= self.localOrders[indexPath.row][@"createdate"];

        
        
        return cell;
    }
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Order" bundle:nil];
    OrderDetailController *detail =[sb instantiateViewControllerWithIdentifier:@"OrderDetailController"];
    
    detail.hidesBottomBarWhenPushed = YES;
    
   

    if (indexPath.section == 0) {
        detail.orderInfo = [self.orderList[indexPath.row] mutableCopy];
        detail.isNewOrder = YES;
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
    

    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"此订单无效？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"无效" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
       NSString *orderid =  self.orderList[button.tag][@"orderid"];
    
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        
        hud.textLabel.text = @"撤销订单中";
        [hud showInView:self.tableView];
        
        [NetworkingManager disableOrderByID:orderid withcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"response:%@",responseObject);
            if ([responseObject[@"success"] integerValue] == 0) {
               
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.indicatorView = nil;
                    hud.textLabel.text = @"撤销失败";
                    [hud dismissAfterDelay:1.0];
                });
            } else{
               
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.indicatorView = nil;
                    hud.textLabel.text = @"撤销成功";
                    [hud dismissAfterDelay:1.0];
                    
                    [self.orderList removeObjectAtIndex:button.tag];
                    [self.tableView reloadData];
                });

            }
            
    
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud dismiss];
        }];
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"有效" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];

    
    [controller addAction:action];
    [controller addAction:cancel];

    
    [self presentViewController:controller animated:YES completion:nil];

}

-(void)clickRetreatOrder:(UIButton *)button{
    NSLog(@"retreat");
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"确定退掉此订单？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *orderid =  self.orderList[button.tag][@"orderid"];
        
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        
        hud.textLabel.text = @"退单中";
        [hud showInView:self.tableView];
   
        [NetworkingManager revokeOrderID:orderid ByTokenID:self.orderList[button.tag][@"engineer"] withcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.indicatorView = nil;
                    hud.textLabel.text = @"退单失败";
                    
                    [hud dismissAfterDelay:1.0];
                });
            } else{
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    hud.indicatorView = nil;
                    hud.textLabel.text = @"退单成功";
                    [hud dismissAfterDelay:1];
                    
                    [self.orderList removeObjectAtIndex:button.tag];
                    [self.tableView reloadData];
                });
                
            }
            

        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud dismiss];
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    
    [controller addAction:action];
    [controller addAction:cancel];
    
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
