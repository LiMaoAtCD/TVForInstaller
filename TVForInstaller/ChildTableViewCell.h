//
//  ChildTableViewCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/26.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *InstallNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toushuLabel;

@end
