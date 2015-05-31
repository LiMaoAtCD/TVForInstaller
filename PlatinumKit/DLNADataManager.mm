//
//  DLNADataManager.m
//  TV
//
//  Created by tusm on 15/5/20.
//  Copyright (c) 2015年 tusm. All rights reserved.
//

#import "DLNADataManager.h"

@implementation DLNADataManager

+(instancetype)DefaultDataManager{
    static DLNADataManager *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingleton = [[DLNADataManager alloc] init];
        
    });
    return sharedSingleton;
}

- (id)init
{
    if(self = [super init])
    {
        mediainfo = NULL;
        positioninfo = NULL;
    }
    return self;
}

- (void)setMediaInfo:(PLT_MediaInfo *)info
{
    mediainfo = info;
}
- (void)setPositionInfo:(PLT_PositionInfo *)info
{
    positioninfo = info;
}

- (PLT_MediaInfo *)getMediaInfo
{
    return mediainfo;
}

- (PLT_PositionInfo *)getPostionInfo
{
    return positioninfo;
}

@end
