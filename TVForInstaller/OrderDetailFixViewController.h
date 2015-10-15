//
//  OrderDetailFixViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/10/11.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNCoreServices.h"

@interface OrderDetailFixViewController : UIViewController


@property (nonatomic, strong, nonnull) NSDictionary *order;

@property (nonatomic, strong, nullable) BNPosition *originPostion;


@end
