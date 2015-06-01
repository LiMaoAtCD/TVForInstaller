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

#import "NetworkingManager.h"
#import <JGProgressHUD.h>
#import "DLNAManager.h"

typedef void(^alertBlock)(void);

@interface OrderDetailController ()<UITableViewDelegate,UITableViewDataSource,PickerDelegate,UITextFieldDelegate>


@property (nonatomic,strong)NSArray *pickerItems;

@property(nonatomic,strong) UIButton *zhijiaButton;
@property(nonatomic,strong) UIButton *HDMIButton;
@property(nonatomic,strong) UIButton *YijiButton;

@property(nonatomic,strong) UIButton *installServiceButton;
@property(nonatomic,strong) UIButton *punchingButton;

@property (nonatomic,assign) BOOL isInstallServiceChecked;
@property (nonatomic,assign) BOOL isPunchingChecked;


@property (nonatomic,strong) UITextField *cellPhoneTF;



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
    
    
    
    


    if (_isNewOrder) {
        
        self.orderInfo[@"mac"] = @"";
        self.orderInfo[@"paymodel"] = @0;
        self.orderInfo[@"hostphone"] = self.orderInfo[@"phone"];
        self.orderInfo[@"zjservice"] = @0;
        self.orderInfo[@"sczkfei"] = @0;
        self.orderInfo[@"zhijia"] = @0;
        self.orderInfo[@"zhijia"] = @0;
        self.orderInfo[@"hdmi"] = @0;
        self.orderInfo[@"yiji"] = @0;

    }else{
        [self fetchLocalOrder];
    }
    
    
//    if (_isNewOrder) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:self action:@selector(saveOrder:) forControlEvents:UIControlEventTouchUpInside];
        [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"保存" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:14.0]}] forState:UIControlStateNormal];
        button.tag  =0;

        [button setBackgroundImage:[UIImage imageNamed:@"baocun"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 30);
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
//    }else{
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [button addTarget:self action:@selector(saveOrder:) forControlEvents:UIControlEventTouchUpInside];
//        [button setAttributedTitle:[[NSAttributedString alloc]initWithString:@"删除" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:19./255 green:81./255 blue:115./255 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:14.0]}] forState:UIControlStateNormal];
//        button.tag  =1;
//
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"baocun"] forState:UIControlStateNormal];
//        button.frame = CGRectMake(0, 0, 40, 30);
//        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    }
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"%@",self.orderInfo);

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    
}

