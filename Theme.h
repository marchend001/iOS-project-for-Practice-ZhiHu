//
//  Theme.h
//  ZhiHu
//
//  Created by Marchend on 2017/7/31.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Theme : NSManagedObject

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSNumber *id;
@property (nonatomic,retain) NSString *descrip;
@property (nonatomic,retain) NSString *imageURL;
@property (nonatomic,retain) NSNumber *color;

@end
