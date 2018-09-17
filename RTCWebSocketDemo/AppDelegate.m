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
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self connectWebSocket];
    NSLog(@"启动");
    
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
    NSLog(@"webSocket Received \"%@\"", string);
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    NSString *messageId = [rootDictionary getStringValueForKey:@"id" defaultValue:@""];
    NSString *messageId = [rootDictionary objectForKey:@"id"];
    
    if ([messageId isEqualToString:@"existingParticipants"]) {
        NSLog(@"existingParticipants");
    } else if ([messageId isEqualToString:@"newParticipantArrived"]) {
        NSLog(@"newParticipantArrived");
    } else if ([messageId isEqualToString:@"participantLeft"]) {
        NSLog(@"participantLeft");
    } else if ([messageId isEqualToString:@"receiveVideoAnswer"]) {
        NSLog(@"receiveVideoAnswer");
    } else if ([messageId isEqualToString:@"iceCandidate"]) {
        NSLog(@"iceCandidate");
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

#pragma mark - TEST
- (void)test:(SRWebSocket *)webSocket {
        NSString *message = @"{id:\"joinRoom\",name:\"apple1\",room:\"1234\"}";
        [_webSocket sendString:message error:NULL];
}
@end
