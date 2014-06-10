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
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *observedScrollView;
@property (nonatomic, strong) NSMutableArray *views;

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
        
        self.views = [NSMutableArray array];
        
        self.pageControl = [[UIPageControl alloc] init];
        
        self.tintColor = [UIColor lightGrayColor];
        self.currentTintColor = [UIColor redColor];
        self.font = [UIFont systemFontOfSize:17];
        
        _isObservingScrollView = NO;
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addObjects:(NSArray *)objects {
    [self.views makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.views removeAllObjects];
    
    [objects enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        if ([object isKindOfClass:[NSString class]]) {
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = object;
            textLabel.textColor = self.currentTintColor;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = self.font;
            [self.scrollView addSubview:textLabel];
            [self.views addObject:textLabel];
            
        } else if ([object isKindOfClass:[UIImage class]]) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:object];
            imageView.contentMode = UIViewContentModeCenter;
            [self.scrollView addSubview:imageView];
            [self.views addObject:imageView];
        }
    }];
    
    self.pageControl.numberOfPages = objects.count;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    self.pageControl.frame = CGRectMake(0,
                                        self.frame.size.height - 12,
                                        self.frame.size.width,
                                        10);
    
    [self.views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view sizeToFit];
        CGSize size = view.frame.size;
        size.width = self.scrollView.frame.size.width;
        view.frame = CGRectMake(self.scrollView.frame.size.width * idx,
                                (self.scrollView.frame.size.height - size.height) / 2 - 7,
                                size.width, size.height);
    }];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.views count], self.scrollView.frame.size.height);
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
    
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    
    [self.views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        CGFloat diff = (self.scrollView.contentOffset.x - scrollViewWidth*idx) + scrollViewWidth/2;
        
        if (diff > scrollViewWidth/2) {
            diff = scrollViewWidth - diff;
        }
        
        if (diff < 0) {
            diff = 0;
        }
        
        CGFloat alpha = scrollViewWidth / 100 * diff / 100 + 0.15f;
        
        view.alpha = alpha;
    }];
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
- (void)setCurrentTintColor:(UIColor *)currentTintColor {
    _currentTintColor = currentTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentTintColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.pageControl.pageIndicatorTintColor = tintColor;
}

@end
