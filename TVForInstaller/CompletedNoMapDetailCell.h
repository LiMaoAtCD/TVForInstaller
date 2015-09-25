//
//  CompletedNoMapDetailCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/9/21.
//  Copyright © 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedNoMapDetailCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *cellphoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *starImageView;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@end
