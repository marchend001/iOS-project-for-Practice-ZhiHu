//
//  DataModel.h
//  ZhiHu
//
//  Created by Marchend on 2017/7/25.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataModel : NSObject

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end
