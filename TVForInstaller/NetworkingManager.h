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
typedef AFHTTPRequestOperation NetWorkOperation;
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
 *  @param name              姓名
 *  @param completionHandler 成功回调
 *  @param failHandler       失败回调
 */
+(void)registerCellphone:(NSString*)phone password:(NSString*)password inviteCode:(NSString*)inviteCode chinaID:(NSString*)chinaID verifyCode:(NSString*)verifyCode name:(NSString *)name withCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;
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

/**
 *  创建订单
 *
 *  @param orderID  订单ID
 *  @param phone    电话
 *  @param paymodel 支付方式
 *  @param source   派单方式
 *  @param address  地址
 *  @param brand    品牌
 *  @param engineer 工程师ID
 *  @param mac      mac地址
 *  @param hoster   户主名字
 *  @param size     尺寸
 *  @param version  版本
 *
 *  @return 字典
 */
+(NSDictionary *)createOrderDictionaryByOrderID:(NSString *)orderID phone:(NSString*)phone paymodel:(NSNumber*)paymodel source:(NSNumber*)source address:(NSString*)address brand:(NSString*)brand engineer:(NSString*)engineer mac:(NSString*)mac hoster:(NSString*)hoster size:(NSString*)size version:(NSString *)version type:(NSNumber *)type createdate:(NSString *)createdate;

/**
 *  订单
 *
 *  @param hostphone 电话号码
 *  @param zjservice 装机服务费
 *  @param sczkfei   钻孔费
 *  @param zhijia    支架
 *  @param hdmi      hdmi线
 *  @param yiji      移机费
 *
 *  @return 
 */
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
 *  修改密码短信接口
 *
 *  @param cellphoneNumber
 *  @param completionHandler
 *  @param failHandler
 */
+(void)fetchModifyPasswordVerifyCode:(NSString*)cellphoneNumber withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

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
 *  获取已完成列表
 *
 *  @param row               row
 *  @param completionHandler
 *  @param failHandler
 */
+(void)fetchCompletedOrderListByCurrentPage:(NSString*)curpage withComletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  我的下级
 *
 *  @param completionHandler
 *  @param failHandler
 */
+(void)fetchMyChildrenListwithCompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

#pragma mark - 获取电视信息接口


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

/**
 *  一件装机
 *
 *  @param IPAddress         ip
 *  @param completionHandler
 *  @param failHandler
 */
+(void)OneKeyInstall:(NSString*)IPAddress WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  定制装机
 *
 *  @param apkurl            APK地址
 *  @param IP                ip 地址
 *  @param completionHandler
 *  @param failHandler
 */
+(void)selectAppToInstall:(NSString*)apkurl ipaddress:(NSString*)IPAddress WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;



/**
 *  百度POI云检索
 *
 *  @param location          地址
 *  @param radius            半径
 *  @param tags              关键字
 *  @param pageIndex         索引
 *  @param pageSize          个数
 *  @param completionHandler
 *  @param failHandler
 */
+(void)fetchNearbyOrdersByLocation:(NSString *)location radius:(NSInteger)radius tags:(NSString*)tags pageIndex:(NSInteger)pageIndex  pageSize:(NSInteger)pageSize WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;



/**
 *  云检索(后台)
 *
 *  @param latitude          纬度
 *  @param longitude         经度
 *  @param completionHandler
 *  @param failHandler
 */
+(void)fetchNearByOrdersByLatitude:(double)latitude Logitude:(double)longitude WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;

/**
 *  百度占用订单&取消咱用
 *
 *  @param ID                占用订单ID
 *  @param latitude          纬度
 *  @param longitude         经度
 *  @param order_state       修改订单状态
 *  @param completionHandler
 *  @param failHandler       
 */
+(void)ModifyOrderStateByID:(NSString *)ID latitude:(double)latitude longitude:(double)longitude order_state:(NSString*)order_state WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  接单(后台)
 *
 *  @param ID                uid
 *  @param engineerid        engineerid
 *  @param completionHandler
 *  @param failHandler
 */
+(void)GetTheOrderByID:(NSString *)ID WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;
/**
 *  取消订单
 *
 *  @param ID                uid
 *  @param completionHandler
 *  @param failHandler
 */
