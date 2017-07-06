//
//  Story.h
//  ZhiHu
//
//  Created by Marchend on 2017/5/30.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject


@property (nonatomic, retain) NSString * gaPrefix;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * shareURL;
@property (nonatomic, retain) NSString * title;
//@property (nonatomic, retain) Date *date;

-(id)initWithTitle:(NSString *)storyTitle image:(NSString *)nimageURL;

@end
