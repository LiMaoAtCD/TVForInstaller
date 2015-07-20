//
//  OngoingOrder.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/17.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "OngoingOrder.h"

@implementation OngoingOrder

+(void)setOngoingOrderName:(NSString *)name{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"OngoingOrderName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)ongoingOrderName{
   return  [[NSUserDefaults standardUserDefaults] objectForKey:@"OngoingOrderName"];
}

+(void)setOngoingOrderTelephone:(NSString *)telephone{
    [[NSUserDefaults standardUserDefaults] setObject:telephone forKey:@"OngoingOrderTelePhone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)ongoingOrderTelephone{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"OngoingOrderTelePhone"];
}

+(void)setOngoingOrderAddress:(NSString *)address{
    [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"OngoingOrderAddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSString *)ongoingOrderAddress{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"OngoingOrderAddress"];

}

+(void)setOngoingOrderRunningNumber:(NSString *)runningNumber{
    [[NSUserDefaults standardUserDefaults] setObject:runningNumber forKey:@"OngoingOrderrunningNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSString *)ongoingOrderRunningNumber{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"OngoingOrderrunningNumber"];

}


+(void)setOngoingOrderDate:(NSString *)date{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"OngoingOrderdate"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(NSString *)ongoingOrderDate{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:@"OngoingOrderdate"];

}

+(void)setOngoingOrderType:(NSInteger)serviceType{
    [[NSUserDefaults standardUserDefaults] setInteger:serviceType forKey:@"OngoingOrderServiceType"];

}
+(NSInteger)ongoingOrderServiceType{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"OngoingOrderServiceType"];
}


@end
