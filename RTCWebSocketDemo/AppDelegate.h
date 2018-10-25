//
//  AppDelegate.h
//  RTCWebSocketDemo
//
//  Created by Goku on 2018/9/12.
//  Copyright © 2018年 sipsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketRocket.h"
#import "ViewController.h"
#import "Participate.h"

#import "WebRTC/RTCPeerConnection.h"
#import "WebRTC/RTCICECandidate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SRWebSocketDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;
//@property Participate *localParticipant;
@property NSString *myName;
@property NSString *myRoom;

#pragma mark 多方通话
- (void)connectWebSocket;
- (void)closeWebSocket;
- (void)sendWebSocket:(NSString *)message;

- (void)register:(NSString*) name Room:(NSString*) room;
- (void)leaveRoom;

@end

