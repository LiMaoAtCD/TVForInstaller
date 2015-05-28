//
//  DLNAManager.m
//  Platinum
//
//  Created by AlienLi on 15/4/14.
//  Copyright (c) 2015年 AlienLi. All rights reserved.
//

#import "DLNAManager.h"
#include <string.h>

@implementation DLNAManager

//static const char * deviceName;


+(instancetype)DefaultManager{
    
    static DLNAManager *sharedSingleton = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedSingleton = [[DLNAManager alloc] init];
        
//        [sharedSingleton transferDeviceToBeServerAndControlPoint];
        
        sharedSingleton->RendererArray = [[NSMutableArray alloc] init];

    });
    return sharedSingleton;
}



-(void)createControlPoint{
    
    NPT_LogManager::GetDefault().Configure("plist:.level=FINE;.handlers=ConsoleHandler;.ConsoleHandler.colors=off;.ConsoleHandler.filter=42");
    PLT_Constants::GetInstance().SetDefaultDeviceLease(NPT_TimeInterval(60.));
    // Create control point
    upnpC = new PLT_UPnP();
    
    PLT_CtrlPointReference ctrlPoint(new PLT_CtrlPoint());
    mediaController = new PLT_MicroMediaController(ctrlPoint);
    //    mediaController->setiPhoneName(deviceName);
    //    const char* name = mediaController->getiPhoneName();
    upnpC->AddCtrlPoint(ctrlPoint);
    upnpC->Start();

}

-(void)transferDeviceToBeServerAndControlPoint{
    
    NPT_LogManager::GetDefault().Configure("plist:.level=FINE;.handlers=ConsoleHandler;.ConsoleHandler.colors=off;.ConsoleHandler.filter=42");
    
    [self configureDMSOptions];
    
    /* for faster DLNA faster testing */
    PLT_Constants::GetInstance().SetDefaultDeviceLease(NPT_TimeInterval(60.));
    
    upnpS = new PLT_UPnP();
    
    PLT_DeviceHostReference device(
                                   new PLT_FileMediaServer(Options.path,Options.friendly_name,false,NULL,(NPT_UInt16)(Options.port))
                                   );
    NPT_List<NPT_IpAddress> list;
    PLT_UPnPMessageHelper::GetIPAddresses(list);

//    NPT_String ip = list.GetFirstItem()->ToString();
//    printf("%s",(const char*)ip);

    device->m_ModelDescription = "Platinum File Media Server";
    device->m_ModelURL = "http://www.plutinosoft.com/";
    device->m_ModelNumber = "1.0";
    device->m_ModelName = "Platinum File Media Server";
    device->m_Manufacturer = "Plutinosoft";
    device->m_ManufacturerURL = "http://www.plutinosoft.com/";
    
    upnpS->AddDevice(device);
    uuid = device->GetUUID();
    
    upnpS->Start();
    
    // Create control point
    upnpC = new PLT_UPnP();
    
    PLT_CtrlPointReference ctrlPoint(new PLT_CtrlPoint());
    mediaController = new PLT_MicroMediaController(ctrlPoint);
//    mediaController->setiPhoneName(deviceName);
//    const char* name = mediaController->getiPhoneName();
    upnpC->AddCtrlPoint(ctrlPoint);
    upnpC->Start();
}

- (PLT_MicroMediaController *)getMediaController
{
    return mediaController;
}

-(BOOL)didSetDMServer{
    
    int dms = self->mediaController->getDMS();
    
    if (dms == 1) {
        return YES;
    } else {
        return NO;
    }
}

-(void)startServer
{
    upnpS->Start();
    upnpC->Start();
}

-(void)stoprServer
{
    upnpS->Stop();
    upnpC->Stop();
}

-(void)stopService{
    upnpC->Stop();

}

-(void)getServerResources {
    
    if ([self didSetDMServer]) {
        NSLog(@"已经指定本机为DMS");
        return;
    }
    self->mediaController->LocalUUID = uuid;
    
    self->mediaController->setDMS();

}

