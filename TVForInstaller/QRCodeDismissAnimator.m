//
//  QRCodeDismissAnimator.m
//  TVForInstaller
//
//  Created by AlienLi on 15/7/21.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "QRCodeDismissAnimator.h"
@implementation QRCodeDismissAnimator


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
//    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    [[transitionContext containerView] addSubview:toViewController.view];
    //    toViewController.view.alpha = 0;
    
    
    fromViewController.view.alpha = 1.0;
    
    //    toViewController.view.frame = CGRectMake(0, -toViewController.view.frame.size.height, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        //        toViewController.view.frame = CGRectMake(0, 0, toViewController.view.frame.size.width, toViewController.view.frame.size.height);
        
        fromViewController.view.alpha = 0.0;
        
        
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        fromViewController.view.alpha = 0.0;
        
        
        
    }];
    
}

@end
