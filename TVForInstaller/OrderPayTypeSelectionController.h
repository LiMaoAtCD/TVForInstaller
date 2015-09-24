//
//  OrderPayTypeSelectionController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/9/22.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ALIPay,
    WECHAT
} DetailPayType;


@protocol DetailPayTypeDelegate <NSObject>

-(void)didSelectedPayType:(DetailPayType)type;

@end

@interface OrderPayTypeSelectionController : UIViewController

@property (weak, nonatomic) id<DetailPayTypeDelegate> delegate;

@end
