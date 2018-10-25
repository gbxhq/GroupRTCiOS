//
//  AppDelegate.m
//  RTCWebSocketDemo
//
//  Created by Goku on 2018/9/12.
//  Copyright © 2018年 sipsys. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
   SRWebSocket *_webSocket;
    Participate *localParticipant;
    //存放所有参与者
    NSMutableDictionary *Participants;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化字典存放Participants
    Participants = [[NSMutableDictionary alloc] init];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)connectWebSocket {
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"wss://192.168.139.218:8443/groupcall"]];
    _webSocket.delegate = self;
    [_webSocket open];
}

- (void)closeWebSocket {
    [_webSocket close];
    _webSocket = nil;
}

- (void)sendWebSocket:(NSString *)message{
    NSLog(@"【***Sending message***】: %@",message);
    [_webSocket sendString:message error:NULL];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Websocket Connected");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@":( Websocket Failed With Error %@", error);
    _webSocket = nil;
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(nonnull NSString *)string {
    NSLog(@"【***Received message***】: %@ ", string);
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *messageId = [rootDictionary objectForKey:@"id"];
    
    if ([messageId isEqualToString:@"existingParticipants"]) {
        [self onExistingParticipants:rootDictionary];
    } else if ([messageId isEqualToString:@"newParticipantArrived"]) {
        [self onNewParticipant:rootDictionary];
    } else if ([messageId isEqualToString:@"participantLeft"]) {
        [self onParticipantLeft:rootDictionary];
    } else if ([messageId isEqualToString:@"receiveVideoAnswer"]) {
        [self receiveVideoResponse:rootDictionary];
    } else if ([messageId isEqualToString:@"iceCandidate"]) {
        //取出iceCandidate的name
        NSString *name = [rootDictionary objectForKey:@"name"];
        //创建candidate 需要先提取三个创建参数： candidate、sdpMid和sdpMLineIndex
        NSDictionary *candidateDic = rootDictionary[@"candidate"];

        NSString *sdp = candidateDic[@"candidate"];
        NSString *sdpMid = candidateDic[@"sdpMid"];
        int sdpMLineIndex = [candidateDic[@"sdpMLineIndex"] intValue];

        RTCIceCandidate *candidate = [[RTCIceCandidate alloc] initWithSdp:sdp sdpMLineIndex:sdpMLineIndex sdpMid:sdpMid];
        
//        [[[Participants objectForKey:name] rtcPeer] addICECandidate:candidate];
        [[Participants[name] rtcPeer] addIceCandidate:candidate];

    } else {
        NSLog(@"webSocket didReceiveMessageWithString:%@",messageId);
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"WebSocket closed");
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"WebSocket received pong");
}

#pragma mark - 客户端发送的Message
- (void)register:(NSString*) name Room:(NSString*) room{
    _myName = name;
    _myRoom = room;
    
    //TODO：--------------房间号、视频框---------------
    
    //生成Message包
    NSString *message = nil;
//    NSMutableDictionary *dict = [NSMutableDictionary new];
//    [dict setObject:@"joinRoom" forKey:@"id"];
//    [dict setObject:_myName forKey:@"name"];
//    [dict setObject:                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    _myRoom forKey:@"room"];
    NSDictionary *dict = @{@"id":@"joinRoom",@"name":_myName,@"room":_myRoom};
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        message =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    //发送Message
    [self sendWebSocket:message];

}//------------------------------------Completed 99%

- (void)leaveRoom{
    [self sendWebSocket:@"id:leaveRoom"];
    //清空字典
    [Participants removeAllObjects];

    [self closeWebSocket];
}//------------------------------------Completed

- (void) receiveVideo:(NSString*)remoteName{
    NSLog(@"New Participant %@ \n Count: %ld",remoteName,[Participants count]);
    //新建Participate
    Participate *remoteParticipant = [[Participate alloc] initWithName:remoteName];
    //存入数组
    [Participants setObject:remoteParticipant forKey:remoteName];
    //TODO：接Video rtcPeer
    
}

#pragma mark - 客户端接受的的Message
- (void)onExistingParticipants:(NSDictionary *)messageDic{
    
    //TODO: 对对象窗口进行约束。设置长宽高等参数
    
    //创建本地Participate对象。
    localParticipant = [[Participate alloc] initWithName:_myName];
    
    NSLog(@"Participant %@ is registed",[localParticipant name]);
    //本地Participate对象 存入字典
//    [Participants setObject:localParticipant forKey:_myName];
    Participants[_myName]=localParticipant;
    NSLog(@"Participants Count: %ld",[Participants count]);
    
    //TODO：获取Video
    
    //TODO: 对messageDic里的data部分(就是房间已经存在的参与者name) 挨个执行receiveVideo
    NSArray *messageData = [messageDic objectForKey:@"data"];
    for(id eachParticipant in messageData){
        [self receiveVideo:eachParticipant];
    }
}

- (void) onNewParticipant:(NSDictionary *)messageDic{
    NSString *remoteName = [messageDic objectForKey:@"name"];
    
    [self receiveVideo:remoteName];
}//---onExistingParticipants Completed

- (void) onParticipantLeft:(NSDictionary *)messageDic{
    NSString *remoteName = [messageDic objectForKey:@"name"];
    NSLog(@"Participant %@ left",remoteName);
    //销毁 对象
    //没有网上说的release方法啊。。。先不销毁了。
    [Participants removeObjectForKey:remoteName];
}//---onParticipantLeft Completed

- (void) receiveVideoResponse:(NSDictionary *)messageDic{
    //NSString *remoteName = [messageDic objectForKey:@"name"];
    //TODO:
    //[[Participants objectForKey:remoteName] rtcPeer方法 处理Answer]
}

@end
