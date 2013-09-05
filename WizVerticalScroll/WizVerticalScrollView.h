//
//  WizVerticalScrollView.h
//  WizVerticalScroll
//
//  Created by wzz on 13-8-27.
//  Copyright (c) 2013年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* const kWizParallerRect = @"kWizParallerRect";
static NSString* const kWizParallerAlpha = @"kWizParallerAlpha";
static NSString* const kWizParallerText = @"kWizParallerText";

static NSString* const kWizParallerChangedParamers = @"kWizParallerChangedParamers";

@class WizVerticalScrollView;
@protocol WizVerticalScrollViewDataSource <NSObject>
- (NSArray*) identifiesOfParallersInVerticalScrollView:(WizVerticalScrollView*)scrollView;
- (UIView*) verticalScrollView:(WizVerticalScrollView*)scrollView viewOfParallerWithIdentify:(NSString*)identify;
- (NSDictionary*) verticalScrollView:(WizVerticalScrollView*)vsView   configurationsOfParallerWithIdentify:(NSString*)identify atPageIndex:(NSInteger)index;
- (NSSet*) verticalScrollView:(WizVerticalScrollView*)vsView parallerChangedParamsWithIdentify:(NSString*)identify;
- (NSInteger) numberOfImagePageInVerticalScrollView;
- (UIImage*) VerticalScrollView:(WizVerticalScrollView*)scrollView imageAtIndex:(NSInteger)index;
@end

@protocol WizVerticalScrollViewDelegate <NSObject>

@end

@interface WizVerticalScrollView : UIScrollView
@property (nonatomic, weak) id<WizVerticalScrollViewDataSource> dataSource;
- (id) initWithDataSource:(id<WizVerticalScrollViewDataSource>)dataSource;
- (void)reloadSubviews;
- (void) reloadData;
@end
