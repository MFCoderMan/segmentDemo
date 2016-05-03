//
//  ViewController.m
//  SegmentControlDemo
//
//  Created by ZhangYunguang on 16/1/25.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ViewController.h"
#import "ZYGSegment.h"
#import "ViewController0.h"
#import "ViewController1.h"
#import "ViewController2.h"

#define NUM arc4random()%256/255.0f

@interface ViewController ()<ZYGSegmentControlDelegate>
{
    NSMutableArray *viewArr;
    NSMutableArray *controllerArr;
    ZYGSegment *seg;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    
        /**
        * 说明：seg.segSubviews和seg.segSubControllers 可以根据需要进行设置，也可以不进行设置，
        *      当不设置时，回调方法里面就是单纯的选中了某个item（这个时候要实现代理方法），可以根据需要自行设置操作
        *      当设置seg.segSubviews后，回调方法里面就是选中的view
        *      当设置seg.segSubControllers后，回调方法里面就是选中的controller的view
        * */
    //一下五种用法选其一
    //[self simpleUse];
    //[self usage];
    //[self viewsUse];
    //[self controllersUse];
    //[self imageWithViews];
    [self imageWithController];
    
    
    
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 290, 100, 60)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:button];
}

-(void)buttonClick{
    seg.selectedIndex = 2;
}


//0、简单使用
-(void)simpleUse{
    [[ZYGSegment initSegment] addItems:@[@"标题0",@"标题1",@"标题2"] frame:CGRectMake(0, 264, self.view.frame.size.width, 34) inView:self.view];
}
//1、非定制Views和controller的使用
-(void)usage{
    seg = [ZYGSegment initSegment];
    seg.delegate = self;
    [seg addItems:@[@"标题0",@"标题1",@"标题2"] frame:CGRectMake(0, 64, self.view.frame.size.width, 34) inView:self.view];
    //自定义segment属性，（可选）
    //    [self propertySet];
}
//2、定制Views
-(void)viewsUse{
    seg = [ZYGSegment initSegment];
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
    seg.segSubviews = viewArr;
    //自定义segment属性，（可选）
    //    [self propertySet];
}
//3、定制controllers
-(void)controllersUse{
    seg = [ZYGSegment initSegment];
    seg.delegate = self;
    [seg addItems:@[@"标题0",@"标题1",@"标题2"] frame:CGRectMake(0, 64, self.view.frame.size.width, 34) inView:self.view];
    //设置各个item对应的controller
    ViewController0 *v0 = [[ViewController0 alloc] init];
    ViewController1 *v1 = [[ViewController1 alloc] init];
    ViewController2 *v2 = [[ViewController2 alloc] init];

    //设置将viewcontroller添加到的controller
    v0.upController = self;
    v1.upController = self;
    v2.upController = self;

    //为controller添加导航
    UINavigationController *nav0 = [[UINavigationController alloc] initWithRootViewController:v0];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:v1];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:v2];

//    controllerArr = [NSMutableArray arrayWithArray:@[v0,v1,v2]];
    controllerArr = [NSMutableArray arrayWithArray:@[nav0,nav1,nav2]];
    seg.segSubControllers = controllerArr;
    //自定义segment属性，（可选）
    //    [self propertySet];
}
//4、带图片的views
-(void)imageWithViews{
    seg = [ZYGSegment initSegment];
    seg.delegate = self;
    [seg addItemsWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 34) titles:@[@"1",@"2",@"3"] selectedImage:@"2YY_btn_bg" inView:self.view];
    viewArr = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor=[UIColor colorWithRed:NUM green:NUM blue:NUM alpha:1.0f];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( 30, 40, 150, 20)];
        label.text = [NSString stringWithFormat:@"这是第%d个view",i];
        [view addSubview:label];
        [viewArr addObject:view];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 100, 60)];
        [btn setTitle:@"点我" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    seg.segSubviews = viewArr;
    //设置下标的代码要放到上句添加item的后面，否则会崩溃
    seg.selectedIndex = 2;
    //自定义segment属性，（可选）
    //    [self propertySet];
}

//5、演示带图片的controller
-(void)imageWithController{
    seg = [ZYGSegment initSegment];
    seg.delegate = self;
    [seg addItemsWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 34) titles:@[@"1",@"2",@"3"] selectedImage:@"2YY_btn_bg" inView:self.view];
    //设置各个item对应的controller
    ViewController0 *v0 = [[ViewController0 alloc] init];
    ViewController1 *v1 = [[ViewController1 alloc] init];
    ViewController2 *v2 = [[ViewController2 alloc] init];
    
    //设置将viewcontroller添加到的controller
    v0.upController = self;
    v1.upController = self;
    v2.upController = self;
    
    //为controller添加导航
    UINavigationController *nav0 = [[UINavigationController alloc] initWithRootViewController:v0];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:v1];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:v2];
    
    //    controllerArr = [NSMutableArray arrayWithArray:@[v0,v1,v2]];
    controllerArr = [NSMutableArray arrayWithArray:@[nav0,nav1,nav2]];
    seg.segSubControllers = controllerArr;
    seg.selectedIndex = 2;
    //自定义segment属性，（可选）
//    [self propertySet];
}
//自定义segment属性，（可选）
-(void)propertySet{
    //对segment属性自定义，可选，不设置的话采用默认属性
    seg.segmentBackgroundColor = [UIColor whiteColor];
    seg.titleColor = [UIColor blueColor];
    seg.selectColor = [UIColor redColor];
    seg.titleFont = [UIFont fontWithName:@".Helvetica Neue Interface" size:14.0f];
    seg.lineColor = [UIColor blackColor];
    seg.duration = 0.3;
}




-(void)click{
    seg.selectedIndex = 1;
}
-(void)didSelectSegmentAtIndex:(NSInteger)selectedIndex{
    kDLOG(@"选中：%ld",selectedIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
