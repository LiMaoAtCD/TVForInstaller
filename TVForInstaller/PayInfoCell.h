//
//  PayInfoCell.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/25.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UITextField *cellphoneTF;


@property (weak, nonatomic) IBOutlet UIButton *zhijiaButton;

@property (weak, nonatomic) IBOutlet UIButton *hdmiButton;
@property (weak, nonatomic) IBOutlet UIButton *moveTVButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *PaySegment;


@property (weak, nonatomic) IBOutlet UIButton *installServiceCheckButton;

@property (weak, nonatomic) IBOutlet UIButton *punchingCheckButton;



@end
