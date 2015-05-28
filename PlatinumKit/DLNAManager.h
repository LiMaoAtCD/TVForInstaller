//
//  DLNAManager.h
//  Platinum
//
//  Created by AlienLi on 15/4/14.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Platinum/Platinum.h>
#include "PltMicroMediaController.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef enum : NSUInteger {
    Music,
    Photo,
    Video,
} ResourceType;

@interface DLNAManager : NSObject{
    PLT_UPnP *upnpS;
    PLT_UPnP *upnpC;
    PLT_MicroMediaController *mediaController;
    NPT_Lock<PLT_DeviceMap> deviceList;
    NSMutableArray *RendererArray;
    NPT_String uuid;

}

//初始化
+(instancetype)DefaultManager;

- (PLT_MicroMediaController *)getMediaController;

//将设备指定成DMS和DMC
-(void)transferDeviceToBeServerAndControlPoint;

-(void)startServer;
-(void)stoprServer;
-(void)getServerResources;
-(NSArray*)getRendererResources;
-(NSString *)getCurrentSpecifiedRenderer;

-(void)specifyRendererName:(NSString *) renderName;
-(void)specifyFileInDMSName:(NSString *)name;
-(void)specifyFileToSend:(NSString *)name;
-(void)specifyURL:(NSURL*)url;

-(void)specifyRenderer:(NSInteger) index;
-(void)specifyFileInDMS:(NSInteger) index;


-(NSArray*)fetchLocalFilesfromDMS;
-(NSArray*)fetchLocalFilesfromServer:(ResourceType)resourceType;


-(NSString *)getCurRenderIpAddress;

-(BOOL)didSetDMRenderer;
-(BOOL)didSetDMServer;

- (void)play;
- (void)stop;
- (void)pause;
- (void)getvolume;
- (void)setvolume:(int)volume;
- (void)getmediainfo;
- (void)getpositoninfo;
- (void)seek:(NSString *)time;

@end
