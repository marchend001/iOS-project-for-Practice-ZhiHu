//
//  StoryTableViewCell.m
//  ZhiHu
//
//  Created by Marchend on 2017/5/15.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "StoryTableViewCell.h"

@implementation StoryTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 5, 4*self.frame.size.width/5-2, self.frame.size.height-15)];
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4*self.frame.size.width/5, 5, self.frame.size.width/5, self.frame.size.height-15)];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_titleImageView];

    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    NSLog(@"wobianle");
    self.titleLabel.font=[UIFont systemFontOfSize:20];
    //self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    self.titleLabel.backgroundColor = [UIColor lightGrayColor];
    self.titleLabel.numberOfLines = 3;
    //[self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(2, 5, 4*self.frame.size.width/5-2, self.frame.size.height-10);



    self.titleImageView.frame = CGRectMake(4*self.frame.size.width/5, 5, self.frame.size.width/5, self.frame.size.height-10);

   
  
    
}

@end
