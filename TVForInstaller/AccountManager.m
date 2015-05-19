//
//  AccountManager.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager

+(BOOL)isLogin{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    BOOL islogin = [ud boolForKey:@"Account_login"];
    return islogin;
    
}

+(void)setLogin:(BOOL)login{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:login forKey:@"Account_login"];
    [ud synchronize];
    
}

@end
