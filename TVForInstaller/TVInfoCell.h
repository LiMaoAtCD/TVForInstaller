//
//  TVInfoCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/25.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tvspecificationLabel;

@property (weak, nonatomic) IBOutlet UILabel *macAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *getInfoFromTVButton;

@property (weak, nonatomic) IBOutlet UILabel *installedAppLabel;


@end
