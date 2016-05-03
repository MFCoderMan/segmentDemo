//
//  ZYGSegmentControlDemo.m
//  SegmentControlDemo
//
//  Created by ZhangYunguang on 16/1/25.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ZYGSegment.h"
/******************************************
 *                                        *
 *        以下为默认值，可以直接在此修改       *
 *                                        *
 ******************************************
 */
//默认值：item背景色
#define kSegmentBackgroundColor    [UIColor colorWithRed:253.0f/255 green:239.0f/255 blue:230.0f/255 alpha:1.0f]
//默认值：未选中时字体的颜色
#define  kTitleColor      [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0f]
//默认值：选中时字体的颜色
#define  kSelectedColor   [UIColor colorWithRed:233.0/255 green:97.0/255 blue:31.0/255 alpha:1.0f]
//默认值：字体的大小
#define kTitleFont        [UIFont fontWithName:@".Helvetica Neue Interface" size:14.0f]
//默认值：下划线颜色
#define kDefaultLineColor   [UIColor redColor]
//默认值：初始选中的item下标
#define kDefaultIndex       0
//默认值：下划线动画的时间
#define kDefaultDuration    0.5

@interface ZYGSegment ()
{
    UIView    *backView;//segment添加到的view
    UIView    *lineView;
    CGFloat    titleWidth;
//    NSInteger  selectedIndex;
    int        itemCount;
    int        buttonTag;
    CGRect     tempFrame;//保存segment的frame
    NSString  *nomalImageName;
    NSString  *selectedImageName;
}
@end

@implementation ZYGSegment