-(NSString *)getCurrentSpecifiedRenderer{
    NSString *temp = [[NSString alloc] initWithCString:self->mediaController->getCurrentDMR() encoding:NSUTF8StringEncoding];
    
    if ([temp isEqualToString:@"none"]) {
        temp = @"无";
    }
    return temp;
}

-(NSArray*)getRendererResources{
    
//    self->mediaController->setDMR();
    deviceList = mediaController->m_MediaRenderers;
    NPT_AutoLock lock(mediaController->m_CurMediaRendererLock);
    PLT_StringMap            namesTable;
//    NPT_String               chosenUUID;
//    NPT_AutoLock             lock1(mediaController->m_MediaServers);
    // create a map with the device UDN -> device Name
    const NPT_List<PLT_DeviceMapEntry*>& entries = deviceList.GetEntries();
    NPT_List<PLT_DeviceMapEntry*>::Iterator entry = entries.GetFirstItem();
    while (entry)
    {
        PLT_DeviceDataReference device = (*entry)->GetValue();
       NPT_String              name   = device->GetFriendlyName();
      namesTable.Put((*entry)->GetKey(), name);
        ++entry;
    }
//    chosenUUID = ChooseRendererIDFromTable(namesTable);
    NPT_List<PLT_StringMapEntry*> entries1 = namesTable.GetEntries();
    if (entries1.GetItemCount() == 0)
    {
        printf("None available\n");
        return [NSArray array];
        
    }
    else
    {
        // display the list of entries
        NPT_List<PLT_StringMapEntry*>::Iterator entry1 = entries1.GetFirstItem();
        int count = 0;
        [RendererArray removeAllObjects];
        while (entry1)
        {
            
            printf("%d)\t%s (%s)\n", ++count, (const char*)(*entry1)->GetValue(), (const char*)(*entry1)->GetKey());
            NSString * entry1String = [[NSString alloc] initWithCString:(const char*)(*entry1)->GetValue() encoding:NSUTF8StringEncoding];
            [RendererArray addObject:entry1String];
            ++entry1;
        }
        return RendererArray;
    }
}



-(void)specifyRendererName:(NSString *) renderName{
    
    NPT_String               chosenUUID;
    PLT_DeviceDataReference* result = NULL;
    
    NSString * selectedRenderName = renderName;
    
    const char* chosenName = [selectedRenderName cStringUsingEncoding:NSUTF8StringEncoding];
    
    // create a map with the device UDN -> device Name
    const NPT_List<PLT_DeviceMapEntry*>& entries = deviceList.GetEntries();
    NPT_List<PLT_DeviceMapEntry*>::Iterator entry = entries.GetFirstItem();
    while (entry) {
        PLT_DeviceDataReference device = (*entry)->GetValue();
        NPT_String              name   = device->GetFriendlyName();
        if (strcmp((const char*)name, chosenName) == 0&& entry) {
            chosenUUID =  (*entry)->GetKey();
            printf("SelectMDR:::%s",(const char*)(name));
            break;
        }
        ++entry;
    }
    if (chosenUUID.GetLength()) {
        deviceList.Get(chosenUUID, result);
    }
    
    mediaController->m_CurMediaRenderer = result?*result:PLT_DeviceDataReference();
    if(result)
    {
        [[NSUserDefaults standardUserDefaults] setObject:selectedRenderName forKey:@"renderName"];
    }
}

