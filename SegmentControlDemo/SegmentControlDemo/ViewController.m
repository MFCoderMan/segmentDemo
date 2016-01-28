//
//  ViewController.m
//  SegmentControlDemo
//
//  Created by ZhangYunguang on 16/1/25.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ViewController.h"
#import "ZYGSegment.h"

#define NUM arc4random()%256/255.0f

@interface ViewController ()<ZYGSegmentControlDelegate>
{
    NSMutableArray *viewArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZYGSegment *seg = [ZYGSegment shared];
    seg.delegate = self;
    [seg addItems:@[@"标题0",@"标题1",@"标题2"] frame:CGRectMake(0, 64, self.view.frame.size.width, 34) inView:self.view];
    
    viewArr = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor=[UIColor colorWithRed:NUM green:NUM blue:NUM alpha:1.0f];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 30, 40, 150, 20)];
        label.text = [NSString stringWithFormat:@"这是第%d个view",i];
        [view addSubview:label];
        [viewArr addObject:view];
    }
    seg.viewsArr = viewArr;
    seg.segmentBackgroundColor = [UIColor whiteColor];
    seg.titleColor = [UIColor blueColor];
    seg.selectColor = [UIColor redColor];
    seg.titleFont = [UIFont fontWithName:@".Helvetica Neue Interface" size:14.0f];
    seg.lineColor = [UIColor blackColor];
    seg.duration = 0.3;
    
}

-(void)didSelectSegmentAtIndex:(NSInteger)selectedIndex{
    kDLOG(@"%ld",selectedIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
