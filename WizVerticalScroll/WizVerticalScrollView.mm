//
//  WizVerticalScrollView.m
//  WizVerticalScroll
//
//  Created by wzz on 13-8-27.
//  Copyright (c) 2013年 wzz. All rights reserved.
//

#import "WizVerticalScrollView.h"



class WizLine
{
private:
    CGPoint beginPoint;
    CGPoint endPoint;
public:
    WizLine(CGPoint begin, CGPoint end){
        beginPoint = begin;
        endPoint = end;
    }
    
    CGPoint pointAtPercent(float percent)
    {
        float x = beginPoint.x + (endPoint.x - beginPoint.x)*percent;
        float y = beginPoint.y + (endPoint.y - beginPoint.y) * percent;
        return CGPointMake(x, y);
    }
    
    float length()
    {
        return sqrtf(powf(beginPoint.x - endPoint.x, 2) + powf(beginPoint.y - endPoint.y, 2));
    }
};

@interface WizParallerViewInfo : NSObject

@end

@interface WizVerticalScrollView()
{
    NSInteger _numberOfPages;
    NSArray* _parallersIdentifyArray;
    CGRect _pageRect;
    NSMutableDictionary* _parallersInfos;
    NSMutableDictionary* _parallersDatas;
}

@end

@implementation WizVerticalScrollView
@synthesize dataSource = _dataSource;


- (id) initWithDataSource:(id<WizVerticalScrollViewDataSource>)dataSource
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _dataSource = dataSource;
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _parallersInfos = [NSMutableDictionary new];
        _parallersDatas = [NSMutableDictionary new];
    }
    return self;
}

- (UIView*) parallerDataWithIdentify:(NSString*)identify
{
    
}

- (void) reloadData
{
    _numberOfPages = [self.dataSource numberOfImagePageInVerticalScrollView];
    _parallersIdentifyArray = [self.dataSource identifiesOfParallersInVerticalScrollView:self];
    _pageRect = self.bounds;
    self.contentSize = CGSizeMake(CGRectGetWidth(_pageRect), CGRectGetHeight(_pageRect) * _numberOfPages);
    for (int i = 0 ; i < _numberOfPages; ++i) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectOffset(_pageRect, 0, CGRectGetHeight(_pageRect) * i)];
        [self addSubview:imageView];
        imageView.image = [self.dataSource VerticalScrollView:self imageAtIndex:i];
    }
    
    for (NSString* identify in _parallersIdentifyArray) {
        UIView* paraller = [self.dataSource verticalScrollView:self viewOfParallerWithIdentify:identify];
        NSDictionary* info = [self.dataSource verticalScrollView:self configurationsOfParallerWithIdentify:identify atPageIndex:0];
        NSSet* params = [self.dataSource verticalScrollView:self parallerChangedParamsWithIdentify:identify];
        if ([params containsObject:kWizParallerText] && [paraller isKindOfClass:[UILabel class]]) {
            [(UILabel*)paraller setText:info[kWizParallerText]];
        }
        if ([params containsObject:kWizParallerRect]) {
            CGRect rect = [info[kWizParallerRect] CGRectValue];
            paraller.frame = rect;
        }
        if ([params containsObject:kWizParallerAlpha]) {
            paraller.alpha = [info[kWizParallerAlpha] floatValue];
        }
        
        [self addSubview:paraller];
        [_parallersDatas setObject:paraller forKey:identify];
    }
}

- (void) setParallerFrame:(UIView*)paraller WithCInfo:(NSDictionary*)cInfo nInfo:(NSDictionary*)nInfo percent:(float)percent
{
    CGRect cRect = [cInfo[kWizParallerRect] CGRectValue];
    CGRect nRect = [nInfo[kWizParallerRect] CGRectValue];
    WizLine line = WizLine(cRect.origin, nRect.origin);
    CGPoint point = line.pointAtPercent(percent);
    float width = (CGRectGetWidth(nRect) - CGRectGetWidth(cRect) )*percent + CGRectGetWidth(cRect);
    float height = (CGRectGetHeight(nRect) - CGRectGetHeight(cRect))*percent + CGRectGetHeight(cRect);
    paraller.frame = CGRectMake(point.x, point.y + self.contentOffset.y, width, height);
}

- (void) setParallerAlpha:(UIView*)paraller WithCInfo:(NSDictionary*)cInfo nInfo:(NSDictionary*)nInfo percent:(float)percent
{
    float cAlpha = [cInfo[kWizParallerAlpha] floatValue];
    float nAlpha = [nInfo[kWizParallerAlpha] floatValue];
    paraller.alpha  = (nAlpha - cAlpha) * percent + cAlpha;
}


- (void) layoutSubviews
{
    NSInteger currentShowingIndex = (int)(floor(self.contentOffset.y) / CGRectGetHeight(_pageRect));
    NSInteger nextShowingIndex = (int)floor(self.contentOffset.y) % (int) floor(CGRectGetHeight(_pageRect)) < 2 && currentShowingIndex < _numberOfPages? NSNotFound : currentShowingIndex + 1;
    if (nextShowingIndex != NSNotFound) {
        for (NSString* identify in _parallersIdentifyArray) {
            //
            
            NSDictionary* cInfo = [self.dataSource verticalScrollView:self configurationsOfParallerWithIdentify:identify atPageIndex:currentShowingIndex];
            NSDictionary* nInfo = [self.dataSource verticalScrollView:self configurationsOfParallerWithIdentify:identify atPageIndex:nextShowingIndex];
            UIView* paraller = [_parallersDatas objectForKey:identify];
            float currentOffSetLength = (int)self.contentOffset.y % (int)CGRectGetHeight(_pageRect);
            float percent =currentOffSetLength/CGRectGetHeight(_pageRect);

            //
            NSSet* params = [self.dataSource verticalScrollView:self parallerChangedParamsWithIdentify:identify];
            if ([params containsObject:kWizParallerRect]) {
                [self setParallerFrame:paraller WithCInfo:cInfo nInfo:nInfo percent:percent];
            }
            if ([params containsObject:kWizParallerAlpha])
            {
                [self setParallerAlpha:paraller WithCInfo:cInfo nInfo:nInfo percent:percent];
            }
            if ([params containsObject:kWizParallerText] && [paraller isKindOfClass:[UILabel class]]) {
                UILabel* label = (UILabel*)paraller;
                if (percent < 0.5) {
                    label.text = cInfo[kWizParallerText];
                }
                else
                {
                    label.text = nInfo[kWizParallerText];
                }
            }
            //
        }
    }
    
    NSLog(@"current index %d, next index %d", currentShowingIndex, nextShowingIndex);
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
