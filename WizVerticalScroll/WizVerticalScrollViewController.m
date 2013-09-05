//
//  WizVerticalScrollViewController.m
//  WizVerticalScroll
//
//  Created by wzz on 13-8-27.
//  Copyright (c) 2013年 wzz. All rights reserved.
//

#import "WizVerticalScrollViewController.h"
#import "WizVerticalScrollView.h"
#import "WizSingleMoveView.h"

static NSString* const kWizParallerDataFly = @"kWizParallerDataFly";
static NSString* const kWizParallerDataLabel = @"kWizParallerDataLabel";
@interface WizVerticalScrollViewController ()<UIScrollViewDelegate,WizVerticalScrollViewDataSource>
{
    NSInteger currentPage;
    NSMutableArray* singleViews;
    
    //
    NSMutableDictionary* parallersData;
}

@property (nonatomic, strong)WizSingleMoveView* smallView;
@property (nonatomic, strong)NSArray* imageNamesOfScrollView;

@end

@implementation WizVerticalScrollViewController
@synthesize vScrollView = _vScrollView;
@synthesize smallView = _smallView;
@synthesize imageNamesOfScrollView = _imageNamesOfScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithImageNames:(NSArray *)imageNames
{
    self = [super init];
    if (self) {
        _imageNamesOfScrollView = imageNames;
        currentPage = 0;
        singleViews = [NSMutableArray new];
    }
    return self;
}

- (void) loadView
{
    _vScrollView = [[WizVerticalScrollView alloc]initWithDataSource:self];
    _vScrollView.frame = [UIScreen mainScreen].bounds;
    _vScrollView.delegate = self;
    _vScrollView.dataSource = self;
    _vScrollView.pagingEnabled = YES;
    self.view = _vScrollView;
}
- (void) reloadData
{
   
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    parallersData = [NSMutableDictionary new];
    [parallersData setObject:@{kWizParallerChangedParamers:@[kWizParallerAlpha, kWizParallerRect],
                              @(0):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(180, 400, 40, 40)],
                                     kWizParallerAlpha:@(1.0)},
                              @(1):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(10, 400, 30, 30)],
                                     kWizParallerAlpha:@(0.5)},
                              @(2):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(40, 70, 40, 40)],
                                     kWizParallerAlpha:@(1.0)},
                              @(3):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(280, 360, 40, 40)],
                                     kWizParallerAlpha:@(1.0)},
                              @(4):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(280, 400, 50, 50)],
                                     kWizParallerAlpha:@(1.0)}
                               } forKey:kWizParallerDataFly];
    
    [parallersData setObject:@{kWizParallerChangedParamers:@[kWizParallerAlpha, kWizParallerRect, kWizParallerText],
                               @(0):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(20, 20, 200, 100)],
                                      kWizParallerAlpha:@(1.0),
                                      kWizParallerText:@"看有只苍蝇，好恶心"},
                               @(1):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(20, 20, 200, 100)],
                                      kWizParallerAlpha:@(0.5),
                                      kWizParallerText:@"苍蝇跑哪去了"},
                               @(2):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(20, 20, 200, 100)],
                                      kWizParallerAlpha:@(1.0),
                                      kWizParallerText:@"靠，在这！抓住他"},
                               @(3):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(20, 20, 200, 100)],
                                      kWizParallerAlpha:@(1.0),
                                      kWizParallerText:@"抓不住啊，他还挑衅。"},
                               @(4):@{kWizParallerRect:[NSValue valueWithCGRect:CGRectMake(20, 20, 200, 100)],
                                      kWizParallerAlpha:@(1.0),
                                      kWizParallerText:@"用眼神杀死你"}
                               } forKey:kWizParallerDataLabel];

    NSString* path = [[NSBundle mainBundle] pathForResource:@"WizVerticalScrollViewData" ofType:@"plist"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:path];
    for (NSDictionary* moveViewDic in [dic objectForKey:@"moveViews"]) {
        CGPoint startP = CGPointFromString([moveViewDic objectForKey:@"startPoint"]);
        CGPoint endP = CGPointFromString([moveViewDic objectForKey:@"endPoint"]);
        CGSize viewSize = CGSizeFromString([moveViewDic objectForKey:@"size"]);
        _smallView = [[WizSingleMoveView alloc]init];
        _smallView.backgroundColor = [UIColor greenColor];
        _smallView.startPoint = startP;
        _smallView.endPoint = CGPointMake(CGRectGetWidth(self.view.bounds) - endP.x - viewSize.width, CGRectGetHeight(self.view.bounds) - endP.y - viewSize.height);
        _smallView.frame = CGRectMake(startP.x, startP.y, viewSize.width, viewSize.height);
        [singleViews addObject:_smallView];
    }
    
    [_vScrollView reloadData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        for (WizSingleMoveView* each  in singleViews) {
            CGPoint newPoint = [each newPositionInScrollView:scrollView];
            [UIView animateWithDuration:1.0 animations:^{
                each.transform = CGAffineTransformMakeTranslation(newPoint.x, newPoint.y);
            }];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma VerticalScroll dataSource
- (NSInteger) numberOfImagePageInVerticalScrollView
{
    return [_imageNamesOfScrollView count];
}

- (UIImage*) VerticalScrollView:(WizVerticalScrollView *)scrollView imageAtIndex:(NSInteger)index
{
    return [UIImage imageNamed:_imageNamesOfScrollView[index]];
}

- (NSArray*) identifiesOfParallersInVerticalScrollView:(WizVerticalScrollView *)scrollView
{
    return parallersData.allKeys;
}
- (UIView*) verticalScrollView:(WizVerticalScrollView *)scrollView viewOfParallerWithIdentify:(NSString *)identify
{
    if ([identify isEqualToString:kWizParallerDataFly]) {
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"cang.jpg"];
        return imageView;
    }
    else if ([identify isEqualToString:kWizParallerDataLabel])
    {
        UILabel* label = [UILabel new];
        return label;
    }
    return nil;
}
- (NSDictionary*) verticalScrollView:(WizVerticalScrollView *)vsView configurationsOfParallerWithIdentify:(NSString *)identify atPageIndex:(NSInteger)index
{
    return parallersData[identify][@(index)];
}

- (NSSet*) verticalScrollView:(WizVerticalScrollView *)vsView parallerChangedParamsWithIdentify:(NSString *)identify
{
    return [NSSet setWithArray:parallersData[identify][kWizParallerChangedParamers]];
}

@end
