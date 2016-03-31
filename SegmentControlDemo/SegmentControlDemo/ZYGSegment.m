//
//  ZYGSegmentControlDemo.m
//  SegmentControlDemo
//
//  Created by ZhangYunguang on 16/1/25.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ZYGSegment.h"

@interface ZYGSegment ()
{
    UIView *backView;//segment添加到的view
    CGFloat titleWidth;
    UIView* lineView;
    NSInteger selectedIndex;
    int itemCount;
    int buttonTag;
    CGRect tempFrame;//保存segment的frame
}
@end

@implementation ZYGSegment

ZYGSegment *segment;
#pragma mark - 初始化
-(instancetype )init{
    if (self = [super init]) {
        //额外的操作
        
    }
    return self;
}

+(instancetype )initSegment{
    segment = [[self alloc] init];
    return segment;
}
#pragma mark - 供外部调用的方法
-(void)addItems:(NSArray *)items frame:(CGRect)frame inView:(UIView *)view{
    backView = view;
    tempFrame = frame;
    segment.frame = frame;
    [segment addItems:items];
    [view addSubview:segment];
    [self addSwipGestureIn:view];
}
#pragma mark - 添加标题
-(void)addItems:(NSArray *)items
{
    NSInteger seugemtNumber=items.count;
    itemCount = (int) seugemtNumber;
    titleWidth=(self.bounds.size.width)/seugemtNumber;
    for (int i=0; i<items.count; i++) {
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(i*titleWidth, 0, titleWidth, self.bounds.size.height-2)];
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTag:i];
        [button addTarget:self action:@selector(changeTheSegment:) forControlEvents:UIControlEventTouchUpInside];
        if (!lineView) {
            lineView=[[UIView alloc]initWithFrame:CGRectMake(i*titleWidth, self.bounds.size.height-2, titleWidth, 2)];
            [lineView setBackgroundColor:[UIColor redColor]];
            [self addSubview:lineView];
        }
        [self addSubview:button];
        [self.itemArray addObject:button];
    }
    [[self.itemArray firstObject] setSelected:YES];
}
-(void)changeTheSegment:(UIButton*)button
{
    [self selectIndex:button.tag];
    buttonTag = (int)button.tag;
}
#pragma mark - 选中下标，供外部调用
- (void)selectIndex:(NSInteger)index{
    if (selectedIndex!=index) {
        [self.itemArray[selectedIndex] setSelected:NO];
        [self.itemArray[index] setSelected:YES];
        [UIView animateWithDuration:self.duration ? self.duration: 0.5 animations:^{
            [lineView setFrame:CGRectMake(index*titleWidth,self.bounds.size.height-2, titleWidth, 2)];
        }];
        selectedIndex=index;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSegmentAtIndex:)]) {
            if (self.segSubviews && self.segSubviews.count) {
                for (int i=0; i<=index; i++) {
                    UIView *view = self.segSubviews[i];
                    if (i != index) {
                        [view removeFromSuperview];
                    }else{
                        if (!view.frame.size.height){
                            view.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y + tempFrame.size.height, tempFrame.size.width, backView.frame.size.height);
                        }
                        
                        [backView addSubview:view];
                    }
                }
            }else if (self.segSubControllers && self.segSubControllers.count){
                for (int i=0; i<self.segSubControllers.count; i++) {
                    UIViewController *vController = self.segSubControllers[i];
                    if (i != index) {
                        [vController.view removeFromSuperview];
                    }else{
                        vController.view.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y + tempFrame.size.height, tempFrame.size.width, backView.frame.size.height);
                        UIViewController *addedController = [self getController];
                        [addedController addChildViewController:vController];
                        [vController didMoveToParentViewController:addedController];
                        [backView addSubview:vController.view];
                        
                    }
                }
            }
            [self.delegate didSelectSegmentAtIndex:selectedIndex];
        }else{
            kDLOG(@"代理未实现方法");
        }
    }
}
#pragma mark - 获得把segment添加到界面的controller
-(UIViewController *)getController{
    UIResponder *responder = backView.nextResponder;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}
