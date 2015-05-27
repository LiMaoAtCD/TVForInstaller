//
//  OrderDetailController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/26.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OrderDetailController.h"

#import "OrderDetailCell.h"
#import "TVInfoCell.h"
#import "PayInfoCell.h"

#import "ComminUtility.h"
#import "UIColor+HexRGB.h"
#import "NumberChooseViewController.h"
@interface OrderDetailController ()<UITableViewDelegate,UITableViewDataSource,PickerDelegate>


@property (nonatomic,strong)NSArray *pickerItems;

@property(nonatomic,strong) UIButton *zhijiaButton;
@property(nonatomic,strong) UIButton *HDMIButton;
@property(nonatomic,strong) UIButton *YijiButton;



/**
 *  装机服务费
 */
@property (nonatomic,assign) NSInteger installServiceCost;

/**
 *  钻孔费
 */
@property (nonatomic,assign) NSInteger punchingCost;
/**
 *  支架费
 */
@property (nonatomic,assign) NSInteger trestleCost;
/**
 *  HDMI 费用
 */
@property (nonatomic,assign) NSInteger HDMILineCost;
/**
 *  移机费
 */
@property (nonatomic,assign) NSInteger machineMoveCost;

/**
 *  支付方式：0 现金 1 微信
 */
@property (nonatomic,assign) NSInteger payType;




@end

@implementation OrderDetailController


#pragma mark - view cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ComminUtility configureTitle:@"详情" forViewController:self];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.pickerItems = @[@100,@200,@300];;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"%@",self.orderInfo);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        OrderDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:@"OrderDetailCell" forIndexPath:indexPath];
        cell.nameLabel.text = self.orderInfo[@"hoster"];
        cell.tvSizeLabel.text = self.orderInfo[@"size"];
        cell.tvBrandLabel.text = self.orderInfo[@"brand"];
        cell.cellphoneLabel.text = self.orderInfo[@"phone"];
        cell.customerAddressLabel.text = self.orderInfo[@"address"];
    
        cell.dateLabel.text= self.orderInfo[@"createdate"];
        
        NSInteger type = [self.orderInfo[@"type"] integerValue];
        
        if (type == 0) {
            cell.tvImageView.image = [UIImage imageNamed:@"zuoshi"];
            cell.tvTypeLabel.text = @"坐式";
            cell.tvTypeLabel.textColor = [UIColor colorWithHex:@"00c3d4"];
        } else{
            cell.tvImageView.image = [UIImage imageNamed:@"temp"];
            cell.tvTypeLabel.text = @"挂式";
            cell.tvTypeLabel.textColor = [UIColor colorWithHex:@"cd7ff5"];
        }

        
        return cell;
        
    } else if(indexPath.section ==1){
        
        
        TVInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TVInfoCell" forIndexPath:indexPath];
        cell.tvspecificationLabel.text = self.orderInfo[@"version"];
        
        return cell;
        
    } else{
        PayInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PayInfoCell" forIndexPath:indexPath];
        
        [cell.zhijiaButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
        
        self.zhijiaButton = cell.zhijiaButton;
        self.zhijiaButton.tag = 0;
        
        [cell.hdmiButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
        self.HDMIButton = cell.hdmiButton;
        self.HDMIButton.tag = 1;

        [cell.moveTVButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
        self.YijiButton = cell.moveTVButton;
        self.YijiButton.tag = 2;

        [cell.PaySegment addTarget:self action:@selector(didSelectedPayType:) forControlEvents:UIControlEventValueChanged];
        cell.PaySegment.selectedSegmentIndex = 0;
        self.payType =0;
        
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
        button.frame = CGRectMake(10, 10, self.view.frame.size.width -20, 40);
        [button setBackgroundColor:[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0]];
        [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"提  交" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickToPostOrder:) forControlEvents:UIControlEventTouchUpInside];
        UIView *view =[[UIView alloc] init];
        
        [view addSubview:button];
        return view;
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        return 80;
        
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark - actions


-(void)didSelectedPayType:(UISegmentedControl*)segment{
    self.payType = segment.selectedSegmentIndex;
    if (self.payType == 0) {
        NSLog(@"现金");
    }
}

-(void)clickToShowDropDown:(UIButton*)button{
    
   //TODO::
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    NumberChooseViewController *number = [sb instantiateViewControllerWithIdentifier:@"NumberChooseViewController"];
    self.modalTransitionStyle= UIModalPresentationCurrentContext;
    number.type = button.tag;
    number.delegate = self;
    number.pickerItems = self.pickerItems;
    
    [self showDetailViewController:number sender:self];
    
}

-(void)didPickerItems:(NSInteger)itemsIndex onType:(CashNumberType)type{
    
    NSLog(@"选择了%@ 元,%ld ",self.pickerItems[itemsIndex],type);
    
    if (type == CashNumberTypeZhiJia) {
        [self.zhijiaButton setTitle:[NSString stringWithFormat:@"%@元",self.pickerItems[itemsIndex]] forState:UIControlStateNormal];
    } else if (type == CashNumberTypeHDMI){
        
        [self.HDMIButton setTitle:[NSString stringWithFormat:@"%@元",self.pickerItems[itemsIndex]] forState:UIControlStateNormal];

    }else{
        [self.YijiButton setTitle:[NSString stringWithFormat:@"%@元",self.pickerItems[itemsIndex]] forState:UIControlStateNormal];
    }
}

-(void)clickToPostOrder:(UIButton *)button{
    //TODO: 提交订单
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