-(void)fetchLocalOrder{
    
    
    
    NSManagedObjectContext *context = [[OrderDataManager sharedManager] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"Order" inManagedObjectContext:context];
    
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"orderid" ascending:NO];
    
    request.predicate = [NSPredicate predicateWithFormat:@"orderid == %@",self.orderInfo[@"orderid"]];
    
    NSError *error =  nil;
    
    request.sortDescriptors = @[sorter];
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"error: %@",[error description]);
    }else{
        [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Order *order = obj;

        
            
            self.orderInfo = [@{
                                @"address":order.address,
                                @"brand":order.brand,
                                @"createdate":order.createdate,
                                @"engineer":order.engineer,
                                @"hoster":order.hoster,
                                @"orderid":order.orderid,
                                @"phone":order.phone,
                                @"size":order.size,
                                @"source":order.source,
                                @"type":order.type,

                                @"hostphone":order.bill.hostphone,
                                @"zjservice":order.bill.zjservice,
                                @"sczkfei":order.bill.sczkfei,
                                @"zhijia":order.bill.zhijia,
                                @"hdmi":order.bill.hdmi,
                                @"yiji":order.bill.yiji
                                
                                  } mutableCopy];
            
            
            if (order.mac) {
                self.orderInfo[@"mac"] = order.mac;
            }
            if (order.version) {
                self.orderInfo[@"version"] = order.version;
            }
            if (order.paymodel) {
                self.orderInfo[@"paymodel"] = order.paymodel;
            }else{
                self.orderInfo[@"paymodel"] = @0;
            }
            if (order.version) {
                self.orderInfo[@"version"] = order.version;
            }
            
            if (order.applist.appname) {
                self.orderInfo[@"appname"] = (NSArray*)order.applist.appname;
            }

        }];
    }
    
    
    
    
    
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
            cell.tvImageView.image = [UIImage imageNamed:@"guashi"];
            cell.tvTypeLabel.text = @"挂式";
            cell.tvTypeLabel.textColor = [UIColor colorWithHex:@"cd7ff5"];
        }

      
        
        return cell;
        
    } else if(indexPath.section == 1){
        
        
        TVInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TVInfoCell" forIndexPath:indexPath];
        cell.tvspecificationLabel.text = self.orderInfo[@"version"];
        
        [cell.getInfoFromTVButton addTarget:self action:@selector(getInfoFromTVButton:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.macAddressLabel.text = self.orderInfo[@"mac"];
        
        NSArray *appnames = self.orderInfo[@"appname"];
        
        __block NSString *apps = @"";
        
        if (appnames != nil) {
            [appnames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                apps = [apps stringByAppendingString:[NSString stringWithFormat:@" %@",obj]];
            }];
        }
        
      
    
        cell.installedAppLabel.text = apps;
        
        
        return cell;
        
    } else{
        
        
        //支付信息Cell
        
        
        PayInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PayInfoCell" forIndexPath:indexPath];
        
        //用户手机号
        self.cellPhoneTF = cell.cellphoneTF;
        self.cellPhoneTF.delegate = self;
        
        if (_isNewOrder) {
            //支架
            [cell.zhijiaButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
            self.zhijiaButton = cell.zhijiaButton;
            self.zhijiaButton.tag = 0;
            [self.zhijiaButton setTitle:[NSString stringWithFormat:@"%@ 元",self.pickerItems[0]] forState:UIControlStateNormal];
            
            //HDMI
            [cell.hdmiButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
            self.HDMIButton = cell.hdmiButton;
            [self.HDMIButton setTitle:[NSString stringWithFormat:@"%@ 元",self.pickerItems[0]] forState:UIControlStateNormal];
            
            self.HDMIButton.tag = 1;
            
            //移机
            [cell.moveTVButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
            self.YijiButton = cell.moveTVButton;
            [self.YijiButton setTitle:[NSString stringWithFormat:@"%@ 元",self.pickerItems[0]] forState:UIControlStateNormal];
            
            self.YijiButton.tag = 2;

        } else{
            
           __block NSUInteger zhijiaIndex = 0;
            
            [self.pickerItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSInteger cash = [obj integerValue];
                
                if (cash == [self.orderInfo[@"zhijia"] integerValue]) {
                    zhijiaIndex = idx;
                }
                
            }];
            //支架
            [cell.zhijiaButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
            self.zhijiaButton = cell.zhijiaButton;
            self.zhijiaButton.tag = 0;
            [self.zhijiaButton setTitle:[NSString stringWithFormat:@"%@ 元",self.pickerItems[zhijiaIndex]] forState:UIControlStateNormal];
            
            __block NSUInteger hdmiIndex = 0;
            
            [self.pickerItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSInteger cash = [obj integerValue];
                
                if (cash == [self.orderInfo[@"hdmi"] integerValue]) {
                    hdmiIndex = idx;
                }
                
            }];
            
            //HDMI
            [cell.hdmiButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
            self.HDMIButton = cell.hdmiButton;
            [self.HDMIButton setTitle:[NSString stringWithFormat:@"%@ 元",self.pickerItems[hdmiIndex]] forState:UIControlStateNormal];
            
            self.HDMIButton.tag = 1;
            
            __block NSUInteger yijiIndex = 0;
            
            [self.pickerItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSInteger cash = [obj integerValue];
                
                if (cash == [self.orderInfo[@"yiji"] integerValue]) {
                    yijiIndex = idx;
                }
                
            }];
            
            //移机
            [cell.moveTVButton addTarget:self action:@selector(clickToShowDropDown:) forControlEvents:UIControlEventTouchUpInside];
            self.YijiButton = cell.moveTVButton;
            [self.YijiButton setTitle:[NSString stringWithFormat:@"%@ 元",self.pickerItems[yijiIndex]] forState:UIControlStateNormal];
            
            self.YijiButton.tag = 2;

        }
       
        // 微信或现金
        [cell.PaySegment addTarget:self action:@selector(didSelectedPayType:) forControlEvents:UIControlEventValueChanged];
        cell.PaySegment.selectedSegmentIndex = [self.orderInfo[@"paymodel"] integerValue];
       
        cell.cellphoneTF.text = self.orderInfo[@"hostphone"];
        
        
        // 装机服务费 & 石材钻孔费
        self.installServiceButton = cell.installServiceCheckButton;
        self.punchingButton = cell.punchingCheckButton;

        if (_isNewOrder) {
            [self.installServiceButton addTarget:self action:@selector(clickChooseOrNot:) forControlEvents:UIControlEventTouchUpInside];
            [self.installServiceButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
            self.installServiceButton.tag = 0;
            self.isInstallServiceChecked = YES;
            
            [self.punchingButton addTarget:self action:@selector(clickChooseOrNot:) forControlEvents:UIControlEventTouchUpInside];
            [self.punchingButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
            self.punchingButton.tag = 1;
            self.isPunchingChecked = YES;
        } else{
            
            if ([self.orderInfo[@"zjservice"] integerValue] == 0) {
                [self.installServiceButton addTarget:self action:@selector(clickChooseOrNot:) forControlEvents:UIControlEventTouchUpInside];
                [self.installServiceButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
                self.installServiceButton.tag = 0;
                self.isInstallServiceChecked = YES;
            }else{
                [self.installServiceButton addTarget:self action:@selector(clickChooseOrNot:) forControlEvents:UIControlEventTouchUpInside];
                [self.installServiceButton setBackgroundImage:[UIImage imageNamed:@"temp1"] forState:UIControlStateNormal];
                self.installServiceButton.tag = 0;
                self.isInstallServiceChecked = NO;
            }
            
            if ([self.orderInfo[@"sczkfei"] integerValue] == 0) {
                [self.punchingButton addTarget:self action:@selector(clickChooseOrNot:) forControlEvents:UIControlEventTouchUpInside];
                [self.punchingButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
                self.punchingButton.tag = 1;
                self.isPunchingChecked = YES;
            }else{
                [self.punchingButton addTarget:self action:@selector(clickChooseOrNot:) forControlEvents:UIControlEventTouchUpInside];
                [self.punchingButton setBackgroundImage:[UIImage imageNamed:@"temp1"] forState:UIControlStateNormal];
                self.punchingButton.tag = 1;
                self.isPunchingChecked = NO;
            }
        }
        return cell;
        
    }
    
    
}

-(void)clickChooseOrNot:(UIButton*)button{
    if (button.tag == 0) {
        if (self.isInstallServiceChecked) {
            self.isInstallServiceChecked = NO;
            [self.installServiceButton setBackgroundImage:[UIImage imageNamed:@"temp1"] forState:UIControlStateNormal];
            self.orderInfo[@"zjservice"] = @60;
            
            
        } else{
            self.isInstallServiceChecked = YES;
            [self.installServiceButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
            self.orderInfo[@"zjservice"] = @0;

        }
    } else{
        
        if (self.isPunchingChecked) {
            self.isPunchingChecked = NO;
            [self.punchingButton setBackgroundImage:[UIImage imageNamed:@"temp1"] forState:UIControlStateNormal];
            self.orderInfo[@"sczkfei"] = @100;

        } else{
            self.isPunchingChecked = YES;
            [self.punchingButton setBackgroundImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
            self.orderInfo[@"sczkfei"] = @0;


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
    
    
    self.orderInfo[@"paymodel"]  = @(segment.selectedSegmentIndex);
}

-(void)clickToShowDropDown:(UIButton*)button{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    NumberChooseViewController *number = [sb instantiateViewControllerWithIdentifier:@"NumberChooseViewController"];
//    self.UIModalPresentationCurrentContext = UIModalPresentationCurrentContext;
    number.type = (CashNumberType)button.tag;
    number.delegate = self;
    number.pickerItems = self.pickerItems;
    
    [self showDetailViewController:number sender:self];
    
}

-(void)didPickerItems:(NSInteger)itemsIndex onType:(CashNumberType)type{
    
    NSLog(@"选择了%@ 元,%ld ",self.pickerItems[itemsIndex],(unsigned long)type);
    
    if (type == CashNumberTypeZhiJia) {
        [self.zhijiaButton setTitle:[NSString stringWithFormat:@"%@元",self.pickerItems[itemsIndex]] forState:UIControlStateNormal];
        self.orderInfo[@"zhijia"] = self.pickerItems[itemsIndex];
        
    } else if (type == CashNumberTypeHDMI){
        
        [self.HDMIButton setTitle:[NSString stringWithFormat:@"%@元",self.pickerItems[itemsIndex]] forState:UIControlStateNormal];
        self.orderInfo[@"hdmi"] = self.pickerItems[itemsIndex];


    }else{
        [self.YijiButton setTitle:[NSString stringWithFormat:@"%@元",self.pickerItems[itemsIndex]] forState:UIControlStateNormal];
        self.orderInfo[@"yiji"] = self.pickerItems[itemsIndex];

    }
}


/**
 *  提交订单
 *
 *  @param button
 */
-(void)clickToPostOrder:(UIButton *)button{
    
    
    
    self.orderInfo[@"mac"] =@"xxx";
    if (!self.orderInfo[@"mac"]) {
        [self alertWithMessage:@"Mac 地址不能为空" withCompletionHandler:^{
            
        }];
        return;
    }
    
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    hud.textLabel.text = @"订单提交中";
    [hud showInView:self.tableView animated:YES];
    
    
    NSDictionary * order = [NetworkingManager createOrderDictionaryByOrderID:self.orderInfo[@"orderid"] phone:self.orderInfo[@"phone"] paymodel:self.orderInfo[@"paymodel"] source:self.orderInfo[@"source"] address:self.orderInfo[@"address"] brand:self.orderInfo[@"brand"] engineer:self.orderInfo[@"engineer"] mac:self.orderInfo[@"mac"] hoster:self.orderInfo[@"hoster"] size:self.orderInfo[@"size"] version:self.orderInfo[@"version"] type:self.orderInfo[@"type"] createdate:self.orderInfo[@"createdate"]];
    
    NSLog(@"order: %@",order);
    
    NSDictionary * bill = [NetworkingManager createBillbyHostphone:self.orderInfo[@"hostphone"] zjservice:self.orderInfo[@"zjservice"] sczkfei:self.orderInfo[@"sczkfei"] zhijia:self.orderInfo[@"zhijia"] hdmi:self.orderInfo[@"hdmi"] yiji:self.orderInfo[@"yiji"]];
    NSLog(@"bill: %@",bill);
    
    
    NSArray *arr = self.orderInfo[@"appname"];
    NSMutableArray *updateArray = [NSMutableArray array];
    
    if (arr != nil && arr.count >0) {
 
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [updateArray addObject:@{@"appname":obj}];
        }];
    }else{
        updateArray = [@[@{@"appname":@"李敏煞笔"}] mutableCopy];

    }
    NSLog(@"%@",updateArray);

    [NetworkingManager submitOrderDictionary:order bill:bill applist:updateArray source:self.orderInfo[@"source"] withcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {

        if ([responseObject[@"success"] integerValue] ==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.textLabel.text = responseObject[@"msg"];
                hud.indicatorView=  nil;
                [hud dismissAfterDelay:1.0];
            });
        } else{
            
            //TODO 订单提交成功删除本地订单
            [self deleteLocalOrder];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.textLabel.text = responseObject[@"msg"];
                hud.indicatorView=  nil;
                [hud dismissAfterDelay:1.0];
            });
            
            
        }
       
    } failHandle:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        [hud dismiss];
    }];
    
    
    
}

-(void)alertWithMessage:(NSString*)message withCompletionHandler:(alertBlock)handler{
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (handler) {
            handler();
        }
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

/**
 *  从电视获取电视mac地址和已安装应用列表
 *
 *  @param btn
 */
-(void)getInfoFromTVButton:(UIButton*)btn{
    
    NSString *ipAddress = [[DLNAManager DefaultManager] getCurRenderIpAddress];
    
    if ([ipAddress isEqualToString:@""]||
        ipAddress == nil) {
        //TODO::
       [self alertWithMessage:@"无法获取到设备" withCompletionHandler:^{}];
    } else{
        
        JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        
        hud.textLabel.text = @"正在获取Mac地址和软件列表";
        [hud showInView:self.view];
        
        [NetworkingManager getMacAddressFromTV:ipAddress WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *macResult = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSArray *separator = [macResult componentsSeparatedByString:@","];
            self.orderInfo[@"mac"] = separator[1];
            
            if (self.orderInfo[@"mac"]) {
                
                [NetworkingManager getTVApplist:ipAddress WithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSMutableArray* Array = [[NSMutableArray alloc] init];
                    NSMutableArray *testFeeds = [NSJSONSerialization JSONObjectWithData: responseObject options:NSJSONReadingMutableContainers error:nil];
                    [Array addObjectsFromArray:testFeeds];
                    
                    NSMutableArray *appname = [NSMutableArray array];
                
                    if (Array.count > 0) {
                        [Array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            NSDictionary *appdic = obj;
                            [appname addObject:appdic[@"appname"]];
                            
                        }];
                    }
                    
                    self.orderInfo[@"appname"] = [appname copy];
                    
                    [hud dismissAfterDelay:1.0];
                    [self.tableView beginUpdates];
                    
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"%@",error);
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        hud.textLabel.text = @"获取失败，请稍后再试";
                        hud.indicatorView = nil;
                        [hud dismissAfterDelay:1];
                    });
                }];
                
            }
            
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",error);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.textLabel.text = @"获取失败，请稍后再试";
                hud.indicatorView = nil;
                [hud dismissAfterDelay:1];
            });
           
            
        }];
    }
    
}