+(void)CancelOrderByID:(NSString*)ID  WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;










/**
 *  检查当前订单是否已被暂用
 *
 *  @param ID                ID
 *  @param completionHandler
 *  @param failHandler
 */
+(void)CheckOrderisOccupiedByID:(NSString*)ID WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  发起支付请求
 *
 *  @param uid               百度订单主键
 *  @param engineer_id       工程师ID
 *  @param totalFee          费用
 *  @param pay_type          weixin or alipay

 *  @param completionHandler
 *  @param failHandler
 */
+(void)BeginPayForUID:(NSString*)uid byEngineerID:(NSString *)engineer_id totalFee:(NSString *)totalFee pay_type:(NSString *)pay_type WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  微信支付
 *
 *  @param uid               uid
 *  @param totalFee          总共费用
 *  @param tvid              tvid
 *  @param completionHandler
 *  @param failHandler
 */
+(void)BeginWeChatPayForUID:(NSString*)uid totalFee:(NSString *)totalFee tvid:(NSString *)tvid WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  支付宝支付
 *
 *  @param uid               uid
 *  @param totalFee          总共费用
 *  @param tvid              uvid
 *  @param completionHandler
 *  @param failHandler
 */
+(void)BeginAliPayForUID:(NSString*)uid totalFee:(NSString *)totalFee tvid:(NSString *)tvid WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;
/**
 *  现金支付
 *
 *  @param uid               uid
 *  @param totalFee          费用
 *  @param tvid              tvid
 *  @param completionHandler
 *  @param failHandler
 */
+(void)BeginCashPayForUID:(NSString*)uid totalFee:(NSString *)totalFee tvid:(NSString *)tvid WithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  查询自己进行中的订单
 *
 *  @param completionHandler
 *  @param failHandler
 */
+(NetWorkOperation *)FetchOngongOrderWithcompletionHandler:(NetWorkHandler)completionHandler failHandler:(NetWorkFailHandler)failHandler;


/**
 *  上传头像
 *
 *  @param completionHandler
 *  @param fail
 */
+(void)fetchAvatarImageTokenWithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;

/**
 *  取消订单
 *
 *  @param uid               UID
 *  @param completionHandler
 *  @param fail
 */
+(void)CancelOrderByUID:(NSString *)uid WithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;


/**
 *  占用/取消占用订单
 *
 *  @param uid               uid
 *  @param engineerid
 *  @param orderstate
 *  @param completionHandler
 *  @param fail
 */
+(void)OccupyOrderOrCancelByUID:(NSString *)uid engineerid:(NSString*)engineerid orderstate:(NSString *)orderstate WithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;


/**
 *  查询正在进行的订单
 *
 *  @param completionHandler
 *  @param fail
 */
+(void)FetchOnGoingOrderWithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;

/**
 *  获取今日订单
 *
 *  @param completionHandler
 *  @param fail
 */
+(void)fetchTodayOrdersWithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;

/**
 *  上传设备二维码
 *
 *  @param deviceNumber      设备ma
 *  @param orderID           订单编号
 *  @param completionHandler
 *  @param fail
 */
+(void)uploadDeviceNumber:(NSString *)deviceNumber orderID:(NSString *)orderID WithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;

/**
 *  获取已完成订单(取消地图抢单)
 *
 *  @param pageNumber        页数
 *  @param completionHandler
 *  @param fail
 */
+(void)FetchCompletedOrderByPageNumber:(NSInteger)pageNumber WithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;

/**
 *  获取已完成订单详情
 *
 *  @param date              日期
 *  @param completionHandler
 *  @param fail
 */
+(void)fetchFinishedOrdersByDate:(NSString *)date WithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;

/**
 *  将订单发送至手机app
 *
 *  @param completionHandler
 *  @param fail
 */
+(void)uploadOrderInfoToAPPByOrderID:(NSString*)orderID WithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;

/**
 *  提交订单
 *
 *  @param orderId           订单编号
 *  @param fee               费用
 *  @param completionHandler
 *  @param fail
 */
+(void)sumitOrderID:(NSString*)orderId andFee:(NSString*)fee WithCompletionHandler:(NetWorkHandler)completionHandler failedHander:(NetWorkFailHandler)fail;
@end
