//
//  TotalFeeViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/7/25.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SubmitDelegate <NSObject>

-(void)didClickSubmitButton;

@end

@interface TotalFeeViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, weak) id<SubmitDelegate> delegate;

@end
