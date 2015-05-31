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
 *  注册获取验证码
 *
 *  @param cellphoneNumber   手机号码
 *  @param completionHandler 成功回调
 *  @param failHandler       失败回调
 */
+(void)fetchRegisterVerifyCode:(NSString*)cellphoneNumber withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


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


/**
 *  积分查询
 *
 *  @param tokenID           token
 *  @param completionHandler ok
 *  @param failHandler       fail
 */
+(void)fetchGradeByTokenID:(NSString*)tokenID withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  请求邀请码
 *
 *  @param tokenID           token
 *  @param completionHandler
 *  @param failHandler
 */
+(void)fetchInviteByTokenID:(NSString*)tokenID withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  获取应用列表
 *
 *  @param completionHandler 完成
 *  @param failHandler       网络请求失败
 */
+(void)fetchApplicationwithCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  获取今日订单
 *
 *  @param completionHandler
 *  @param failHandler
 */
+(void)fetchOrderwithCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  失效订单
 *
 *  @param orderID           失效订单号
 *  @param completionHandler
 *  @param failHandler
 */
+(void)disableOrderByID:(NSString *)orderID withcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  撤销订单
 *
 *  @param orderID           需要撤销的订单号
 *  @param tokenID           装机工订单
 *  @param completionHandler
 *  @param failHandler
 */
+(void)revokeOrderID:(NSString *)orderID ByTokenID:(NSString*)tokenID withcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  提交订单
 *
 *  @param order       订单
 
 
 "order":{
 "id":"8a8080f44d840b74014d840e4b320001",
 "phone":"15525893698",
 "paymodel":0,
 "source":0,
 "address":"高新区环球中心北4区1806",
 "brand":"海信",
 "engineer":"8a8080f44d800a71014d800c6fb20000",
 "mac":null,
 "hoster":"董小帅",
 "size":"45寸",
 "version":"LED-udDF485699DS5F"
 },

 *  @param bill        账单
 
 "bill":{
 "hostphone":"18284596155",
 "zjservice":60,
 "sczkfei":100,
 "zhijia":0,
 "hmdi":0,
 "yiji":0
 },
 
 
 *  @param applist     app 列表 
 
 [
 {"appname":"ES文件浏览器"},
 {"appname":"电视极客"},
 {"appname":"优酷视频"},
 {"appname":"欢乐斗地主"}
 ]
 
 *  @param source      来源 0 公司派单 1私人订单
 *  @param handler
 *  @param failHandler
 */
+(void)submitOrderDictionary:(NSDictionary*)order bill:(NSDictionary*)bill applist:(NSArray*)applist source:(NSNumber*)source withcompletionHandler:(NetWorkHandler)handler failHandle:(NetWorkFailHandler)failHandler;

+(NSDictionary *)createOrderDictionaryByOrderID:(NSString *)orderID phone:(NSString*)phone paymodel:(NSNumber*)paymodel source:(NSNumber*)source address:(NSString*)address brand:(NSString*)brand engineer:(NSString*)engineer mac:(NSString*)mac hoster:(NSString*)hoster size:(NSString*)size version:(NSString *)version;
+(NSDictionary*)createBillbyHostphone:(NSString*)hostphone zjservice:(NSNumber*)zjservice sczkfei:(NSNumber*)sczkfei zhijia:(NSNumber*)zhijia hdmi:(NSNumber*)hdmi yiji:(NSNumber*)yiji;

/**
 *  忘记密码短信验证码接口
 *
 *  @param cellphoneNumber   手机号码
 *  @param completionHandler
 *  @param failHandler
 */
+(void)fetchForgetPasswordVerifyCode:(NSString*)cellphoneNumber withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  修改个人信息
 *
 *  @param gender            性别
 *  @param name              名字
 *  @param address           地址
 *  @param completionHandler
 *  @param failHandler
 */
+(void)modifyInfowithGender:(NSInteger)gender name:(NSString *)name address:(NSString *)address withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  获取mac地址
 *
 *  @param IPAddress         电视IP地址
 *  @param completionHandler
 *  @param failHandler
 */
+(void)getMacAddressFromTV:(NSString*)IPAddress WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  获取app列表
 *
 *  @param IPAddress         ip地址
 *  @param completionHandler
 *  @param failHandler
 */
+(void)getTVApplist:(NSString*)IPAddress WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;
@end
