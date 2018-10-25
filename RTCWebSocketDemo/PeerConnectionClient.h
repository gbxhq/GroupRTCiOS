//
//  PeerConnectionClient.h
//  RTCWebSocketDemo
//
//  Created by 0x3 on 2018/10/17.
//  Copyright © 2018 sipsys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebRTC/WebRTC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeerConnectionClient : NSObject{

    //3个String定义在了 .m 里
    
    RTCPeerConnection *peetConnection;
    Boolean loopback;
    Boolean videoCallEnabled;
    NSString *partcipantName;
    Boolean isError;//= false; OC中Boolean参数默认false
    RTCPeerConnectionFactory *factory;
    RTCMediaConstraints *sdpMediaConstraints;
    RTCMediaConstraints *pcConstraints;
    //三个类好像是自定义的
    
    RTCMediaStream *localMediaStream;
    RTCMediaStream *remoteMediaStream;
    RTCVideoCapturer *videoCapturer;
    RTCVideoSource *videoSource;
    RTCVideoTrack *localVideoTrack;
    RTCAudioSource *audioSource;
    RTCAudioTrack *localAudioTrack;
    //VideodRender
}

//- (id)init: (RTCPeerConnectionFactory*)factory (Boolean);

@end


NS_ASSUME_NONNULL_END
