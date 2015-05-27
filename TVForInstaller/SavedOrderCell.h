//
//  SavedOrderCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/27.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedOrderCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *tvImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *tvTypeLabel;

@property (weak, nonatomic) IBOutlet UIButton *cellphoneButton;

@property (weak, nonatomic) IBOutlet UILabel *tvBrandLabel;

@property (weak, nonatomic) IBOutlet UILabel *tvSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
