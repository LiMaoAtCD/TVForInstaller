//
//  NumberChooseViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/26.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef enum : NSUInteger {
    CashNumberTypeZhiJia,
    CashNumberTypeHDMI,
    CashNumberTypeYIJI,
} CashNumberType;

@protocol PickerDelegate <NSObject>

-(void)didPickerItems:(NSInteger)itemsIndex onType:(CashNumberType)type;

@end


@interface NumberChooseViewController : UIViewController

@property (nonatomic,assign) CashNumberType type;

@property(nonatomic,strong) NSArray *pickerItems;

@property (nonatomic,weak) id<PickerDelegate> delegate;
@end
