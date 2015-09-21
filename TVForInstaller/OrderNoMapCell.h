//
//  OrderNoMapCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderNoMapCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
