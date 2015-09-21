//
//  CompletedNoMapTableViewCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedNoMapTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *completedNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *scanNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;

@end