-(void)specifyRenderer:(NSInteger) index{
    NPT_String               chosenUUID;
    PLT_DeviceDataReference* result = NULL;

    NSString * selectedRenderName = RendererArray[index];
    
    const char* chosenName = [selectedRenderName cStringUsingEncoding:NSUTF8StringEncoding];
    
    // create a map with the device UDN -> device Name
    const NPT_List<PLT_DeviceMapEntry*>& entries = deviceList.GetEntries();
    NPT_List<PLT_DeviceMapEntry*>::Iterator entry = entries.GetFirstItem();
    while (entry) {
        PLT_DeviceDataReference device = (*entry)->GetValue();
        NPT_String              name   = device->GetFriendlyName();
        if (strcmp((const char*)name, chosenName) == 0&& entry) {
            chosenUUID =  (*entry)->GetKey();
            printf("SelectMDR:::%s",(const char*)(name));
            break;
        }
        ++entry;
    }

    if (chosenUUID.GetLength()) {
        deviceList.Get(chosenUUID, result);
    }
    
    mediaController->m_CurMediaRenderer = result?*result:PLT_DeviceDataReference();
    if(result)
    {
        [[NSUserDefaults standardUserDefaults] setObject:selectedRenderName forKey:@"renderName"];
    }
}

-(NSString *)getCurRenderIpAddress
{
    if(!mediaController->m_CurMediaRenderer.IsNull())
    {
        NPT_HttpUrl url = mediaController->m_CurMediaRenderer->GetURLBase();
        NPT_String urlstr = url.GetHost();
        if(urlstr.GetLength() > 0)
        {
            NSString *temp = [NSString stringWithUTF8String:urlstr.GetChars()];
            return temp;
        }
    }
    return nil;
}


/*----------------------------------------------------------------------
 |   globals Device Configuration
 +---------------------------------------------------------------------*/
struct Options {
    const char* path;
    const char* friendly_name;
    const char* guid;
    NPT_UInt32  port;
} Options;




-(void)configureDMSOptions {
    
    NSString* docDir = NSTemporaryDirectory();
    
    const char *path = [docDir cStringUsingEncoding:NSASCIIStringEncoding];
    
    Options.path = path;
    
    UIDevice *device = [UIDevice currentDevice];
    const char * friendlyName = [[device name] cStringUsingEncoding:NSUTF8StringEncoding];
    Options.friendly_name = friendlyName;
    Options.port = 0;
    Options.guid = NULL;
    
}

//-(void)configureDMSOptions:(ResourceType)resourceType {
//    NSString* docDir;
//    
//    if (resourceType == Photo) {
//        docDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo"];
//
//    }else if (resourceType == Music){
//        docDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"music"];
//
//    } else if (resourceType == Video){
//        docDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"video"];
//    }
//    
//    const char *path = [docDir cStringUsingEncoding:NSUTF8StringEncoding];
//    Options.path = path;
//    
//    UIDevice *device = [UIDevice currentDevice];
//    const char * friendlyName = [[device name] cStringUsingEncoding:NSUTF8StringEncoding];
//    Options.friendly_name = friendlyName;
//    Options.port = 0;
//    Options.guid = NULL;
//}


-(NSArray*)fetchLocalFilesfromDMS{
    
    NSString *tempPath = NSTemporaryDirectory();
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tempPath error:nil];

    return fileList;
    
    
}
-(NSArray*)fetchLocalFilesfromServer:(ResourceType)resourceType{
    
    
    
    if (resourceType == Photo) {
        NSString *dataPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"photo"];
        NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:nil];
        return fileList;
    } else if (resourceType == Music){
        NSString *tempDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"music"];
        NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tempDir error:nil];
        return fileList;
    } else{
        NSString *tempDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"movie"];
        NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tempDir error:nil];
        return fileList;
    }
    

}

