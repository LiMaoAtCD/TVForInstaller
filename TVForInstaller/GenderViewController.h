//
//  GenderViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/29.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    Male,
    Female,
    Cancel,
} GenderSelectType;
@protocol genderDelegate <NSObject>

-(void)didSelectedType:(GenderSelectType)type;

@end

@interface GenderViewController : UIViewController

@property (nonatomic,weak) id<genderDelegate> delegate;

@end
