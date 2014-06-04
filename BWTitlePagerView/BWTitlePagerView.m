//
// Created by Bruno Wernimont on 2014
// Copyright 2014 BWTitlePagerView
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "BWTitlePagerView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWTitlePagerView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *textLabels;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *observedScrollView;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWTitlePagerView

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.scrollEnabled = NO;
        
        self.pageControl = [[UIPageControl alloc] init];
        
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:17];
        
        _isObservingScrollView = NO;
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addTitles:(NSArray *)titles {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = title;
        textLabel.textColor = self.textColor;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = self.font;
        [self.scrollView addSubview:textLabel];
    }];
    
    self.pageControl.numberOfPages = titles.count;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UILabel *view, NSUInteger idx, BOOL *stop) {
        [view sizeToFit];
        CGSize size = view.frame.size;
        size.width = self.scrollView.frame.size.width;
        view.frame = CGRectMake(self.scrollView.frame.size.width * idx,
                                (self.scrollView.frame.size.height - size.height) / 2 - 7,
                                size.width, size.height);
    }];
    
    self.pageControl.frame = CGRectMake(0,
                                        self.frame.size.height - 12,
                                        self.frame.size.width,
                                        10);

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.scrollView.subviews count], self.scrollView.frame.size.height);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)observeScrollView:(UIScrollView *)scrollView; {
    self.observedScrollView = scrollView;
    
    if (_isObservingScrollView) {
        [self.observedScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    
    _isObservingScrollView = YES;
    
    [self.observedScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    CGFloat coef = self.observedScrollView.frame.size.width / self.scrollView.frame.size.width;
    
    if (coef > 0) {
        self.scrollView.contentOffset = CGPointMake(self.observedScrollView.contentOffset.x / coef, 0);
    }
    
    CGFloat pageWidth = self.observedScrollView.frame.size.width;
	NSUInteger page = floor((self.observedScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    if (_isObservingScrollView) {
        [self.observedScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Getters and setters

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor *)pageIndicatorTintColor {
    return self.pageControl.pageIndicatorTintColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor *)currentPageIndicatorTintColor {
    return self.pageControl.currentPageIndicatorTintColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

@end
