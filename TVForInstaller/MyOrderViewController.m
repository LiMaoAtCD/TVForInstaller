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

#import "OngoingOrder.h"

@interface MyOrderViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIView *OngoingView;
@property (weak, nonatomic) IBOutlet UIImageView *ongoingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (weak, nonatomic) IBOutlet UIButton *killOrderButton;


@property (weak, nonatomic) IBOutlet UIView *completedView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLayout;

@property (nonatomic, strong) NSMutableArray *orders;

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
        self.runningLabel.text = order[@"order_id"];
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
    return 5;
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CompletedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompletedTableViewCell" forIndexPath:indexPath];
    
    return cell;
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
    
    NSDictionary *order =[OngoingOrder onGoingOrder];
    [OngoingOrder setExistOngoingOrder:NO];

    [NetworkingManager ModifyOrderStateByID:order[@"uid"] latitude:[order[@"location"][1] doubleValue] longitude:[order[@"location"][0] doubleValue] order_state:@"0" WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 0) {
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
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
 
}


@end
