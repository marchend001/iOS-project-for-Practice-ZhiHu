//
//  NetworkModel.h
//  ZhiHu
//
//  Created by Marchend on 2017/7/25.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <CoreData/CoreData.h>
#import "Date+Create.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkModel : NSObject

@property (nonatomic,assign) BOOL downLoadCompleted;

- (void)fetchAndSaveLatestStoriesIntoManagedObjectContext:(NSManagedObjectContext *)context;
//- (RACSignal *)fetchLatestStories ;
//- (void) fetchAndProcess:(NSManagedObjectContext *)context;
- (void)fetchAndSaveStoriesBeforeCertainDate:(NSString *)date intoManagedObjectContext:(NSManagedObjectContext *)context;
@end
