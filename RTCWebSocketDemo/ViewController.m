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

- (IBAction)btnJoin:(id)sender {
    
    NSString *message = nil;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:@"joinRoom" forKey:@"id"];
    [dict setObject:_nameText.text forKey:@"name"];
    [dict setObject:_roomText.text forKey:@"room"];
   
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        message =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    NSLog(@"Send data:%@",message);
    
    [(AppDelegate*)[UIApplication sharedApplication].delegate sendWebSocket:message];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
