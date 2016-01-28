//
//  ViewController0.m
//  SegmentControlDemo
//
//  Created by ZhangYunguang on 16/1/28.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ViewController0.h"

@interface ViewController0 ()

@end

@implementation ViewController0

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 250, 30)];
    label0.text = @"这是controller0的界面";
    [self.view addSubview:label0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
