//
//  ViewController.m
//  Live
//
//  Created by lin on 16/9/26.
//  Copyright © 2016年 biqinglin. All rights reserved.
//

/** LJKMediaFramework我已经编译好了*/

#import "ViewController.h"
#import "StartLiveController.h"
#import "WatchLiveController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 开启直播(只能在真机开启)
- (IBAction)startLive:(id)sender {
    
    StartLiveController *start = [[StartLiveController alloc] init];
    [self presentViewController:start animated:YES completion:nil];
}

// 观看直播
- (IBAction)watchLive:(id)sender {
    
    WatchLiveController *watch = [[WatchLiveController alloc] init];
    [self presentViewController:watch animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