-(void)specifyFileInDMS:(NSInteger) index{
    
    NPT_String              object_id;
    PLT_StringMap           tracks;
    PLT_DeviceDataReference device;
    
    mediaController->GetCurrentMediaRenderer(device);
//    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        // get the protocol info to try to see in advance if a track would play on the device
        
        // issue a browse
        
        //DoBrowse;
        mediaController->DoBrowse();
        if (!mediaController->m_MostRecentBrowseResults.IsNull()) {
            // create a map item id -> item title
            NPT_List<PLT_MediaObject*>::Iterator item = mediaController->m_MostRecentBrowseResults->GetFirstItem();
            while (item) {
                if (!(*item)->IsContainer()) {
                    tracks.Put((*item)->m_ObjectID, (*item)->m_Title);
                }
                ++item;
            }
            // let the user choose which one
//            object_id = ChooseIDFromTable(tracks);
            
            NPT_List<PLT_StringMapEntry*> entries = tracks.GetEntries();
            if (entries.GetItemCount() == 0) {
                printf("None available\n");
            } else {
                // display the list of entries
                NPT_List<PLT_StringMapEntry*>::Iterator entry = entries.GetFirstItem();
                int count = 0;
                while (entry) {
                    printf("%d)\t%s (%s)\n", ++count, (const char*)(*entry)->GetValue(), (const char*)(*entry)->GetKey());
                    ++entry;
                }
                
                //选择index +1；
                index++;
                
                // find the entry back
                if (index != 0) {
                    entry = entries.GetFirstItem();
                    while (entry && --index) {
                        ++entry;
                    }
                    if (entry) {
                        object_id = (*entry)->GetKey();
                    }
                }
            }
            
            if (object_id.GetLength()) {
                // look back for the PLT_MediaItem in the results
                PLT_MediaObject* track = NULL;
                if (NPT_SUCCEEDED(NPT_ContainerFind(*mediaController->m_MostRecentBrowseResults, PLT_MediaItemIDFinder(object_id), track))) {
                    if (track->m_Resources.GetItemCount() > 0) {
                        // look for best resource to use by matching each resource to a sink advertised by renderer
                        NPT_Cardinal resource_index = 0;
                        if (NPT_FAILED(mediaController->FindBestResource(device, *track, resource_index))) {
                            printf("No matching resource\n");
                        }
                        
                        // invoke the setUri
                        printf("Issuing SetAVTransportURI with url=%s & didl=%s",
                               (const char*)track->m_Resources[resource_index].m_Uri,
                               (const char*)track->m_Didl);
                        
                        mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                        
                        mediaController->File_Play();
                    } else {
                        printf("Couldn't find the proper resource\n");
                    }
                    
                } else {
                    printf("Couldn't find the track\n");
                }
            }
            
            mediaController->m_MostRecentBrowseResults = NULL;
        }
        else
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"获取设备目录失败"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
            [alertview show];
        }
    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"设备已断开链接"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertview show];
    }
}



-(void)specifyFileInDMSName:(NSString *)name {
    
    const char *tempName = [name cStringUsingEncoding:NSUTF8StringEncoding];
    
    NPT_String              object_id = NPT_String(tempName);
    PLT_StringMap           tracks;
    PLT_DeviceDataReference device;
    
    mediaController->GetCurrentMediaRenderer(device);
    //    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        // get the protocol info to try to see in advance if a track would play on the device
        
        // issue a browse
        
        // DoBrowse;
        mediaController->DoBrowse();
        
        if (!mediaController->m_MostRecentBrowseResults.IsNull()) {
            // create a map item id -> item title
            NPT_List<PLT_MediaObject*>::Iterator item = mediaController->m_MostRecentBrowseResults->GetFirstItem();
            while (item) {
                if (!(*item)->IsContainer()) {
                    tracks.Put((*item)->m_ObjectID, (*item)->m_Title);
                }
                ++item;
            }
            // let the user choose which one
            //                        object_id = ChooseIDFromTable(tracks);
            
            NPT_List<PLT_StringMapEntry*> entries = tracks.GetEntries();
            if (entries.GetItemCount() == 0) {
                printf("None available\n");
            } else {
                // display the list of entries
                NPT_List<PLT_StringMapEntry*>::Iterator entry = entries.GetFirstItem();
                int count = 0;
                while (entry) {
                    printf("%d)\t%s (%s)\n", ++count, (const char*)(*entry)->GetValue(), (const char*)(*entry)->GetKey());
                    if (strcmp(tempName, (const char*)(*entry)->GetValue()) == 0) {
                        object_id = (*entry)->GetKey();
                        NSLog(@"tempName:%s",tempName);
                        
                        break;
                    }
                    ++entry;
                }
                if (object_id.GetLength()) {
                    // look back for the PLT_MediaItem in the results
                    PLT_MediaObject* track = NULL;
                    if (NPT_SUCCEEDED(NPT_ContainerFind(*mediaController->m_MostRecentBrowseResults, PLT_MediaItemIDFinder(object_id), track))) {
                        
                        if (track->m_Resources.GetItemCount() > 0) {
                            // look for best resource to use by matching each resource to a sink advertised by renderer
                            NPT_Cardinal resource_index = 0;
                            if (NPT_FAILED(mediaController->FindBestResource(device, *track, resource_index))) {
                                printf("No matching resource\n");
                            }
                            
                            // invoke the setUri
                            printf("Issuing SetAVTransportURI with url=%s & didl=%s",
                                   (const char*)track->m_Resources[resource_index].m_Uri,
                                   (const char*)track->m_Didl);
                            
                            mediaController->Stop(device, 0,NULL);
                
                            NPT_String name = device->GetFriendlyName();
                            NSString *namestr = [[NSString alloc] initWithCString:name.GetChars() encoding:NSUTF8StringEncoding];
                            if([namestr rangeOfString:@"Coocaa"].length > 0)
                            {
                                //有些设备要多设置几次才能获得正确的uri
                                mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                                mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                                mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                            }
                            mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                            mediaController->File_Play();
                        } else {
                            printf("Couldn't find the proper resource\n");
                        }
                        
                    } else {
                        printf("Couldn't find the track\n");
                    }
                }
                
                mediaController->m_MostRecentBrowseResults = NULL;
            }
        }
        else
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"获取设备目录失败"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
            [alertview show];
        }
    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"设备已断开链接"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertview show];
    }
}

