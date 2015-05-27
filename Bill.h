//
//  Bill.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/27.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Bill : NSManagedObject

@property (nonatomic, retain) NSString * hostphone;
@property (nonatomic, retain) NSNumber * zjservice;
@property (nonatomic, retain) NSNumber * yiji;
@property (nonatomic, retain) NSNumber * hdmi;
@property (nonatomic, retain) NSNumber * zhijia;
@property (nonatomic, retain) NSNumber * sczkfei;
@property (nonatomic, retain) Order *order;

@end
