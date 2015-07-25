//
//  AppDelegate.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/7.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "AppDelegate.h"
#import "DLNAManager.h"
#import <BaiduMapAPI/BMapKit.h>
#import "RootTabController.h"
#import "LoginNavigationController.h"

#import "BNCoreServices.h"

#import "AccountManager.h"
#import <AFNetworkActivityIndicatorManager.h>

#import "NetworkingManager.h"
#import "OngoingOrder.h"
@interface AppDelegate ()


@property (nonatomic, strong) BMKMapManager *mapManager;

@property (nonatomic, strong) RootTabController *tabBarController;
@property (nonatomic,strong) LoginNavigationController *loginController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configureTabBarAppearance];
    [self configureBaiduMapSetting];
    
    [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:[UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0]];

    
//    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLaunch"];
    BOOL isLogin = [AccountManager isLogin];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.tabBarController = [sb instantiateViewControllerWithIdentifier:@"RootTabController"];
    
    if (!isLogin) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        self.loginController = [sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        self.window.rootViewController = self.loginController;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"LoginSuccess" object:nil];
        [self.window makeKeyAndVisible];

    } else{
        self.window.rootViewController = self.tabBarController;
        [self.window makeKeyAndVisible];
    }
    
    
    AFNetworkActivityIndicatorManager *manager = [AFNetworkActivityIndicatorManager sharedManager];
    manager.enabled = YES;
    
    return YES;
}

-(void)loginSuccess:(id)sender{
    [AccountManager setLogin:YES];

    self.window.rootViewController = self.tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[DLNAManager DefaultManager] stopService];
    [BMKMapView willBackGround];


}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[DLNAManager DefaultManager] createControlPoint];
    [BMKMapView didForeGround];
    [self fetchOngoingOrder];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[OrderDataManager sharedManager] saveContext];
}

-(void)configureTabBarAppearance{
    
    UIColor *backgroundColor = [UIColor colorWithRed:20./255 green:20./255 blue:20./255 alpha:1.0];
    [[UITabBar appearance] setBackgroundImage:[AppDelegate imageFromColor:backgroundColor forSize:CGSizeMake(320, 44) withCornerRadius:0]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0]} forState:UIControlStateSelected];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:234./255 green:13./255 blue:125./255 alpha:1.0]];
    
}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)configureBaiduMapSetting{
    _mapManager = [[BMKMapManager alloc] init];
    
    BOOL ret = [_mapManager start:@"8Nep3BNORZ9DaTyU0Cp5GUnn" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed");
    }
    [BNCoreServices_Instance initServices:@"8Nep3BNORZ9DaTyU0Cp5GUnn"];
//    [BNCoreServices_Instance startServicesAsyn:^{
//        NSLog(@"success");
//    } fail:^{
//        NSLog(@"fail");
//
//    }];


}
-(void)fetchOngoingOrder{
    //检查是否是登录状态,没有登录就不检查是否有正在执行订单
    if ([AccountManager isLogin]) {
        
        [NetworkingManager FetchOngongOrderWithcompletionHandler:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"status"] integerValue] == 0) {
                
                NSArray *pois =responseObject[@"pois"];
                //如果获取到有正在执行的订单
                if (!pois  && pois.count > 0) {
                    NSMutableDictionary *temp = [pois[0] mutableCopy];
                    if (temp[@"id"]) {
                        temp[@"uid"] = temp[@"id"];
                    }
                    //添加执行中的订单
                    
                    [OngoingOrder setOrder:temp];
                    [OngoingOrder setExistOngoingOrder:YES];
                }else {
                    
                }
            }
            
            
        } failHandler:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    
    
}





@end
