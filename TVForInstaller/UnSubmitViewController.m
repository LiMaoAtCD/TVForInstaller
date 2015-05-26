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

#import "NetworkingManager.h"
#import <JGProgressHUD.h>
#import "UIColor+HexRGB.h"
@interface UnSubmitViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *orderList;

@end

@implementation UnSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchOrder];
    
    
}

-(void)fetchOrder{
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    hud.textLabel.text =@"正在获取订单";
    [hud showInView:self.view animated:YES];
    
    
    [NetworkingManager fetchOrderwithCompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"success"] integerValue] ==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.textLabel.text = @"订单获取失败";
                hud.indicatorView = nil;
                
                [hud dismissAfterDelay:2.0];
            });
            
            
        } else{
            
            [hud dismissAfterDelay:2.0];
            NSArray *data = responseObject[@"obj"];
            NSLog(@"received data: %@",data);
            
            if (data.count >0) {
                
                self.orderList = [data mutableCopy];
                [self.tableView reloadData];
            }
            
            
        }
        
    } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud dismiss];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -tableView delegate & dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
//    cell.dateLabel.text= self.orderList[]
    

    
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
    return 182.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickNoUseOrder:(UIButton *)button{
    NSLog(@"nouse");
}

-(void)clickRetreatOrder:(UIButton *)button{
    NSLog(@"retreat");
}

@end
