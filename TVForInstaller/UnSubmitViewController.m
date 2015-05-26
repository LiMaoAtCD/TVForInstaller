//
//  UnSubmitViewController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/25.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "UnSubmitViewController.h"
#import "UnSubmitCell.h"
#import "OrderDetailController.h"

@interface UnSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *orderList;

@end

@implementation UnSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orderList = [@[@3] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UnSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnSubmitCell" forIndexPath:indexPath];
    
    [cell.cellphoneButton addTarget:self action:@selector(clickToCall:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.cellphoneButton.tag = indexPath.row;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIStoryboard *sb =[UIStoryboard storyboardWithName:@"Order" bundle:nil];
    OrderDetailController *detail =[sb instantiateViewControllerWithIdentifier:@"OrderDetailController"];
    
    detail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController showViewController:detail sender:self];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 165.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)clickToCall:(UIButton*)btn{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:@"拨打电话" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //TODO: 拨打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:13568927473"]];

    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:action];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
