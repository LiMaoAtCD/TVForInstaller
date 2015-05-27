//
//  OrderDetailController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/26.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface OrderDetailController : UITableViewController

@property (nonatomic,strong) NSMutableDictionary *orderInfo;

@property (nonatomic,assign) BOOL isNewOrder;


@end
