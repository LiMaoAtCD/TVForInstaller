//
//  NetworkingManager.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/7.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^NetWorkHandler)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^NetWorkFailHandler)(AFHTTPRequestOperation *operation,NSError *error);

//(void (^)(AFHTTPRequestOperation *operation, NSError *error))
@interface NetworkingManager : NSObject

/**
 *  登录
 *
 *  @param account           phone
 *  @param password          password
 *  @param completionHandler
 */
+(void)login:(NSString*)account withPassword:(NSString *)password withCompletionHandler:(NetWorkHandler)completionHandler FailHandler:(NetWorkFailHandler)failHandler;

/**
 *  注册
 *
 *  @param phone             手机号码
 *  @param password          密码
 *  @param inviteCode        邀请码
 *  @param chinaID           身份证号
 *  @param verifyCode        验证码
 *  @param completionHandler 成功回调
 *  @param failHandler       失败回调
 */
+(void)registerCellphone:(NSString*)phone password:(NSString*)password inviteCode:(NSString*)inviteCode chinaID:(NSString*)chinaID verifyCode:(NSString*)verifyCode withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  获取验证码
 *
 *  @param cellphoneNumber   手机号码
 *  @param completionHandler 成功回调
 *  @param failHandler       失败回调
 */
+(void)fetchVerifyCode:(NSString*)cellphoneNumber withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  修改密码
 *
 *  @param password          新密码
 *  @param code              验证码
 *  @param completionHandler  ok
 *  @param failHandler       fail
 */
+(void)ModifyPasswordwithNewPassword:(NSString*)password verifyCode:(NSString*)code withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  忘记密码
 *
 *  @param cellphone         手机号码
 *  @param password          密码
 *  @param code              验证码
 *  @param completionHandler ok
 *  @param failHandler       fail
 */
+(void)forgetPasswordOnCellPhone:(NSString*)cellphone password:(NSString*)password verifyCode:(NSString*)code withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;



@end
