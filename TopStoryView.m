//
//  TopStoryView.m
//  ZhiHu
//
//  Created by Marchend on 2017/7/1.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "TopStoryView.h"



@implementation TopStoryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame image:(NSMutableArray*)stories{
    if(self = [super initWithFrame:frame]){
        
        self.topstories = stories;
        pageCount = stories.count;
        currPage = 0;
        CGRect viewSize = frame;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:frame];
        self.scrollView.contentSize = CGSizeMake(viewSize.size.width*pageCount, viewSize.size.height);
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.pagingEnabled = true;
        //var contentWidth = 320*pageCount
        self.scrollView.showsHorizontalScrollIndicator = false;
        self.scrollView.showsVerticalScrollIndicator = false;
        self.scrollView.scrollEnabled = true;
        self.scrollView.scrollsToTop = false;
        self.scrollView.delegate = self;
        
        
        int i=0;
        for(Story *s in self.topstories){
            
            //Story *s = [self.topstories objectAtIndex:i];
            NSString *titleString = s.title;
            NSURL *imageURLString = [NSURL URLWithString:s.imageURL];
            
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.frame = CGRectMake(width*i, 0,width, height);
            imageview.contentMode = UIViewContentModeScaleAspectFill;
            imageview.clipsToBounds = YES;
            imageview.userInteractionEnabled = YES;
            imageview.tag = i;
            
            [imageview sd_setImageWithURL:imageURLString placeholderImage:[UIImage imageNamed:@"topimage"]];
            UITapGestureRecognizer *imagetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagePressed:)];
            [imagetap setNumberOfTapsRequired:1];
            [imagetap setNumberOfTouchesRequired:1];
            [imageview addGestureRecognizer:imagetap];
            
            [self.scrollView addSubview:imageview];
            
            self.toptitle = [[UILabel alloc]init];
            self.toptitle.frame = CGRectMake(10+width*i, 130, width-20, 100);
            self.toptitle.textAlignment = NSTextAlignmentLeft;
            self.toptitle.font=[UIFont systemFontOfSize:20];
            
            [self.toptitle setLineBreakMode:NSLineBreakByCharWrapping];
            self.toptitle.numberOfLines = 2;
            self.toptitle.textColor = [UIColor whiteColor];
            self.toptitle.text = s.title;
            [self.scrollView addSubview:self.toptitle];
           
            i++;
        }
        
        self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
        
        [self addSubview:self.scrollView];
        
        //标题不随图片滚动，在scrollview的外部，和scrollview同一层级
        CGFloat pageControlWidth = (pageCount-2)*10.0+40;
        CGFloat pageControlHeight = 24;
        
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((viewSize.size.width)/2-pageControlWidth/2, 100, pageControlWidth, pageControlHeight)];
            //initWithframe:CGRectMake((viewSize.size.width)/2-pageControlWidth/2, 0, pageControlWidth, pagecontrolHeight)];
        //CGSize size = [self.pageControl sizeForNumberOfPages:self.pageCount]; //根据页数返回 UIPageControl 合适的大小
      //  self.pageControl.bounds = CGRectMake(0.0, 0.0, size.width, size.height);
        self.pageControl.center = CGPointMake(viewSize.size.width / 2.0, viewSize.size.height - 80.0);
        //_pageC.numberOfPages = _imageCount;
        self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor brownColor];
        self.pageControl.userInteractionEnabled = NO;
        self.pageControl.currentPage=0;
        self.pageControl.numberOfPages=pageCount;
        //noteView.addSubview(self.pageControl);
        [self addSubview:self.pageControl];
        
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollAutomatically) userInfo:nil repeats:YES];
        
    }
    return self;
}





-(void)scrollAutomatically{
    if (self.pageControl.currentPage + 1 < self.topstories.count) {
        currPage = self.pageControl.currentPage + 1;
        //self.changeCurrentPage()
        CGFloat offX = self.scrollView.frame.size.width * (currPage);
        [self.scrollView setContentOffset:CGPointMake(offX, 0) animated:true];
        self.pageControl.currentPage = currPage;
        //[self scrollViewDidEndDecelerating:self.scrollView];
    }else{
        currPage = 0;
        CGFloat offX = self.scrollView.frame.size.width * (currPage);
        [self.scrollView setContentOffset:CGPointMake(offX, 0) animated:true];
        //[self scrollViewDidEndDecelerating:self.scrollView];
        self.pageControl.currentPage = currPage;
    }

        
    
}


-(void)imagePressed:(UITapGestureRecognizer *)imagetap{
    [self.delegate TopStoryViewDidClick:imagetap.view.tag];
}


#pragma mark - ScrollView Delegate
                          
                          
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint contentOffset = [scrollView contentOffset];
    if (contentOffset.x > self.frame.size.width) { //向左滑动
        currPage = (currPage + 1) % pageCount;
    } else if (contentOffset.x < self.frame.size.width) { //向右滑动
        currPage = (currPage - 1 + pageCount) % pageCount;
    }
    self.pageControl.currentPage = currPage;
    
                              
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffset = [scrollView contentOffset];
    if (contentOffset.x > self.frame.size.width) { //向左滑动
        currPage = (currPage + 1) % pageCount;
    } else if (contentOffset.x < self.frame.size.width) { //向右滑动
        currPage = (currPage - 1 + pageCount) % pageCount;
    }
    //[self changeTitle:currPage];
}

@end
