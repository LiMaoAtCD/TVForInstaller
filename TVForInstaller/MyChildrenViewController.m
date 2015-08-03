//
//  MyChildrenViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/22.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "MyChildrenViewController.h"
#import "ComminUtility.h"
#import "ChildTableViewCell.h"
#import "NetworkingManager.h"
#import <SVProgressHUD.h>
#import <MJRefresh.h>

@interface MyChildrenViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *items;


@end

@implementation MyChildrenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ComminUtility configureTitle:@"我的下级" forViewController:self];
 
    __weak MyChildrenViewController * weakSelf =self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf fetchMyChildrenList];
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)fetchMyChildrenList{
    [NetworkingManager fetchMyChildrenListwithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"success"] integerValue] == 0) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            
            
        } else{
            self.items = responseObject[@"obj"];
            if (self.items.count > 0) {
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"还没有下级"]];
            }
            
            
        }
        
        [self.tableView.header endRefreshing];

        
        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.tableView.header endRefreshing];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView.header beginRefreshing];
}
-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _items.count;
    return 2;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel *nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 4, 30)];
    nameLabel.text =@"姓名";
    nameLabel.font = [UIFont boldSystemFontOfSize:12.0];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *installLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4, 0, self.view.frame.size.width / 4, 30)];
    installLabel.text =@"装机数";
    installLabel.font = [UIFont boldSystemFontOfSize:12.0];

    installLabel.textAlignment = NSTextAlignmentCenter;

    UILabel *gradeLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2 / 4, 0, self.view.frame.size.width / 4, 30)];
    gradeLabel.text =@"积分";
    gradeLabel.font = [UIFont boldSystemFontOfSize:12.0];

    gradeLabel.textAlignment = NSTextAlignmentCenter;

    
    UILabel *toushuLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 3 / 4, 0, self.view.frame.size.width / 4, 30)];
    toushuLabel.text =@"星级";
    toushuLabel.font = [UIFont boldSystemFontOfSize:12.0];

    toushuLabel.textAlignment = NSTextAlignmentCenter;
    
    view.backgroundColor = [UIColor colorWithRed:219./255 green:252./255 blue:1 alpha:1.0];

    [view addSubview:nameLabel];
    
    [view addSubview: installLabel];
    
    [view addSubview:gradeLabel];
    [view addSubview:toushuLabel];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChildTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildTableViewCell" forIndexPath:indexPath];
    
    cell.nameLabel.text = self.items[indexPath.row][@"engineername"];
    cell.InstallNumberLabel.text = self.items[indexPath.row][@"orderamount"];
    cell.gradeLabel.text = self.items[indexPath.row][@"totalscore"];
    cell.toushuLabel.text = self.items[indexPath.row][@"stars"];
    
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
