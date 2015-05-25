//
//  OrderDetailViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/25.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OrderDetailViewController.h"

#import "OrderDetailCell.h"
#import "TVInfoCell.h"
#import "PayInfoCell.h"

#import "ComminUtility.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
 
    [ComminUtility configureTitle:@"详情" forViewController:self];
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        OrderDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell" forIndexPath:indexPath];
        
        return cell;
    } else if(indexPath.section ==1){
        TVInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TVInfoCell" forIndexPath:indexPath];
        return cell;

    } else{
        PayInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PayInfoCell" forIndexPath:indexPath];
        return cell;

    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 20)];
    
    label.text = [self tableView:self.tableView titleForHeaderInSection:section];
    label.font  =[UIFont boldSystemFontOfSize:12.0];
    [view addSubview:label];
    return view;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return @"订单详情";
    }else if (section ==1){
        return @"电视信息";
    } else{
        return @"支付信息";
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section ==2) {
//        return 196;
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
