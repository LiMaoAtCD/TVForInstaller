//
//  DLNADataManager.h
//  TV
//
//  Created by tusm on 15/5/20.
//  Copyright (c) 2015年 tusm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Platinum/Platinum.h>

@interface DLNADataManager : NSObject
{
    PLT_MediaInfo *mediainfo;
    PLT_PositionInfo *positioninfo;
}

+(instancetype)DefaultDataManager;

- (void)setMediaInfo:(PLT_MediaInfo *)info;
- (void)setPositionInfo:(PLT_PositionInfo *)info;

- (PLT_MediaInfo *)getMediaInfo;
- (PLT_PositionInfo *)getPostionInfo;

@end
