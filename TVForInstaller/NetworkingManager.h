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

@interface NetworkingManager : NSObject


+(void)login:(NSString*)account withPassword:(NSString *)password withCompletionHandler:(NetWorkHandler)completionHandler;

+(void)uploadPeronsalInfoName:(NSString*)name cellPhone:(NSString*)phoneNumber chinaID:(NSString*)chinaID withCompletionHandler:(NetWorkHandler)completionHandler;
@end
