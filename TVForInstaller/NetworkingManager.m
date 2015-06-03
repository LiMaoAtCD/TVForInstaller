//
//  NetworkingManager.m
//  TVForInstaller
//
//  Created by AlienLi on 15/5/7.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "NetworkingManager.h"
#import "NSDictionary+JSONString.h"
#import <JGProgressHUD.h>
#import "AppDelegate.h"
#import "AccountManager.h"

#define kServer @"http://zqzh1.chinacloudapp.cn:8080/zhiKey/appengController.do?enterService"
#define kServer2 @"http://zqzh1.chinacloudapp.cn:8080/zhiKey/softController.do?getSoftService"
//#define kServer @"http://10.0.0.116:8080/zhiKey/appengController.do?enterService"
//#define kServer2 @"http://10.0.0.116:8080/zhiKey/softController.do?getSoftService"


@implementation NetworkingManager


//+(void)Login;

+(void)focusNetWorkError{
    
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    
    hud.textLabel.text = @"无法连接服务器,请检查网络连接";
    hud.indicatorView = nil;
    
    hud.tapOutsideBlock = ^(JGProgressHUD *hud){
        [hud dismiss];
    };
    
    hud.tapOnHUDViewBlock = ^(JGProgressHUD *hud){
        [hud dismiss];
    };

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [hud showInView:delegate.window];
    [hud dismissAfterDelay:2.0];
    
}

+(void)login:(NSString*)account withPassword:(NSString *)password withCompletionHandler:(NetWorkHandler)completionHandler FailHandler:(NetWorkFailHandler)failHandler{
    
    NSString * param = [@{@"phone":account,@"password":password} bv_jsonStringWithPrettyPrint:YES];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"20",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}


+(void)registerCellphone:(NSString*)phone password:(NSString*)password inviteCode:(NSString*)inviteCode chinaID:(NSString*)chinaID verifyCode:(NSString*)verifyCode withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    
    NSString * param = [@{@"phone":phone,@"password":password,@"invitecode":inviteCode,@"idcard":chinaID,@"code":verifyCode} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"10",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}



+(void)fetchRegisterVerifyCode:(NSString*)cellphoneNumber withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    
    NSString * param = [@{@"phone":cellphoneNumber} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"11",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}

+(void)fetchForgetPasswordVerifyCode:(NSString*)cellphoneNumber withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"phone":cellphoneNumber} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"50",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];

}

+(void)fetchModifyPasswordVerifyCode:(NSString*)cellphoneNumber withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"phone":cellphoneNumber} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"51",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];

}
+(void)ModifyPasswordwithNewPassword:(NSString*)password verifyCode:(NSString*)code withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"newpassword":password,@"id":[AccountManager getTokenID],@"code":code} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"32",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}

+(void)forgetPasswordOnCellPhone:(NSString*)cellphone password:(NSString*)password verifyCode:(NSString*)code withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"phone":cellphone,@"newpassword":password,@"code":code} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"31",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}

+(void)fetchGradeByTokenID:(NSString*)tokenID withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"id":tokenID} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"33",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}
+(void)fetchInviteByTokenID:(NSString*)tokenID withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"id":tokenID} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"34",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}

+(void)fetchApplicationwithCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer2 parameters:nil success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}

+(void)fetchOrderwithCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    
     NSString * param = [@{@"id":[AccountManager getTokenID]} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"41",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];

}

+(void)disableOrderByID:(NSString *)orderID withcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"orderid":orderID} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"42",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}

+(void)revokeOrderID:(NSString *)orderID ByTokenID:(NSString*)tokenID withcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"orderid":orderID,@"id":tokenID} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"43",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}

+(void)submitOrderDictionary:(NSDictionary*)order bill:(NSDictionary*)bill applist:(NSArray*)applist source:(NSNumber*)source withcompletionHandler:(NetWorkHandler)completionHandler failHandle:(NetWorkFailHandler)failHandler{

    
    NSString * param = [@{@"order":order,@"bill":bill,@"source":source,@"applist":applist} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"44",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
    
}

+(void)modifyInfowithGender:(NSInteger)gender name:(NSString *)name address:(NSString *)address withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    
    NSString * param = [@{@"gender":@(gender),@"name":name,@"address":address,@"id":[AccountManager getTokenID]} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"30",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];

}

+(void)fetchCompletedOrderListByRow:(NSInteger)row withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString * param = [@{@"row":@(row),@"id":[AccountManager getTokenID]} bv_jsonStringWithPrettyPrint:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:kServer parameters:@{@"action":@"45",@"param":param} success:completionHandler failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self focusNetWorkError];
        failHandler(operation,error);
    }];
}



+(NSDictionary *)createOrderDictionaryByOrderID:(NSString *)orderID phone:(NSString*)phone paymodel:(NSNumber*)paymodel source:(NSNumber*)source address:(NSString*)address brand:(NSString*)brand engineer:(NSString*)engineer mac:(NSString*)mac hoster:(NSString*)hoster size:(NSString*)size version:(NSString *)version type:(NSNumber *)type createdate:(NSString *)createdate{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    dic[@"id"] = @1;
    dic[@"orderid"] =orderID;
    dic[@"phone"] = phone;
    dic[@"paymodel"] = paymodel;
    dic[@"source"] = source;
    dic[@"address"] = address;
    dic[@"brand"] = brand;
    dic[@"engineer"] = engineer;
    dic[@"mac"] = mac;
    dic[@"hoster"] = hoster;
    dic[@"size"] = size;
    dic[@"version"] = version;
    dic[@"type"] = type;
    dic[@"createdate"] = createdate;
    dic[@"status"] = @1;


    
    return dic;
};
+(NSDictionary*)createBillbyHostphone:(NSString*)hostphone zjservice:(NSNumber*)zjservice sczkfei:(NSNumber*)sczkfei zhijia:(NSNumber*)zhijia hdmi:(NSNumber*)hdmi yiji:(NSNumber*)yiji{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    dic[@"hostphone"] =hostphone;
    dic[@"zjservice"] =zjservice;
    dic[@"sczkfei"] = sczkfei;
    dic[@"zhijia"] = zhijia;
    dic[@"hmdi"] = hdmi;
    dic[@"yiji"] = yiji;
    
    
    return dic;

}


+(void)getMacAddressFromTV:(NSString*)IPAddress WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    
    NSString *IP = [NSString stringWithFormat:@"http://%@:7766/getEmpinfo",IPAddress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:IP parameters:nil success:completionHandler failure:failHandler];
 
}

+(void)getTVApplist:(NSString*)IPAddress WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString *IP = [NSString stringWithFormat:@"http://%@:7766/getappinfo",IPAddress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:IP parameters:nil success:completionHandler failure:failHandler];
}

+(void)OneKeyInstall:(NSString*)IPAddress WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    NSString *IP = [NSString stringWithFormat:@"http://%@:7766/install",IPAddress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:IP parameters:nil success:completionHandler failure:failHandler];

}

+(void)selectAppToInstall:(NSString*)apkurl ipaddress:(NSString*)IPAddress WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler{
    
    NSString *IP = [NSString stringWithFormat:@"http://%@:7766/customizationinstall",IPAddress];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:IP parameters:@{@"apkurl":apkurl} success:completionHandler failure:failHandler];
}




@end
