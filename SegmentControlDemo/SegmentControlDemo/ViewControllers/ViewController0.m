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
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 30)];
    label0.text = @"这是controller0的界面";
    [self.view addSubview:label0];
    NSLog(@"viewcontroller0 :%@",self.navigationController);
    //NSLog(@"得到的：%@",[self getcurrentViewController]);
}

-(UIViewController *) getcurrentViewController{
    UIWindow *window = [[UIApplication sharedApplication] windows].lastObject;
    UIView *frontView = [window subviews][0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    }else{
        return window.rootViewController;
    }
}


-(void)pushToNextController{
    PushedViewController *push = [[PushedViewController alloc] init];
#if 0
    [self.navigationController pushViewController:push animated:YES];
#elif 0
    [self presentViewController:push animated:YES completion:nil];
#elif 1
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
