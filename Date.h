//
//  Date.h
//  ZhiHu
//
//  Created by Marchend on 2017/7/25.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class Story;

@interface Date : NSManagedObject

@property (nonatomic,retain) NSString *dateString;
@property (nonatomic,retain) NSSet   *stories;

@end
