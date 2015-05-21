//
//  AvatorDetailViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Camera,
    Album,
} AvatarType;

@protocol AvatarSelectionDelegate <NSObject>

-(void)didSelectButtonAtIndex:(AvatarType)type;

@end


@interface AvatorDetailViewController : UIViewController


@property (nonatomic,weak)id<AvatarSelectionDelegate> delegate;
@end
