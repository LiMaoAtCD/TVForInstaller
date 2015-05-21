//
//  InfoTableViewCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *InfoTitle;
@property (weak, nonatomic) IBOutlet UITextField *InfoTextField;

@end
