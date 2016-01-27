//
//  ViewController.m
//  SegmentControlDemo
//
//  Created by ZhangYunguang on 16/1/25.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ViewController.h"
#import "ZYGSegment.h"

@interface ViewController ()<ZYGSegmentControlDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZYGSegment *seg = [ZYGSegment shared];
    seg.delegate = self;
    [seg addItems:@[@"标题0",@"标题1",@"标题2"] frame:CGRectMake(0, 64, self.view.frame.size.width, 34) inView:self.view];
    
    
    seg.segmentBackgroundColor = [UIColor whiteColor];
    seg.titleColor = [UIColor blueColor];
    seg.selectColor = [UIColor redColor];
    seg.titleFont = [UIFont fontWithName:@".Helvetica Neue Interface" size:14.0f];
    seg.lineColor = [UIColor blackColor];
    seg.duration = 0.3;
}

-(void)didSelectSegmentAtIndex:(NSInteger)selection{
    kDLOG(@"选中%ld",selection);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
