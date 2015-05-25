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
#import "SAMenuDropDown.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SAMenuDropDownDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) SAMenuDropDown *menuDrop;
@property(nonatomic,strong) NSArray *dropDownItems;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
 
    [ComminUtility configureTitle:@"详情" forViewController:self];
    
   
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    _dropDownItems = @[@"100",@"100",@"100",@"100"];
}

-(void)pop{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, self.view.frame.size.width -20, 30);
        [button setBackgroundColor:[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0]];
        [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"提交" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickToPostOrder:) forControlEvents:UIControlEventTouchUpInside];
        UIView *view =[[UIView alloc] init];
        
        [view addSubview:button];
        return view;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 2) {
        return 50;

    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(void)clickToPostOrder:(UIButton *)button{
    //TODO: 提交订单
    
    
    
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
