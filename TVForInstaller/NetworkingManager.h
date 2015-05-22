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

+(void)uploadPeronsalInfoName:(NSString*)name cellPhone:(NSString*)phoneNumber chinaID:(NSString*)chinaID withCompletionHandler:(NetWorkHandler)completionHandler;
@end
