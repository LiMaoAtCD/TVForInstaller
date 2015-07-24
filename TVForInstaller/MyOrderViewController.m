//
//  MyOrderViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/15.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "MyOrderViewController.h"
#import "CompletedTableViewCell.h"
#import "OngoingDetailViewController.h"
#import "AccountManager.h"
#import "NetworkingManager.h"
#import <JGProgressHUD.h>
#import "OngoingOrder.h"
#import <UIScrollView+EmptyDataSet.h>

@interface MyOrderViewController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIView *OngoingView;
@property (weak, nonatomic) IBOutlet UIImageView *ongoingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (weak, nonatomic) IBOutlet UIButton *killOrderButton;


@property (weak, nonatomic) IBOutlet UIView *completedView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayout;

@property (nonatomic, strong) NSMutableArray *orders;


@property (nonatomic, assign) BOOL isCanceling;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    
//    self.OngoingView
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnGoingView:)];
    [self.OngoingView addGestureRecognizer:gesture];
    
    [self.killOrderButton addTarget:self action:@selector(clickForKillingOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
 
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
    BOOL isOnGoing = [OngoingOrder existOngoingOrder];
    if (!isOnGoing) {
        self.OngoingView.hidden = YES;
        
        [self.view removeConstraint:self.tableViewLayout];
        self.tableViewLayout =[NSLayoutConstraint constraintWithItem:self.completedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:8];
        [self.view addConstraint:self.tableViewLayout];
        
    } else{
        self.OngoingView.hidden = NO;
        
        NSDictionary *order =[OngoingOrder onGoingOrder];
        self.nameLabel.text = order[@"name"];
        self.telphoneLabel.text = order[@"phone"];
        self.addressLabel.text = order[@"home_address"];
        self.dateLabel.text = order[@"order_time"];
        if ([order[@"order_type"] integerValue] == 0) {
            self.ongoingImageView.image = [UIImage imageNamed:@"ui03_tv"];
        } else{
            self.ongoingImageView.image = [UIImage imageNamed:@"ui03_Broadband"];

        }



        
        [self.view removeConstraint:self.tableViewLayout];
        
        self.tableViewLayout =[NSLayoutConstraint constraintWithItem:self.completedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:125];
        [self.view addConstraint:self.tableViewLayout];
        
        [UIView animateWithDuration:0.1 animations:^{
            [self.view layoutIfNeeded];
            
        }];
    }


    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NetworkingManager fetchCompletedOrderListByCurrentPage:@"0" withComletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            //列表请求成功
            self.orders = responseObject[@"obj"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -tableView delegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.orders.count;
    return self.orders.count;
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CompletedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompletedTableViewCell" forIndexPath:indexPath];
    
    

    
    cell.nameLabel.text = self.orders[indexPath.row][@"name"];
    cell.telphoneLabel.text = self.orders[indexPath.row][@"phone"];
    cell.dateLabel.text = self.orders[indexPath.row][@"order_endtime"];
    cell.addressLabel.text= self.orders[indexPath.row][@"home_address"];
    cell.moneyLabel.text = self.orders[indexPath.row][@"order_totalfee"];
    if ([self.orders[indexPath.row][@"order_state"] integerValue] == 3) {
        //支付进行中
        cell.cnyLabel.textColor = [UIColor redColor];
        cell.moneyLabel.textColor = [UIColor redColor];
        cell.payTypeLabel.text =@"支付中";

    } else{
        //支付完成
        if ([self.orders[indexPath.row][@"pay_type"] integerValue] == 0) {
            //微信支付
            cell.payTypeLabel.text = @"微信支付";
        } else if ([self.orders[indexPath.row][@"pay_type"] integerValue] == 1){
            //支付宝支付
            cell.payTypeLabel.text = @"支付宝支付";

        } else{
        //现金支付
            cell.payTypeLabel.text = @"现金支付";
        }
    }
   
    if ([self.orders[indexPath.row][@"order_type"] integerValue] == 0) {
        cell.typeImageView.image = [UIImage imageNamed:@"ui01_tv"];

    } else{
        cell.typeImageView.image = [UIImage imageNamed:@"ui01_Broadband"];

    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([self.orders[indexPath.row][@"order_state"] integerValue] == 3) {
        //未完成支付，可以点击进行支付
        UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Order" bundle:nil];
        
        OngoingDetailViewController *ongingVC = [sb instantiateViewControllerWithIdentifier:@"OngoingDetailViewController"];
        ongingVC.hidesBottomBarWhenPushed = YES;
        ongingVC.OrderInfo = self.orders[indexPath.row];
        [self.navigationController showViewController:ongingVC sender:self];
        
    }
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
#pragma mark - action target

/**
 *  点击正在执行订单
 *
 *  @param gesture
 */
-(void)clickOnGoingView:(UITapGestureRecognizer *)gesture{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    
    OngoingDetailViewController *ongoing =[sb instantiateViewControllerWithIdentifier:@"OngoingDetailViewController"];
    ongoing.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:ongoing sender:self];

}

/**
 *  点击取消订单
 *
 *  @param button
 */
-(void)clickForKillingOrder:(UIButton *)button{
    
    if (!self.isCanceling) {
        self.isCanceling = YES;
        NSDictionary *order =[OngoingOrder onGoingOrder];
        [OngoingOrder setExistOngoingOrder:NO];
        
        
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        hud.textLabel.text =@"正在取消订单";
        [hud showInView:self.view];
        
        
        
        [NetworkingManager ModifyOrderStateByID:order[@"uid"] latitude:[order[@"location"][1] doubleValue] longitude:[order[@"location"][0] doubleValue] order_state:@"0" WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud dismiss];
            
            if ([responseObject[@"status"] integerValue] == 0) {
                
                [OngoingOrder setOrder:nil];
                
                self.OngoingView.hidden = YES;
                
                [self.view removeConstraint:self.tableViewLayout];
                self.tableViewLayout =[NSLayoutConstraint constraintWithItem:self.completedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:8];
                [self.view addConstraint:self.tableViewLayout];
                
                
                [UIView animateWithDuration:0.5 animations:^{
                    [self.view layoutIfNeeded];
                    
                } completion:^(BOOL finished) {
                    if (finished) {
                    }
                }];
            }
            self.isCanceling = NO;

        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud dismissAfterDelay:1.0];
            self.isCanceling = NO;

        }];

    }
}

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"empty_placeholder"];
//}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"数据空空如也";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
