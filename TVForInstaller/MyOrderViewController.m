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

@interface MyOrderViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UIView *OngoingView;
@property (weak, nonatomic) IBOutlet UIImageView *ongoingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;



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
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];

    BOOL isOnGoing = YES;
    if (!isOnGoing) {
        self.OngoingView.hidden = YES;
        
        [self.completedView removeConstraint:self.tableViewLayout];
        self.tableViewLayout =[NSLayoutConstraint constraintWithItem:self.completedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:8];
        [self.view addConstraint:self.tableViewLayout];
        
    } else{
        
        self.OngoingView.hidden = NO;
        [self.completedView removeConstraint:self.tableViewLayout];

        self.tableViewLayout =[NSLayoutConstraint constraintWithItem:self.completedView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:132];
        [self.view addConstraint:self.tableViewLayout];

    }
    
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

#pragma mark - action target

-(void)clickOnGoingView:(UITapGestureRecognizer *)gesture{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    
    OngoingDetailViewController *ongoing =[sb instantiateViewControllerWithIdentifier:@"OngoingDetailViewController"];
    ongoing.hidesBottomBarWhenPushed = YES;
    [self.navigationController showViewController:ongoing sender:self];

}


@end
