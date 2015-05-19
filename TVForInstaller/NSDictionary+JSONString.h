//
//  NSDictionary+JSONString.h
//  TV
//
//  Created by AlienLi on 15/4/19.
//  Copyright (c) 2015年 tusm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;

@end
