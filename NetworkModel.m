//
//  NetworkModel.m
//  ZhiHu
//
//  Created by Marchend on 2017/7/25.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "NetworkModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation NetworkModel


#pragma mark - Fetch&Save Latest Stories

-(id)init {
    if(self = [super init]){
        //[self fetchAndProcess];
        self.downLoadCompleted = NO;
    }
    return self;
}

- (void) fetchAndSaveLatestStoriesIntoManagedObjectContext:(NSManagedObjectContext *)context{
    /*RACSignal *signal= [self fetchLatestStories];
    [signal subscribeNext:^(id value){
        NSDictionary *result = value;
        //for()
        NSString *dateString = result[@"date"];
        NSLog(@"date:%@",dateString);
    }];*/
    
    self.downLoadCompleted = NO;
    NSString *urlString = @"http://news-at.zhihu.com/api/3/news/latest";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if(responseObject){

            NSString *dateString = responseObject[@"date"];
            NSArray *storiesArray = responseObject[@"stories"];
            NSArray *topstoriesArray = responseObject[@"top_stories"];
            NSLog(@"date:%@",dateString);
            [context performBlock:^{
                NSError *saveError = nil;
                [self loadStorysFromArray:storiesArray withDateString:dateString intoManagedObjectContext:context];
                [self loadTopStoryFromArray:topstoriesArray intoManagedObjectContext:context];
                [context save:&saveError];
            }];
            self.downLoadCompleted = YES;
            
        } else {
            NSLog(@"暂无数据");
            //[subscriber sendCompleted];
        }
        
    }failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
        //[subscriber sendError:error];
        //[subscriber sendCompleted];
        NSLog(@"%@",error);
    }];

}




- (void)fetchAndSaveStoriesBeforeCertainDate:(NSString *)date intoManagedObjectContext:(NSManagedObjectContext *)context{
    
    NSString *urlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/3/news/before/%@",date];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        if(responseObject){
            
            NSString *dateString = responseObject[@"date"];
            NSArray *storiesArray = responseObject[@"stories"];
            
            NSLog(@"date:%@",dateString);
            [context performBlock:^{
                NSError *saveError = nil;
                [self loadStorysFromArray:storiesArray withDateString:dateString intoManagedObjectContext:context];
               
                [context save:&saveError];
            }];
            //self.downLoadCompleted = YES;
            
        } else {
            NSLog(@"暂无数据");
            //[subscriber sendCompleted];
        }
        
    }failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
        //[subscriber sendError:error];
        //[subscriber sendCompleted];
        NSLog(@"%@",error);
    }];
    

    
}

- (void)loadStorysFromArray:(NSArray *)storyArray withDateString:(NSString *)dateString intoManagedObjectContext:(NSManagedObjectContext *)context{
    
    for(NSDictionary *story in storyArray) {
        [self storyWithStoryInfo:story withDateString:dateString inManagedObjectContext:context];
    }
    
    
}

-(void)storyWithStoryInfo:(NSDictionary *)storyDictionary withDateString:(NSString *)dateString inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Story *story = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Story"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@",storyDictionary[@"id"]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    if(!fetchedObjects || error || [fetchedObjects count] >1){
        NSLog(@"ERROR in %s",__FUNCTION__);
    }else if([fetchedObjects count]){
        story = fetchedObjects.firstObject;
    }else if(![fetchedObjects count]){
        NSManagedObject *story = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:context];
    [story setValue:storyDictionary[@"id"] forKey:@"id"];
    //NSLog(@"id:%@",[story valueForKey:@"id"]);
    [story setValue:storyDictionary[@"title"] forKey:@"title"];
    [story setValue:storyDictionary[@"ga_prefix"] forKey:@"gaPrefix"];
    [story setValue:storyDictionary[@"images"][0] forKey:@"imageURL"];
    [story setValue:storyDictionary[@"share_url"] forKey:@"shareURL"];
    //NSManagedObject *date = [Date dateWiteDateString:dateString inManagedObjectContext:context];
    [story setValue:dateString forKey:@"date"];
    NSError *saveError = nil;
    [context save:&saveError];
        //context
    //NSLog(@"date:%@",[story valueForKey:@"date"]);
    
    //[story setValue:[Date dateWithDateString:dateString inManagedObjectContext:context ] forKey:@"date"];
    NSLog(@"insert story sucess");
    }
}



- (void)loadTopStoryFromArray:(NSArray *)storyArray  intoManagedObjectContext:(NSManagedObjectContext *)context{
    
    for(NSDictionary *topstory in storyArray) {
        [self topStoryWithStoryInfo:topstory  inManagedObjectContext:context];
    }
}


-(void)topStoryWithStoryInfo:(NSDictionary *)storyDictionary  inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Story *story = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TopStory"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@",storyDictionary[@"id"]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    if(!fetchedObjects || error || [fetchedObjects count] >1){
        NSLog(@"ERROR in %s",__FUNCTION__);
    }else if([fetchedObjects count]){
        story = fetchedObjects.firstObject;
    }else if(![fetchedObjects count]){
        NSManagedObject *story = [NSEntityDescription insertNewObjectForEntityForName:@"TopStory" inManagedObjectContext:context];
        [story setValue:storyDictionary[@"id"] forKey:@"id"];
        //NSLog(@"id:%@",[story valueForKey:@"id"]);
        [story setValue:storyDictionary[@"title"] forKey:@"title"];
        [story setValue:storyDictionary[@"ga_prefix"] forKey:@"gaPrefix"];
        [story setValue:storyDictionary[@"image"] forKey:@"imageURL"];
        [story setValue:storyDictionary[@"share_url"] forKey:@"shareURL"];
        
        NSError *saveError = nil;
        [context save:&saveError];
        //context
        //NSLog(@"date:%@",[story valueForKey:@"date"]);
        
        //[story setValue:[Date dateWithDateString:dateString inManagedObjectContext:context ] forKey:@"date"];
        NSLog(@"insert topstory sucess");
    }
}

@end
