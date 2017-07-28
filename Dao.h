//
//  Dao.h
//  ZhiHu
//
//  Created by Marchend on 2017/7/27.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dao : NSObject
@property (nonatomic, retain) NSString * gaPrefix;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * shareURL;
@property (nonatomic, retain) NSString * title;

@end
