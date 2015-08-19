//
//  QRDecodeViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/8/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^QRUrlBlock)(NSString *url);

@interface QRDecodeViewController : UIViewController
@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@end
