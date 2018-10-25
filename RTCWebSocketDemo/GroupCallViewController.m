//
//  GroupCallViewController.m
//  RTCWebSocketDemo
//
//  Created by 李炫杉 on 17/9/2018.
//  Copyright © 2018 sipsys. All rights reserved.
//

#import "GroupCallViewController.h"

@interface GroupCallViewController ()

@end

@implementation GroupCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)viewDidDisappear:(BOOL)animated {
    //离开房间
    [(AppDelegate*)[UIApplication sharedApplication].delegate leaveRoom];
}

@end
