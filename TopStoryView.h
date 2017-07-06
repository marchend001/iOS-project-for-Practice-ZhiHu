//
//  TopStoryView.h
//  ZhiHu
//
//  Created by Marchend on 2017/7/1.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import <SDWebImage/UIImageView+WebCache.h>


@protocol TopStoryViewDelegate <NSObject>

-(void)TopStoryViewDidClick:(NSInteger )imageClicked;

@end



@interface TopStoryView : UIView<UIScrollViewDelegate>
{
    int pageCount;
    int currPage;
}

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UILabel *toptitle;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,copy)NSMutableArray *topstories;
@property (nonatomic,weak)id<TopStoryViewDelegate>delegate;


-(id)initWithFrame:(CGRect)frame image:(NSMutableArray*)stories;
-(void)scrollAutomatically;
-(void)imagePressed:(UITapGestureRecognizer *)imagetap;

@end
