//
//  InstallHistoryViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstallSegmentViewControllerDelegate <NSObject>

-(void)needToShowViewController:(NSIndexPath*)indexPath;

@end
@interface InstallHistoryViewController : UIViewController

@property(nonatomic,weak) id<InstallSegmentViewControllerDelegate> delegate;

@end
