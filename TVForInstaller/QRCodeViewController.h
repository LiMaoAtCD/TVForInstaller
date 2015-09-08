//
//  QRCodeViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/7/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    WECHAT,
    ALIPAY,
    CASH,
} PayType;




@protocol QRCodeCompletedDelegate <NSObject>

-(void)didClickCloseQRCode;

@end

@interface QRCodeViewController : UIViewController

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) id<QRCodeCompletedDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *payTypeImageView;

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@property (nonatomic,assign) PayType type;

@end
