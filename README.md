## BWTitlePagerView

Recreate the Twitter navigation controller pager.

![BWTitlePagerView](https://github.com/brunow/BWTitlePagerView/raw/master/shot.png)

## Using it

```objective-c
BWTitlePagerView *pagingTitleView = [[BWTitlePagerView alloc] init];
pagingTitleView.frame = CGRectMake(0, 0, 200, 40);
pagingTitleView.font = [UIFont systemFontOfSize:18];
pagingTitleView.textColor = [UIColor redColor];
pagingTitleView.pageIndicatorTintColor = [UIColor darkGrayColor];
pagingTitleView.currentPageIndicatorTintColor = [UIColor blackColor];
[pagingTitleView observeScrollView:self.scrollView];
[pagingTitleView addTitles:@[ @"Questions", @"Messages" ]];
    
self.navigationItem.titleView = pagingTitleView;
```


## Contact

Bruno Wernimont

- Twitter - [@brunowernimont](http://twitter.com/brunowernimont)