-(void)specifyFileToSend:(NSString *)name {
    
    const char *tempName = [name cStringUsingEncoding:NSUTF8StringEncoding];
    
    NPT_String              object_id = NPT_String(tempName);
    PLT_StringMap           tracks;
    PLT_DeviceDataReference device;
    
    mediaController->GetCurrentMediaRenderer(device);
    //    GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        // get the protocol info to try to see in advance if a track would play on the device
        
        // issue a browse
        //DoBrowse;
        mediaController->DoBrowse();
        
        if (!mediaController->m_MostRecentBrowseResults.IsNull()) {
//             create a map item id -> item title
            NPT_List<PLT_MediaObject*>::Iterator item = mediaController->m_MostRecentBrowseResults->GetFirstItem();
            while (item) {
                if (!(*item)->IsContainer()) {
                    tracks.Put((*item)->m_ObjectID, (*item)->m_Title);
                }
                ++item;
            }
            // let the user choose which one
            //                        object_id = ChooseIDFromTable(tracks);
            
            NPT_List<PLT_StringMapEntry*> entries = tracks.GetEntries();
            if (entries.GetItemCount() == 0) {
                printf("None available\n");
            } else {
                // display the list of entries
                NPT_List<PLT_StringMapEntry*>::Iterator entry = entries.GetFirstItem();
                int count = 0;
                while (entry) {
                    printf("%d)\t%s (%s)\n", ++count, (const char*)(*entry)->GetValue(), (const char*)(*entry)->GetKey());
                    if (strcmp(tempName, (const char*)(*entry)->GetValue()) == 0) {
                        object_id = (*entry)->GetKey();
                        NSLog(@"tempName:%s",tempName);
                        
                        break;
                    }
                    ++entry;
                }
                if (object_id.GetLength()) {
                    // look back for the PLT_MediaItem in the results
                    PLT_MediaObject* track = NULL;
                    if (NPT_SUCCEEDED(NPT_ContainerFind(*mediaController->m_MostRecentBrowseResults, PLT_MediaItemIDFinder(object_id), track))) {
                        
                        if (track->m_Resources.GetItemCount() > 0) {
                            // look for best resource to use by matching each resource to a sink advertised by renderer
                            NPT_Cardinal resource_index = 0;
                            if (NPT_FAILED(mediaController->FindBestResource(device, *track, resource_index))) {
                                printf("No matching resource\n");
                            }
                            
                            // invoke the setUri
                            printf("Issuing SetAVTransportURI with url=%s & didl=%s",
                                   (const char*)track->m_Resources[resource_index].m_Uri,
                                   (const char*)track->m_Didl);
                            NPT_String name = device->GetFriendlyName();
                            NSString *namestr = [[NSString alloc] initWithCString:name.GetChars() encoding:NSUTF8StringEncoding];
                            if([namestr rangeOfString:@"Coocaa"].length > 0)
                            {
                                //有些设备要多设置几次才能获得正确的uri
                                mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                                mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                                mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                            }
                            mediaController->SetAVTransportURI(device, 0, track->m_Resources[resource_index].m_Uri, track->m_Didl, NULL);
                            mediaController->File_Play();
                        } else {
                            printf("Couldn't find the proper resource\n");
                        }
                        
                    } else {
                        printf("Couldn't find the track\n");
                    }
                }
                
                mediaController->m_MostRecentBrowseResults = NULL;
            }
        }
        else
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误"
                                                               message:@"获取设备目录失败"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
            [alertview show];
        }
    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"设备已断开链接"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertview show];
    }
}


