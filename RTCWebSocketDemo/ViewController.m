//
//  ViewController.m
//  RTCWebSocketDemo
//
//  Created by Goku on 2018/9/12.
//  Copyright © 2018年 sipsys. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *roomText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}
- (void)viewDidAppear:(BOOL)animated{
    //每次回到界面都连接
    [(AppDelegate*)[UIApplication sharedApplication].delegate connectWebSocket];
    NSLog(@"连接WebSocket");
}

- (IBAction)btnJoin:(id)sender {
    
    //点击Join
    [(AppDelegate*)[UIApplication sharedApplication].delegate register:_nameText.text Room:_roomText.text];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
