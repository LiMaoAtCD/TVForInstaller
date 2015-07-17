//
//  RunningOrderCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/7/17.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunningOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *runningNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end