#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.itemArray=[NSMutableArray array];
        selectedIndex=0;
        self.titleFont=[UIFont fontWithName:@".Helvetica Neue Interface" size:14.0f];
        self.segmentBackgroundColor=[UIColor colorWithRed:253.0f/255 green:239.0f/255 blue:230.0f/255 alpha:1.0f];
        self.titleColor=[UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0f];
        self.selectColor=[UIColor colorWithRed:233.0/255 green:97.0/255 blue:31.0/255 alpha:1.0f];
        [self setBackgroundColor:self.segmentBackgroundColor];
        [self addObserver:self forKeyPath:@"segmentBackgroundColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"backgroundColor"];
        [self addObserver:self forKeyPath:@"titleColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"titleColor"];
        [self addObserver:self forKeyPath:@"selectColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"selectColor"];
        [self addObserver:self forKeyPath:@"titleFont" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"titleFont"];
        [self addObserver:self forKeyPath:@"lineColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"lineColor"];
        [self addObserver:self forKeyPath:@"segSubviews" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"viewsArr"];
        [self addObserver:self forKeyPath:@"segSubControllers" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"subControllers"];
    }
    return self;
}

#pragma mark - 利用kvo监测属性值的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *cate = (__bridge NSString *)context;
    if ([cate isEqualToString:@"backgroundColor"]) {
        [self setBackgroundColor:self.segmentBackgroundColor];
    }
    if ([cate isEqualToString:@"lineColor"]) {
        [lineView setBackgroundColor:self.lineColor];
    }
    if ([cate isEqualToString:@"viewsArr"]) {
        UIView *selectedView = self.segSubviews[0];
        [backView addSubview:selectedView];
        if (!selectedView.frame.size.height) {
            selectedView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y + tempFrame.size.height, tempFrame.size.width, backView.frame.size.height);
        }
        
    }
    if ([cate isEqualToString:@"subControllers"]) {
        UIViewController *vController = self.segSubControllers[0];
        UIView *selectedView = vController.view;
        selectedView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y + tempFrame.size.height, tempFrame.size.width, backView.frame.size.height);
        [backView addSubview:selectedView];
    }
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if ([cate isEqualToString:@"titleColor"]){
                [button setTitleColor:self.titleColor forState:UIControlStateNormal];
            }else if ([cate isEqualToString:@"selectColor"]){
                [button setTitleColor:self.selectColor forState:UIControlStateSelected];
            }else if ([cate isEqualToString:@"titleFont"]){
                [button.titleLabel setFont:self.titleFont];
            }
        }
        
    }
    
}
#pragma mark - 移除观察者
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentBackgroundColor" context:@"segmentBackgroundColor"];
    [self removeObserver:self forKeyPath:@"titleColor" context:@"titleColor"];
    [self removeObserver:self forKeyPath:@"selectColor" context:@"selectColor"];
    [self removeObserver:self forKeyPath:@"titleFont" context:@"titleFont"];
    [self removeObserver:self forKeyPath:@"viewsArr" context:@"viewsArr"];
    [self removeObserver:self forKeyPath:@"subControllers" context:@"subControllers"];
}

#pragma mark - 添加手势
-(void)addSwipGestureIn:(UIView *)view{
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipTheScreen:)];
    leftSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:leftSwip];
    
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipTheScreen:)];
    rightSwip.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:rightSwip];
}
-(void)swipTheScreen:(UISwipeGestureRecognizer *)swip{
    if (swip.direction & UISwipeGestureRecognizerDirectionRight){
        if (buttonTag > 0) {
            buttonTag --;
            [self selectIndex:buttonTag];
        }
    }else if (swip.direction & UISwipeGestureRecognizerDirectionLeft){
        if (buttonTag < itemCount-1) {
            buttonTag ++;
            [self selectIndex:buttonTag];
        }
    }

}

@end