ZYGSegment *segment;
#pragma mark - 创建segment
+(instancetype )initSegment{
    segment = [[self alloc] init];
    return segment;
}
#pragma mark - 初始化
-(instancetype )init{
    if (self = [super init]) {
        //额外的操作 ....
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.itemArray=[NSMutableArray array];
        self.selectedIndex = kDefaultIndex;
        self.titleFont = kTitleFont;
        self.segmentBackgroundColor = kSegmentBackgroundColor;
        self.titleColor = kTitleColor;
        self.selectColor = kSelectedColor;
        [self setBackgroundColor:self.segmentBackgroundColor];
        //使用kvo监测属性值变化
        [self addObserver:self forKeyPath:@"segmentBackgroundColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"backgroundColor"];
        [self addObserver:self forKeyPath:@"titleColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"titleColor"];
        [self addObserver:self forKeyPath:@"selectColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"selectColor"];
        [self addObserver:self forKeyPath:@"titleFont" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"titleFont"];
        [self addObserver:self forKeyPath:@"lineColor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"lineColor"];
        [self addObserver:self forKeyPath:@"segSubviews" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"segSubviews"];
        [self addObserver:self forKeyPath:@"segSubControllers" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"subControllers"];
        [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"selectedIndex"];
    }
    return self;
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
-(void)addItemsWithFrame:(CGRect)frame titles:(NSArray *)titles selectedImage:(NSString *)selectedImage inView:(UIView *)view{
    backView = view;
    tempFrame = frame;
    segment.frame = frame;
    [segment addItems:titles selectedImage:selectedImage];
    [view addSubview:segment];
    [self addSwipGestureIn:view];
}
#pragma mark - 添加标题
-(void)addItems:(NSArray *)items{
    itemCount = (int) items.count;
    titleWidth=(self.bounds.size.width)/itemCount;
    for (int i=0; i<items.count; i++) {
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(i*titleWidth, 0, titleWidth, self.bounds.size.height-2)];
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTag:i];
        [button addTarget:self action:@selector(changeTheSegment:) forControlEvents:UIControlEventTouchUpInside];
        if (!lineView) {
            lineView=[[UIView alloc]initWithFrame:CGRectMake((kDefaultIndex < itemCount ? kDefaultIndex: 0) * titleWidth, self.bounds.size.height-2, titleWidth, 2)];
            [lineView setBackgroundColor:kDefaultLineColor];
            [self addSubview:lineView];
        }
        [self addSubview:button];
        [self.itemArray addObject:button];
    }
    if (kDefaultIndex < itemCount) {
        [self.itemArray[kDefaultIndex] setSelected:YES];
    }else{
        [[self.itemArray firstObject] setSelected:YES];
    }
    
}
-(void)addItems:(NSArray *)items selectedImage:(NSString *)selectedImage{
    itemCount = (int) items.count;
    titleWidth=(self.bounds.size.width)/itemCount;
    selectedImageName = selectedImage;
    for (int i=0; i<items.count; i++) {
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(i * titleWidth, 0, titleWidth, self.bounds.size.height - 2)];
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button setTag:i];
        [button addTarget:self action:@selector(changeTheSegment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.itemArray addObject:button];
    }
    UIButton *nowButton = self.itemArray[kDefaultIndex];
    [nowButton setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateNormal];
    [nowButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -nowButton.titleLabel.intrinsicContentSize.width)];
    [nowButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -nowButton.currentImage.size.width, 0, 0)];
    if (kDefaultIndex < itemCount) {
        [self.itemArray[kDefaultIndex] setSelected:YES];
    }else{
        [[self.itemArray firstObject] setSelected:YES];
    }
}
-(void)changeTheSegment:(UIButton*)button
{
    [self selectIndex:button.tag];
    buttonTag = (int)button.tag;
    for (UIButton *btn in self.itemArray) {
        if (button == btn) {
            if (selectedImageName) {
                [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateNormal];
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -btn.titleLabel.intrinsicContentSize.width)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.currentImage.size.width, 0, 0)];
            }else{
                [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
                [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
            }
        }else{
            btn.selected = NO;
            if (selectedImageName) {
                [btn setImage:nil forState:UIControlStateNormal];
                [btn setImageEdgeInsets:UIEdgeInsetsZero];
                [btn setTitleEdgeInsets:UIEdgeInsetsZero];
            }else{
                [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
                [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
            }
        }
    }
}
#pragma mark - 选中某个item，调用协议方法
- (void)selectIndex:(NSInteger)index{
    if (self.selectedIndex != index) {
        [self handleSelectItemEventWith:index];
    }
}
-(void)handleSelectItemEventWith:(NSInteger )index{
    if (index > itemCount) {
        return;
    }
    [self.itemArray[self.selectedIndex] setSelected:NO];
    [self.itemArray[index] setSelected:YES];
    [UIView animateWithDuration:self.duration ? self.duration: kDefaultDuration animations:^{
        [lineView setFrame:CGRectMake(index*titleWidth,self.bounds.size.height-2, titleWidth, 2)];
    }];
    if (self.selectedIndex != index) {
        self.selectedIndex = index;
    }
    
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
        [self.delegate didSelectSegmentAtIndex:self.selectedIndex];
    }else{
        kDLOG(@"代理未实现方法");
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

#pragma mark - 利用kvo监测属性值的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *cate = (__bridge NSString *)context;
    if ([cate isEqualToString:@"backgroundColor"]) {
        [self setBackgroundColor:self.segmentBackgroundColor];
    }
    if ([cate isEqualToString:@"lineColor"]) {
        [lineView setBackgroundColor:self.lineColor];
    }
    if ([cate isEqualToString:@"segSubviews"]) {
        [self resetViews];
    }
    if ([cate isEqualToString:@"subControllers"]) {
        [self resetControllers];
    }
    if ([cate isEqualToString:@"selectedIndex"]) {
        UIButton *btn = self.itemArray[self.selectedIndex];
        [self changeTheSegment:btn];
        if (self.segSubviews.count) {
            [self resetViews];
        }else if (self.segSubControllers.count){
            [self resetControllers];
        }else{
            [self handleSelectItemEventWith:self.selectedIndex];
        }
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
//监测到属性值变化后重置界面
-(void)resetViews{
    NSInteger index = self.selectedIndex >= 0 ? self.selectedIndex: kDefaultIndex;
    UIView *selectedView = self.segSubviews[index];
    [backView addSubview:selectedView];
    if (!selectedView.frame.size.height) {
        selectedView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y + tempFrame.size.height, tempFrame.size.width, backView.frame.size.height);
    }
    [self handleSelectItemEventWith:index];
}
-(void)resetControllers{
    NSInteger index = self.selectedIndex >= 0 ? self.selectedIndex: kDefaultIndex;
    UIViewController *vController = self.segSubControllers[index];
    UIView *selectedView = vController.view;
    selectedView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y + tempFrame.size.height, tempFrame.size.width, backView.frame.size.height);
    [backView addSubview:selectedView];
    [self handleSelectItemEventWith:index];
}
#pragma mark - 移除观察者
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"segmentBackgroundColor" context:@"segmentBackgroundColor"];
    [self removeObserver:self forKeyPath:@"titleColor" context:@"titleColor"];
    [self removeObserver:self forKeyPath:@"selectColor" context:@"selectColor"];
    [self removeObserver:self forKeyPath:@"titleFont" context:@"titleFont"];
    [self removeObserver:self forKeyPath:@"segSubviews" context:@"segSubviews"];
    [self removeObserver:self forKeyPath:@"subControllers" context:@"subControllers"];
    [self removeObserver:self forKeyPath:@"selectedIndex" context:@"selectedIndex"];
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
