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
@interface RootTabController ()

@property(nonatomic,strong) UIView * suspensionView;

@end

@implementation RootTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self manageLogState];
   
    
    [self suspensionWindow];
    
    
}

-(void)manageLogState{
    
    if (![AccountManager isLogin]) {
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginNavigationController *login  =[sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        
        [self showDetailViewController:login sender:self];
        
    } else{
        
    }

}

-(void)suspensionWindow{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SuspensionViewController *suspension = [sb instantiateViewControllerWithIdentifier:@"SuspensionViewController"];
    suspension.view.backgroundColor = [UIColor clearColor];
    self.suspensionView = suspension.view;
    self.suspensionView.layer.cornerRadius = 10;
    self.suspensionView.layer.masksToBounds = YES;
    [self addChildViewController:suspension];
    
    
    [suspension willMoveToParentViewController:self];
    
    [self.view addSubview:suspension.view];
    suspension.view.frame = CGRectMake(0, 0, 100, 50);
    suspension.view.center = self.view.center;
    [suspension didMoveToParentViewController:self];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
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
        
        //移动前的中点位置
        CGPoint center=self.suspensionView.center;
        //移动偏移量
        CGPoint offset=CGPointMake(current.x-previous.x, current.y-previous.y);
        
        //重新设置新位置
        self.suspensionView.center=CGPointMake(center.x+offset.x, center.y+offset.y);
        
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


@end
