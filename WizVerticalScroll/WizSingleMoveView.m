//
//  WizSingleMoveView.m
//  WizVerticalScroll
//
//  Created by wzz on 13-8-29.
//  Copyright (c) 2013年 wzz. All rights reserved.
//

#import "WizSingleMoveView.h"

@interface WizSingleMoveView()
@property (nonatomic, getter = getPathGradient) CGFloat gradient;   //斜率
@property (nonatomic, getter = getPathIntercede) CGFloat intercede;     //截距
@end

@implementation WizSingleMoveView
@synthesize endPoint = _endPoint;
@synthesize startPoint = _startPoint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGFloat)getPathGradient
{
    if (_endPoint.x == _startPoint.x) {
        return NSNotFound;
    }
    return (_endPoint.y - _startPoint.y) / (_endPoint.x - _startPoint.x);
}

- (CGFloat)getPathIntercede
{
    return _endPoint.y - _endPoint.x * [self getPathGradient];
}


- (CGPoint)newPositionInScrollView:(UIScrollView *)scrollView
{
    float scale = (_endPoint.y - _startPoint.y) / (scrollView.contentSize.height - CGRectGetHeight(scrollView.frame));
    float newY = scrollView.contentOffset.y * scale;
    if (self.gradient == 0) {
        float xScale = (_endPoint.x - _startPoint.x) / (scrollView.contentSize.height - CGRectGetHeight(scrollView.frame));
        return CGPointMake(scrollView.contentOffset.y * xScale, 0);
    }else if (self.gradient == NSNotFound){
        return CGPointMake(0, newY);
    }
    float newX = newY / self.gradient;
    return CGPointMake(newX, newY);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
