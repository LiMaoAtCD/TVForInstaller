//
//  UnSubmitCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/25.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnSubmitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *TVImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *cellphoneButton;

@property (weak, nonatomic) IBOutlet UILabel *tvBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *tvSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *customerAddress;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *noUseButton;

@property (weak, nonatomic) IBOutlet UIButton *retreatButton;

@end
