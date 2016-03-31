//
//  BaseViewController.m
//  GestureRecognizer
//
//  Created by MS on 15-7-1.
//  Copyright (c) 2015年 ZML. All rights reserved.
//

#import "BaseViewController.h"
#define NUM arc4random()%256/255.0f
@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor colorWithRed:NUM green:NUM blue:NUM alpha:1.0f];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 60)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushToNextController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)pushToNextController{
//    PushedViewController *push = [[PushedViewController alloc] init];
//#if 0
//    [self.navigationController pushViewController:push animated:YES];
//#elif 0
//    [self presentViewController:push animated:YES completion:nil];
//#elif 1
//    NSLog(@"%@",self.upController);
//    [self.upController.navigationController pushViewController:push animated:YES];
//#endif
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
