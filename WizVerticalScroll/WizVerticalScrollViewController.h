//
//  WizVerticalScrollViewController.h
//  WizVerticalScroll
//
//  Created by wzz on 13-8-27.
//  Copyright (c) 2013年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizVerticalScrollView.h"
@interface WizVerticalScrollViewController : UIViewController
@property (nonatomic, strong) WizVerticalScrollView* vScrollView;
- (id)initWithImageNames:(NSArray*)imageNames;
@end
