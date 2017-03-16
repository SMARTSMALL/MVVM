//
//  ViewController.m
//  MVVMDemo
//
//  Created by goldeneye on 2017/3/16.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import "ViewController.h"
#import "MessageController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    MessageController * viewController = [[MessageController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
