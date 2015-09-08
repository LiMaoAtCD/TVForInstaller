//
//  CustomPointAnnotation.h
//  TVForInstaller
//
//  Created by AlienLi on 15/7/16.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMKAnnotation.h>

@interface CustomPointAnnotation : NSObject<BMKAnnotation>{
    @package
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * uid;


//-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
