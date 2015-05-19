//
//  AccountManager.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

+(BOOL)isLogin;
+(void)setLogin:(BOOL)login;

@end
