//
//  OrderDetailCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/25.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *tvImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tvBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *tvSizeLabel;
@end
