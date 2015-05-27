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


#import "OrderDataManager.h"
#import "Order.h"
#import "Applist.h"
#import "Bill.h"


@interface OrderDetailController ()<UITableViewDelegate,UITableViewDataSource,PickerDelegate>


@property (nonatomic,strong)NSArray *pickerItems;

@property(nonatomic,strong) UIButton *zhijiaButton;
@property(nonatomic,strong) UIButton *HDMIButton;
@property(nonatomic,strong) UIButton *YijiButton;

@property(nonatomic,strong) UIButton *installServiceButton;
@property(nonatomic,strong) UIButton *punchingButton;

@property (nonatomic,assign) BOOL isInstallServiceChecked;
@property (nonatomic,assign) BOOL isPunchingChecked;






@property (nonatomic,copy) NSString* mac_address;
@property (nonatomic,copy) NSString* applist;





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
    [[UITextField appearance] setTintColor:[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0]];

    
    
    self.pickerItems = @[@0,@100,@200,@300];
    
    
    self.installServiceCost = 60;
    self.punchingCost = 60;
    
    
    
    if (_isNewOrder) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:self action:@selector(saveOrder:) forControlEvents:UIControlEventTouchUpInside];
        [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"保存" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:14.0]}] forState:UIControlStateNormal];


        [button setBackgroundImage:[UIImage imageNamed:@"baocun"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 30);
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }else{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:self action:@selector(saveOrder:) forControlEvents:UIControlEventTouchUpInside];
        [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"删除" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:14.0]}] forState:UIControlStateNormal];
        
        
        [button setBackgroundImage:[UIImage imageNamed:@"baocun"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 30);
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"%@",self.orderInfo);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];

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
        
        [cell.getInfoFromTVButton addTarget:self action:@selector(getInfoFromTVButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
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
        
        cell.cellphoneTF.text = self.orderInfo[@"phone"];
        
        self.installServiceButton = cell.installServiceCheckButton;
        [self.installServiceButton addTarget:self action:@selector(clickChooseOrNot:) forControlEvents:UIControlEventTouchUpInside];
        [self.installServiceButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
        self.installServiceButton.tag = 0;
        self.isInstallServiceChecked = YES;
        
        self.punchingButton = cell.punchingCheckButton;
        [self.punchingButton addTarget:self action:@selector(clickChooseOrNot:) forControlEvents:UIControlEventTouchUpInside];
        [self.punchingButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
        self.punchingButton.tag = 1;
        self.isPunchingChecked = YES;
        
        
        return cell;
        
    }
    
    
}

-(void)clickChooseOrNot:(UIButton*)button{
    if (button.tag == 0) {
        if (self.isInstallServiceChecked) {
            self.isInstallServiceChecked = NO;
            [self.installServiceButton setBackgroundImage:[UIImage imageNamed:@"temp1"] forState:UIControlStateNormal];

            
            
        } else{
            self.isInstallServiceChecked = YES;
            [self.installServiceButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];

        }
    } else{
        
        if (self.isPunchingChecked) {
            self.isPunchingChecked = NO;
            [self.punchingButton setBackgroundImage:[UIImage imageNamed:@"temp1"] forState:UIControlStateNormal];

        } else{
            self.isPunchingChecked = YES;
            [self.punchingButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];

        }
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


/**
 *  提交订单
 *
 *  @param button
 */
-(void)clickToPostOrder:(UIButton *)button{
    //TODO: 提交订单
}

/**
 *  从电视获取电视mac地址和已安装应用列表
 *
 *  @param btn
 */
-(void)getInfoFromTVButton:(UIButton*)btn{
    
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/**
 *  保存订单到数据库
 *
 *  @param button
 */
-(void)saveOrder:(UIButton *)button{
    
    if ([self.mac_address isEqualToString:@""]||
        self.mac_address == nil
        ) {
        
    }
    
    
    
    //    @property (nonatomic, retain) NSString * orderID;
//    @property (nonatomic, retain) NSString * phone;
//    @property (nonatomic, retain) NSNumber * paymodel;
//    @property (nonatomic, retain) NSNumber * source;
//    @property (nonatomic, retain) NSString * address;
//    @property (nonatomic, retain) NSString * brand;
//    @property (nonatomic, retain) NSString * engineer;
//    @property (nonatomic, retain) NSString * mac;
//    @property (nonatomic, retain) NSString * size;
//    @property (nonatomic, retain) NSString * version;
//    @property (nonatomic, retain) NSString * hoster;
//    @property (nonatomic, retain) Bill *bill;
//    @property (nonatomic, retain) Applist *applist;
    
    NSManagedObjectContext *context =  [[OrderDataManager sharedManager] managedObjectContext];
    
    Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:context];
    
    order.orderID  =self.orderInfo[@"id"];
    order.phone = self.orderInfo[@"phone"];
    order.paymodel = @(self.payType);
    order.source = self.orderInfo[@"source"];
    order.address = self.orderInfo[@"address"];
    order.brand = self.orderInfo[@"brand"];
    order.engineer = self.orderInfo[@"engineer"];
    order.mac = self.mac_address;
    order.size = self.orderInfo[@"size"];
    order.version = self.orderInfo[@"version"];
    order.hoster  =self.orderInfo[@"hoster"];
    
    
    
//    @property (nonatomic, retain) NSString * hostphone;
//    @property (nonatomic, retain) NSNumber * zjservice;
//    @property (nonatomic, retain) NSNumber * yiji;
//    @property (nonatomic, retain) NSNumber * hdmi;
//    @property (nonatomic, retain) NSNumber * zhijia;
//    @property (nonatomic, retain) NSNumber * sczkfei;
    
    
    order.bill.hostphone =  self.orderInfo[@"phone"];
    order.bill.zjservice = @(self.installServiceCost);
    order.bill.yiji = @(self.machineMoveCost);
    order.bill.hdmi = @(self.HDMILineCost);
    order.bill.zhijia = @(self.trestleCost);
    order.bill.sczkfei = @(self.punchingCost);
    
    order.applist.appname = @[@"xxxx",@"dsdsd"];
    
    NSError *error = nil;
    
    if ([context save:&error]) {
        //TODO 提示保存成功
    }
    
    
}




@end
