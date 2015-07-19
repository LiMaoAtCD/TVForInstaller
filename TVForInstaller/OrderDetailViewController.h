//
//  OrderDetailViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/7/16.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNCoreServices.h"


typedef enum ServiceType: NSUInteger {
    TV,
    BROADBAND
} ServiceType;


@interface OrderDetailViewController : UIViewController

//@property (nonatomic,strong)

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *telphone;
@property (nonatomic, copy) NSString *runningNumber;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) ServiceType type;
@property (nonatomic, strong) BNPosition *originalPostion;
@property (nonatomic, strong) BNPosition *destinationPosition;

@end
