//
//  QRCodeViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/7/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QRCodeCompletedDelegate <NSObject>

-(void)didClickCloseQRCode;

@end

@interface QRCodeViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) id<QRCodeCompletedDelegate> delegate;

@end
