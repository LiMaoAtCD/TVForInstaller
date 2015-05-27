//
//  Order.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/27.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Applist, Bill;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * engineer;
@property (nonatomic, retain) NSString * hoster;
@property (nonatomic, retain) NSString * mac;
@property (nonatomic, retain) NSString * orderID;
@property (nonatomic, retain) NSNumber * paymodel;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * source;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * createdate;
@property (nonatomic, retain) Applist *applist;
@property (nonatomic, retain) Bill *bill;

@end
