//
//  S1ViewController.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/18.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol S1SelectionDelegate <NSObject>

-(void)didSelectionDelegate:(NSIndexPath*)indexPath;

@end


@interface S1ViewController : UIViewController

@property (weak,nonatomic) id<S1SelectionDelegate> delegate;

@end
