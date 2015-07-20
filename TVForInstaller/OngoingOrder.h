//
//  OngoingOrder.h
//  TVForInstaller
//
//  Created by AlienLi on 15/7/17.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OngoingOrder : NSObject


+(void)setOngoingOrderName:(NSString *)name;
+(NSString *)ongoingOrderName;

+(void)setOngoingOrderTelephone:(NSString *)telephone;
+(NSString *)ongoingOrderTelephone;

+(void)setOngoingOrderAddress:(NSString *)address;
+(NSString *)ongoingOrderAddress;

+(void)setOngoingOrderRunningNumber:(NSString *)runningNumber;
+(NSString *)ongoingOrderRunningNumber;


+(void)setOngoingOrderDate:(NSString *)date;
+(NSString *)ongoingOrderDate;

+(void)setOngoingOrderType:(NSInteger)serviceType;
+(NSInteger)ongoingOrderServiceType;

@end