-(void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/**
 *  保存订单到数据库 或者删除
 *
 *  @param button
 */
-(void)saveOrder:(UIButton *)button{
        //保存订单操作
        
        
        
        
        //    @property (nonatomic, retain) NSString * orderid;
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
        
        
        NSError *error;
        NSManagedObjectContext *context =  [[OrderDataManager sharedManager] managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        [request setEntity:[NSEntityDescription entityForName:@"Order" inManagedObjectContext:context]];
        
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        if (error) {
            return;
        }else{
            __block BOOL contain = NO;
            
            [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                Order *order = obj;
                if ([order.orderid isEqualToString:self.orderInfo[@"id"]]) {
                    contain = YES;
                    [self alertWithMessage:@"该订单已保存" withCompletionHandler:^{
                        
                    }];
                }
            }];
            
            //保存至数据库
            if (!contain) {
                [self save];
            }
        }

}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.cellPhoneTF) {
        
        
        if ([string isEqualToString:@""]&& ![textField.text isEqualToString:@""]) {
            self.orderInfo[@"hostphone"] = [textField.text substringToIndex:[textField.text length] - 1];
        }else if ([string isEqualToString:@"\n"]){
            
            self.orderInfo[@"hostphone"]= textField.text;
            
        }else{
            self.orderInfo[@"hostphone"] = [textField.text stringByAppendingString:string];
        }
    }    return YES;
}


