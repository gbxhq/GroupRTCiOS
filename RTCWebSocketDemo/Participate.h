//
//  Participate.h
//  RTCWebSocketDemo
//
//  Created by 李炫杉 on 19/9/2018.
//  Copyright © 2018 sipsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "WebRTC/RTCPeerConnection.h"

@interface Participate : NSObject{
    NSString *name;
}

@property RTCPeerConnection *rtcPeer;

- (NSString*) name;    //返回name的方法
- (id)initWithName:(NSString *)str;   //用name创建对象的方法

//TODO： 取视频 生成聊天窗口
- (void)getElement;
- (void)getVideoElement;

//发送”receiveVideoFrom“数据包
- (void)offerToReceiveVideo:(NSString *)offerSdp Error:(NSString *)error;

//发送“onIceCandidate“数据包
- (void)onIceCandidate:(NSString *)candidate;

//Object.defineProperty(this, 'rtcPeer', { writable: true});

- (void)dispose;
@end
