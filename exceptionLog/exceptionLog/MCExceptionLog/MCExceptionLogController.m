//
//  MCExceptionLogController.m
//  exceptionLog
//
//  Created by 陈正星 on 16/1/7.
//  Copyright © 2016年 MarcoChen. All rights reserved.
//

#import "MCExceptionLogController.h"
#import "MCExceptionLog.h"
#define WEAKSELF  __weak typeof (self)weakSelf = self;
@interface MCExceptionLogController ()<UIScrollViewDelegate,UITextViewDelegate>
@property(nonatomic, weak)UITextView *mytext;
@end

@implementation MCExceptionLogController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createNav {
    UIView * nav = [[UIView alloc]init];
    nav.backgroundColor = [UIColor orangeColor];
    nav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    [self.view addSubview:nav];
    
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    back.backgroundColor = [UIColor grayColor];
    [nav addSubview:back];
    back.frame = CGRectMake(0, 0, 64, 64);
    
    UIButton * clear = [UIButton buttonWithType:UIButtonTypeCustom];
    [clear setTitle:@"clear" forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    clear.backgroundColor = [UIColor grayColor];
    [nav addSubview:clear];
    clear.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 64, 0, 64, 64);
    
    UITextView * message = [[UITextView alloc]init];
    MCExceptionLog * log = [MCExceptionLog sharedInstance];
    message.text = [log MCErrorLog];
    [self.view addSubview:message];
    message.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    message.editable = NO;
    _mytext = message;
    _mytext.scrollEnabled = YES;
    _mytext.delegate = self;
    if (_mytext.contentSize.height <= _mytext.frame.size.height) {
        _mytext.contentOffset = CGPointMake(0 , 0);
    }else {
        _mytext.contentOffset = CGPointMake(0 , _mytext.contentSize.height - _mytext.frame.size.height);
    }
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    NSLog(@"dealloc");
}
- (MCExceptionLog *)getInstance {
    return [MCExceptionLog sharedInstance];
}
- (void)clear {
    MCExceptionLog * log = [self getInstance];
    [log MCRemoveAllFile];
    _mytext.text = @"";
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll = %lf _mytext.contentSize.height = %lf",scrollView.contentOffset.y,_mytext.contentSize.height);
    NSLog(@"_mytext.contentSize.height - _mytext.frame.size.height = %lf",_mytext.contentSize.height - _mytext.frame.size.height);
}
@end
