//
//  Participate.m
//  RTCWebSocketDemo
//
//  Created by 李炫杉 on 19/9/2018.
//  Copyright © 2018 sipsys. All rights reserved.
//

#import "Participate.h"

@implementation Participate

- (NSString *)name{
    return name;
}

- (id) initWithName:(NSString *)str{
    if (self=[super init]){
        name = str;
    }
    //TODO：
    //还需要为Participate对象初始化 video rtcPeer等
    
    return self;
}
- (void)getElement{
    //TODO
}
- (void)getVideoElement{
    //TODO
}

//发送”receiveVideoFrom“数据包
- (void)offerToReceiveVideo:(NSString *)offerSdp Error:(NSError *)error{
    if(error){
        NSLog(@"SDP Offer ERROR");
    }
    NSLog(@"Invoking SDP offer callback function");
    //生成Message包
    NSString *message = nil;
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:@"receiveVideoFrom" forKey:@"id"];
//    [dict setObject:[self name] forKey:@"sender"];
//    [dict setObject:offerSdp forKey:@"sdpOffer"];
    NSDictionary *dict = @{@"id":@"receiveVideoFrom",@"sender":[self name],@"sdpOffer":offerSdp};
    //转字符串
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        message =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    //发送
    [(AppDelegate*)[UIApplication sharedApplication].delegate sendWebSocket:message];
}

//发送“onIceCandidate“数据包
- (void)onIceCandidate:(NSString *)candidate{
    //TODO : candidate传进来在Log输出时解一下JSON 我就先直接输出了
    NSLog(@"Local candidate %@",candidate);
    //生成Message包
    NSString *message = nil;
    NSDictionary *dict = @{@"id":@"onIceCandidate",@"candidate":candidate,@"sender":[self name]};
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        message =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    //发送
    [(AppDelegate*)[UIApplication sharedApplication].delegate sendWebSocket:message];
}


- (void)dispose{
    //TODO： 销毁rtcPeer 销毁容器里的视频框
    NSLog(@"Disposing participant %@",[self name]);
}
@end
