## BWTitlePagerView

Recreate the Twitter navigation controller pager.

![BWTitlePagerView](https://github.com/brunow/BWTitlePagerView/raw/master/shot.png)

## Using it

```objective-c
BWTitlePagerView *pagingTitleView = [[BWTitlePagerView alloc] init];
pagingTitleView.frame = CGRectMake(0, 0, 150, 40);
pagingTitleView.font = [UIFont systemFontOfSize:18];
pagingTitleView.currentTintColor = [UIColor redColor];
[pagingTitleView observeScrollView:self.scrollView];

[pagingTitleView addObjects:@[ [UIImage imageNamed:@"tux"], [UIImage imageNamed:@"tux"] ]];

Or

[pagingTitleView addObjects:@[ @"messages", @"friends" ]];
    
self.navigationItem.titleView = pagingTitleView;
```


## Contact

Bruno Wernimont

- Twitter - [@brunowernimont](http://twitter.com/brunowernimont)

