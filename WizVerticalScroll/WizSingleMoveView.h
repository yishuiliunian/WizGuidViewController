//
//  WizSingleMoveView.h
//  WizVerticalScroll
//
//  Created by wzz on 13-8-29.
//  Copyright (c) 2013年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WizSingleMoveView : UIView
@property (nonatomic, assign)CGPoint startPoint;
@property (nonatomic, assign)CGPoint endPoint;
- (CGPoint) newPositionInScrollView:(UIScrollView*)scrollView;
@end
