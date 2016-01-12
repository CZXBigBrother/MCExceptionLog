//
//  MCMainViewController.m
//  exceptionLog
//
//  Created by 陈正星 on 16/1/7.
//  Copyright © 2016年 MarcoChen. All rights reserved.
//

#import "MCMainViewController.h"

#import "MCExceptionLogController.h"

@interface MCMainViewController ()

@end

@implementation MCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * OpenException = [UIButton buttonWithType:UIButtonTypeCustom];
    OpenException.frame = CGRectMake(0,100, self.view.frame.size.width, 100);
    [OpenException setTitle:@"OpenException" forState:UIControlStateNormal];
    [OpenException addTarget:self action:@selector(openCangth) forControlEvents:UIControlEventTouchUpInside];
    OpenException.backgroundColor = [UIColor redColor];
    [self.view addSubview:OpenException];
    
    UIButton * OpenxceptionLog = [UIButton buttonWithType:UIButtonTypeCustom];
    OpenxceptionLog.frame = CGRectMake(0,250, self.view.frame.size.width, 100);
    [OpenxceptionLog setTitle:@"ShowException" forState:UIControlStateNormal];
    [OpenxceptionLog addTarget:self action:@selector(showExeptionViewController) forControlEvents:UIControlEventTouchUpInside];
    OpenxceptionLog.backgroundColor = [UIColor redColor];
    [self.view addSubview:OpenxceptionLog];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openCangth {
    NSArray * arr = @[@123,@321];
    arr[4];
}
- (void)showExeptionViewController {
    MCExceptionLogController * exception = [[MCExceptionLogController alloc]init];
    [self presentViewController:exception animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
