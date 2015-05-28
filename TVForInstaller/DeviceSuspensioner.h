//
//  DeviceSuspensioner.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/28.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceSuspensionerDelegate <NSObject>

-(void)closeSuspension;

@end
@interface DeviceSuspensioner : UIViewController

@property (nonatomic,weak) id<DeviceSuspensionerDelegate> delegate;

@end
