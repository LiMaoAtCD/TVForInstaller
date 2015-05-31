//
//  ComminUtility.h
//  TVForInstaller
//
//  Created by AlienLi on 15/5/19.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ComminUtility : NSObject


/**
 *  配置navigationBar
 *
 *  @param title 标题
 *  @param vc    viewcontroller
 */


+(void)configureTitle:(NSString*)title forViewController:(UIViewController*)vc;
/**
 *  验证身份证号是否合法
 *
 *  @param identityCard 身份证号
 *
 *  @return none
 */
+(BOOL)validateIdentityCard: (NSString *)identityCard;

/**
 *  验证手机号码
 *
 *  @param str none
 *
 *  @return none
 
 */
+(BOOL)checkTel:(NSString *)str;
/**
 *  验证密码位数
 *
 *  @param password 6——18位数字字母
 *
 *  @return nil
 */
+ (BOOL)checkPassword:(NSString *) password;


+(NSString*)kSuspensionWindowNotification;

+(void)setSwitchKit:(BOOL)on;
+(BOOL)isSwitchKitOn;

@end
