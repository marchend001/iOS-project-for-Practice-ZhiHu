//
//  Date+Create.h
//  ZhiHu
//
//  Created by Marchend on 2017/7/25.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "Date.h"

@interface Date (Create)
+ (Date *)dateWiteDateString:(NSString *)dateString inManagedObjectContext:(NSManagedObjectContext *)context;

@end
