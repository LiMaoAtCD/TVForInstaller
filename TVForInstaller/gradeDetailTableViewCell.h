//
//  gradeDetailTableViewCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/24.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gradeDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailDate;
@property (weak, nonatomic) IBOutlet UILabel *detailActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailgradeLabel;

@end
