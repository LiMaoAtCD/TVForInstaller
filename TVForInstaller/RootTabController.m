//
//  RootTabController.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "RootTabController.h"
#import "AccountManager.h"

#import "LoginNavigationController.h"
#import "SuspensionViewController.h"
#import "ComminUtility.h"
@interface RootTabController ()

@property(nonatomic,strong) UIView * suspensionView;
@property (nonatomic,strong) SuspensionViewController *suspension;

@end

@implementation RootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSuspensionView) name:[ComminUtility kSuspensionWindowNotification] object:nil];
    [self.tabBar setTranslucent:NO];
    
   
}
-(void)showSuspensionView{
    
    if ([ComminUtility isSwitchKitOn]) {
        [self suspensionWindow:YES];
        
    } else{
        [self suspensionWindow:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self manageLogState];
    
    if ([ComminUtility isSwitchKitOn]) {
        
        //启动时延时获取设备renderer以免崩溃；
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self suspensionWindow:YES];

        });

    } else{
        [self suspensionWindow:NO];
    }

    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [self suspensionWindow:NO];

}

//-(void)manageLogState{
//    
//    if (![AccountManager isLogin]) {
//        
//        
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginNavigationController *login  =[sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
//        
//        [self showDetailViewController:login sender:self];
//        
//    } else{
//        
//    }
//
//}

-(void)suspensionWindow:(BOOL)Issuspension{
    
    if (Issuspension) {
        
        if (!self.suspension) {
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            self.suspension = [sb instantiateViewControllerWithIdentifier:@"SuspensionViewController"];
            self.suspension.view.backgroundColor = [UIColor clearColor];
        }
      
       
        [self addChildViewController:self.suspension];
        
        
        [self.suspension willMoveToParentViewController:self];
        
        
        self.suspension.view.frame = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 60 - 40, 80, 40);
        
        self.suspensionView = self.suspension.view;
        
//        self.suspensionView.layer.cornerRadius = 10;
//        self.suspensionView.layer.masksToBounds = YES;
        
        self.suspension.view.alpha = 0.0;
        [self.view addSubview:self.suspension.view];


        [self.suspension didMoveToParentViewController:self];
        
        
        [UIView animateWithDuration:1.0 animations:^{
            self.suspension.view.alpha =1.0;
        }];
    } else{
        
        [self.suspensionView removeFromSuperview];
        [self.suspension removeFromParentViewController];
        
    }
    
   
    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        //取得一个触摸对象（对于多点触摸可能有多个对象）
        UITouch *touch = obj;
        //NSLog(@"%@",touch);
        
        //取得当前位置
        CGPoint current=[touch locationInView:self.view];
        //取得前一个位置
        CGPoint previous=[touch previousLocationInView:self.view];
        
        CGRect newFrame = CGRectMake(self.suspensionView.frame.origin.x-20, self.suspensionView.frame.origin.y -20, self.suspensionView.frame.size.width + 40, self.suspensionView.frame.size.height + 40);
        if (CGRectContainsPoint(newFrame, current)) {
            
            //移动前的中点位置
            CGPoint center=self.suspensionView.center;
            //移动偏移量
            CGPoint offset=CGPointMake(current.x-previous.x, current.y-previous.y);
            
            //重新设置新位置
            self.suspensionView.center=CGPointMake(center.x+offset.x, center.y+offset.y);
        }
        
      
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
