//
//  AppDelegate.h
//  RTCWebSocketDemo
//
//  Created by Goku on 2018/9/12.
//  Copyright © 2018年 sipsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketRocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,SRWebSocketDelegate>

@property (strong, nonatomic) UIWindow *window;


#pragma mark 多方通话
- (void)connectWebSocket;
- (void)closeWebSocket;
- (void)sendWebSocket:(NSString *)message;

@end

