//
//  Applist.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/27.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order;

@interface Applist : NSManagedObject

@property (nonatomic, retain) id appname;
@property (nonatomic, retain) Order *order;

@end
