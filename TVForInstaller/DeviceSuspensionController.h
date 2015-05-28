//
//  DeviceSuspensionController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/28.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceSelectionDelegate <NSObject>

-(void)didChosenDeviceName:(NSString*)deviceName;

@end

@interface DeviceSuspensionController : UIViewController

@property (nonatomic,strong) id<DeviceSelectionDelegate> delegate;


@end
