//
//  ViewController1.m
//  SegmentControlDemo
//
//  Created by ZhangYunguang on 16/1/28.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 250, 30)];
    label1.text = @"这是controller1的界面";
    [self.view addSubview:label1];
}

-(void)pushToNextController{
    PushedViewController *push = [[PushedViewController alloc] init];
#if 1
    [self.navigationController pushViewController:push animated:YES];
#elif 0
    [self presentViewController:push animated:YES completion:nil];
#elif 0
    NSLog(@"%@",self.upController);
    [self.upController.navigationController pushViewController:push animated:YES];
#endif
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
