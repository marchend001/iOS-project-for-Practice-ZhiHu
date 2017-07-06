//
//  ContentHeaderView.m
//  ZhiHu
//
//  Created by Marchend on 2017/6/30.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "ContentHeaderView.h"

@implementation ContentHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        self.imageView = [[UIImageView alloc]init];
        //self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.title = [[UILabel alloc]init];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font=[UIFont systemFontOfSize:20];

        [self.title setLineBreakMode:NSLineBreakByCharWrapping];
        self.title.numberOfLines = 2;
        self.title.textColor = [UIColor whiteColor];
        [self addSubview:self.title];
        
        self.imageSource = [[UILabel alloc]init];
        self.imageSource.textAlignment = NSTextAlignmentCenter;
        self.imageSource.font=[UIFont systemFontOfSize:13];
        self.imageSource.textAlignment = NSTextAlignmentRight;
        self.imageSource.textColor = [UIColor whiteColor];
        [self addSubview:self.imageSource];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.imageView.frame = CGRectMake(0, 0, width, height);
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.title.frame = CGRectMake(10, 130, width-20, 100);
    self.imageSource.frame = CGRectMake(5, 200, width-10, 10);

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
