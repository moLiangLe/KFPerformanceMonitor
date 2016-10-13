//
//  ViewController.m
//  KFPerformanceMonitorDemo
//
//  Created by moLiang on 2016/10/13.
//  Copyright © 2016年 moliang. All rights reserved.
//

#import "ViewController.h"
#import "KFPerformaceMonitorBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [KFPerformaceMonitorBar sharedInstance].hidden = NO;
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