-(void)save{
    NSLog(@"要保存的数据：%@",self.orderInfo);
    
    
    
    
    NSError *error;
    NSManagedObjectContext *context =  [[OrderDataManager sharedManager] managedObjectContext];
    
    NSFetchRequest *request =[[NSFetchRequest alloc] initWithEntityName:@"Order"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderid == %@",self.orderInfo[@"orderid"]];
    
    [request setPredicate:predicate];
    
    NSArray * result = [context executeFetchRequest:request error:&error];
    
    if (!error) {
        if (result.count > 0) {
            [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                
                Order *order = obj;
                
                order.phone = self.orderInfo[@"phone"];
                order.paymodel = self.orderInfo[@"paymodel"];
                order.source = self.orderInfo[@"source"];
                order.address = self.orderInfo[@"address"];
                order.brand = self.orderInfo[@"brand"];
                order.engineer = self.orderInfo[@"engineer"];
                order.mac = self.orderInfo[@"mac"];
                order.size = self.orderInfo[@"size"];
                order.version = self.orderInfo[@"version"];
                order.hoster  =self.orderInfo[@"hoster"];
                order.type =  self.orderInfo[@"type"];
                order.createdate = self.orderInfo[@"createdate"];
                
                
                
                order.bill.hostphone =  self.orderInfo[@"hostphone"];
                order.bill.zjservice = self.orderInfo[@"zjservice"];
                order.bill.yiji = self.orderInfo[@"yiji"];
                order.bill.hdmi = self.orderInfo[@"hdmi"];
                order.bill.zhijia = self.orderInfo[@"zhijia"];
                order.bill.sczkfei = self.orderInfo[@"sczkfei"];
                
                order.applist.appname = self.orderInfo[@"appname"];
                NSError *err;
                if ([context save:&err]) {
                    NSLog(@"保存成功");
                    
                    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
                    hud.indicatorView = nil;
                    hud.textLabel.text = @"此订单保存成功,请在网络状态良好时提交至服务器";
                    [hud showInView:self.tableView];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kSavedOrderToLocal" object:nil];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud dismiss];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        
                        
                    });

                }
            }];
        } else{
            
            Order *order = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:context];
            Bill *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:context];
            Applist *applist = [NSEntityDescription insertNewObjectForEntityForName:@"Applist" inManagedObjectContext:context];
            
            order.orderid  =self.orderInfo[@"orderid"];
            order.phone = self.orderInfo[@"phone"];
            order.paymodel = self.orderInfo[@"paymodel"];
            order.source = self.orderInfo[@"source"];
            order.address = self.orderInfo[@"address"];
            order.brand = self.orderInfo[@"brand"];
            order.engineer = self.orderInfo[@"engineer"];
            order.mac = self.orderInfo[@"mac"];
            order.size = self.orderInfo[@"size"];
            order.version = self.orderInfo[@"version"];
            order.hoster  =self.orderInfo[@"hoster"];
            order.type =  self.orderInfo[@"type"];
            order.createdate = self.orderInfo[@"createdate"];
            
            
            
            bill.hostphone =  self.orderInfo[@"hostphone"];
            bill.zjservice = self.orderInfo[@"zjservice"];
            bill.yiji = self.orderInfo[@"yiji"];
            bill.hdmi = self.orderInfo[@"hdmi"];
            bill.zhijia = self.orderInfo[@"zhijia"];
            bill.sczkfei = self.orderInfo[@"sczkfei"];
            
            order.bill = bill;
            applist.appname = self.orderInfo[@"appname"];
            order.applist = applist;
            
            
            if ([context save:&error]) {
                //TODO 提示保存成功
                NSLog(@"保存成功");
                
                JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
                hud.indicatorView = nil;
                hud.textLabel.text = @"此订单保存成功,请在网络状态良好时提交至服务器";
                [hud showInView:self.tableView];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kSavedOrderToLocal" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud dismiss];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                    
                });
                
            }

        }
    }
    
}


-(void)deleteLocalOrder{
    
    __block NSError *error;
    
    NSManagedObjectContext *context = [[OrderDataManager sharedManager] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Order"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orderid == %@",self.orderInfo[@"orderid"]];
    [request setPredicate:predicate];
    
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result.count > 0) {
        
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Order *order = obj;
            [context deleteObject:order];
            
            if ([context save:&error]) {
                //删除订单成功
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNeedrefreshOrder" object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });

                
            }
        }];
        
    }else{
    //没有保存数据库的，直接删除本地订单
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNeedrefreshOrder" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    
    
}



@end
