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
    
    if (login == NO) {
        [self setPassword:nil];
        [self setCellphoneNumber:nil];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:login forKey:@"Account_login"];
    [ud synchronize];
    
}
+(NSString*)getPassword{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    return  [ud objectForKey:@"accunt_password"];
}

+(void)setPassword:(NSString*)password{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:password forKey:@"accunt_password"];
    [ud synchronize];
}

+(NSString*)getCellphoneNumber{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    return  [ud objectForKey:@"account_cellphone"];
}
+(void)setCellphoneNumber:(NSString*)cellphone{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:cellphone forKey:@"account_cellphone"];
    [ud synchronize];
}

+(NSString*)getIDCard{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    return  [ud objectForKey:@"account_idCard"];
}
+(void)setIDCard:(NSString*)IDcard{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:IDcard forKey:@"account_idCard"];
    [ud synchronize];
}

+(NSString*)getName{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    return  [ud objectForKey:@"account_name"];

}
+(void)setName:(NSString*)name{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:name forKey:@"account_name"];
    [ud synchronize];
}

+(NSString*)getAvatarUrlString{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return  [ud objectForKey:@"account_avatar_url"];
}
+(void)setAvatarUrlString:(NSString*)url{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:url forKey:@"account_avatar_url"];
    [ud synchronize];
}




+(NSString*)getLeaderID{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return  [ud objectForKey:@"account_leader_ID"];
}
+(void)setLeaderID:(NSString*)leaderID{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:leaderID forKey:@"account_leader_ID"];
    [ud synchronize];
}

+(void)setScore:(NSInteger)score{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:score forKey:@"ud_score"];
    [ud synchronize];
}

+(NSInteger)getScore{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud integerForKey:@"ud_score"];
}

+(NSString*)getTokenID{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return  [ud objectForKey:@"account_token_ID"];

}
+(void)setTokenID:(NSString*)token{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:token forKey:@"account_token_ID"];
    [ud synchronize];
    
}


@end