-(BOOL)didSetDMRenderer{
    NSInteger temp = self->mediaController->getDMR();
    
    if (temp == 0) {
        return NO;
    }
    
    return YES;
}


-(void)specifyURL:(NSURL*)url {
    
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if(!mediaController->m_CurMediaRenderer.IsNull())
    {
        const char *URL = [url.absoluteString cStringUsingEncoding:NSUTF8StringEncoding];
        
        //                    mediaController->SetAVTransportURI(mediaController->m_CurMediaRenderer, 0, "http://video19.ifeng.com/video07/2013/11/11/281708-102-007-1138.mp4", track->m_Didl, NULL);
        //                mediaController->SetAVTransportURI(mediaController->m_CurMediaRenderer, 0, URL, track->m_Didl, NULL);
        mediaController->SetAVTransportURI(mediaController->m_CurMediaRenderer, 0, URL, NULL, NULL);
        
        if (!device.IsNull())
        {
            mediaController->Play(device, 0, "1", NULL);
        }
    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误"
                                                           message:@"设备已断开链接"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
        [alertview show];
    }
}

- (void)play
{
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        mediaController->Play(device, 0, "1", NULL);
    }
}

- (void)stop
{
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        mediaController->Stop(device, 0, NULL);
    }
}

- (void)pause
{
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        mediaController->Pause(device, 0, NULL);
    }
}

- (void)getvolume
{
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        mediaController->GetVolume(device, 0, "Master", NULL);
    }
}

- (void)setvolume:(int)volume
{
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        mediaController->SetVolume(device, 0, "Master", volume, NULL);
        //小米的盒子要多设置几次才能正确设置音量
        if(device.AsPointer()->GetFriendlyName().Find("小米")>=0)
        {
            mediaController->SetVolume(device, 0, "Master", volume, NULL);
            mediaController->SetVolume(device, 0, "Master", volume, NULL);
            mediaController->SetVolume(device, 0, "Master", volume, NULL);
        }
    }
}

- (void)seek:(NSString *)time
{
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        //mediaController->Seek(device, 0, (target.Find(":")!=-1)?"REL_TIME":"X_DLNA_REL_BYTE", target, NULL);
       const char *cs = [time cStringUsingEncoding:NSUTF8StringEncoding];
        mediaController->Seek(device, 0, "REL_TIME",cs, NULL);
    }
}

- (void)getmediainfo
{
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        mediaController->GetMediaInfo(device, 0, NULL);
        //mediaController->GetTransportInfo(device, 0, NULL);
    }
}

- (void)getpositoninfo
{
    PLT_DeviceDataReference device;
    mediaController->GetCurMediaRenderer(device);
    if (!device.IsNull()) {
        mediaController->GetPositionInfo(device, 0, NULL);
    }
}

@end
