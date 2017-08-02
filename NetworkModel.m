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
   
    [self needDeleteStory:context];
    [self needDeleteTopStory:context];
    NSError *error = nil;
    [context save:&error];
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
                [self loadTopStoryFromArray:topstoriesArray withDateString:dateString intoManagedObjectContext:context];
                [self loadStorysFromArray:storiesArray withDateString:dateString intoManagedObjectContext:context];
                //[self loadTopStoryFromArray:topstoriesArray intoManagedObjectContext:context];
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
            
            NSLog(@"datedierci:%@",dateString);
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


#pragma mark - Fetch&Save Themes List
- (RACSignal *)fetchAndSaveThemesIntoManagedObjectContext:(NSManagedObjectContext *)context {
    return [[self fetchThemes] flattenMap:^RACStream *(NSDictionary *jsonDictionary) {
        return [self saveThemesList:jsonDictionary intoManagedObjectContext:context];
    }];
}

- (RACSignal *)saveThemesList:(NSDictionary *)themesDictionary
     intoManagedObjectContext:(NSManagedObjectContext *)context {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSArray *themeArray = themesDictionary[@"others"];
        [context performBlock:^{
            [self loadThemesWithThemesArray:themeArray intoManagedObjectContext:context];
            NSError *saveError = nil;
            [context save:&saveError];
            if (saveError) {
                [subscriber sendError:saveError];
            } else {
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (RACSignal *)fetchThemes {
    NSString *urlString = @"http://news-at.zhihu.com/api/3/themes";
    //NSURL *url = [NSURL URLWithString:urlString];
    return [self fetchJSONFromURL:urlString];
}

#pragma mark - Fetch&Save Theme Stories
- (RACSignal *)fetchAndSaveThemeStoriesWithThemeID:(NSUInteger)themeID
                           intoMangedObjectContext:(NSManagedObjectContext *)context {
    return [[self fetchStoriesOfCertainTheme:themeID] flattenMap:^RACStream *(NSDictionary *jsonDictionary) {
        return [self saveCertainThemeStories:jsonDictionary withThemeID:themeID intoManagedObjectContext:context];
    }];
}

- (RACSignal *)saveCertainThemeStories:(NSDictionary *)themeStoriesDictionary
                           withThemeID:(NSUInteger)themeID
              intoManagedObjectContext:(NSManagedObjectContext *)context {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSArray *themeStoriesArray = themeStoriesDictionary[@"stories"];
        [context performBlock:^{
            //[ThemeStory loadThemeStoriesFromArray:themeStoriesArray withThemeID:themeID intoManagedObjectContext:context];
            NSError *saveError = nil;
            [context save:&saveError];
            if (saveError) {
                [subscriber sendError:saveError];
            } else {
                [subscriber sendCompleted];
            }
            
        }];
        return nil;
    }];
}

- (RACSignal *)fetchStoriesOfCertainTheme:(NSUInteger)themeID {
    NSString *urlString = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/3/theme/%lu", themeID];
    //NSURL *url = [NSURL URLWithString:urlString];
    return [self fetchJSONFromURL:urlString];
}


- (void)needDeleteStory:(NSManagedObjectContext *)context{
    
    Boolean need = false;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Story"];
    //request.predicate = [NSPredicate predicateWithFormat:@"id = %@",storyDictionary[@"id"]];
    [request setPredicate:nil];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    if(!fetchedObjects || error){
        // NSLog(@"ERROR in %s",__FUNCTION__);
        need = false;
    }else if([fetchedObjects count]){
        //NSManagedObject* story = fetchedObjects.firstObject;
       // NSString *date = [story valueForKey:@"date"];
        NSString *date = [self dateStringOfToday];
        for(NSManagedObject *obj in fetchedObjects){
            if([[obj valueForKey:@"date"] intValue] < [date intValue]){
                [context deleteObject:obj];
            }
        }
        //[self deleteStoryBeforeCentainDate:date storyArray:fetchedObjects];
    }else if(![fetchedObjects count]){
        need = false;
    }
    
    //return  need;
}

- (void)deleteStoryBeforeCentainDate:(NSString *)date storyArray:(NSArray *)stories{
    
}


- (Boolean)needDeleteTopStory:(NSManagedObjectContext *)context{
    Boolean need = false;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TopStory"];
    //request.predicate = [NSPredicate predicateWithFormat:@"id = %@",storyDictionary[@"id"]];
    [request setPredicate:nil];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    if(!fetchedObjects || error || [fetchedObjects count] >1){
        // NSLog(@"ERROR in %s",__FUNCTION__);
        need = false;
    }else if([fetchedObjects count]){
        //NSManagedObject* top = fetchedObjects.firstObject;
        NSString *date = [self dateStringOfToday];
        for(NSManagedObject *obj in fetchedObjects){
            if(![[obj valueForKey:@"date"] isEqualToString:date]){
                [context deleteObject:obj];
            }
        }
    }else if(![fetchedObjects count]){
        need = false;
    }
    
    return  need;
    
}


- (void)deleteTopStory{
    
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
    
    [story setValue:dateString forKey:@"date"];
    NSError *saveError = nil;
    [context save:&saveError];
        
    NSLog(@"insert story sucess");
    }
}



- (void)loadTopStoryFromArray:(NSArray *)storyArray  withDateString:(NSString *)dateString intoManagedObjectContext:(NSManagedObjectContext *)context{
    
    for(NSDictionary *topstory in storyArray) {
        [self topStoryWithStoryInfo:topstory  withDateString:dateString  inManagedObjectContext:context];
    }
}





-(void)topStoryWithStoryInfo:(NSDictionary *)storyDictionary  withDateString:(NSString *)dateString inManagedObjectContext:(NSManagedObjectContext *)context {
    
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
        [story setValue:dateString forKey:@"date"];
        NSError *saveError = nil;
        [context save:&saveError];
        
        NSLog(@"insert topstory sucess");
    }
}



-(void)loadThemesWithThemesArray:(NSArray *)themeArray intoManagedObjectContext:(NSManagedObjectContext *)context{
    for(NSDictionary *theme in themeArray) {
        [self themesWithThemesInfo:theme intoManagedObjectContext:context];
    }
}



-(void)themesWithThemesInfo:(NSDictionary *)themeDictionary intoManagedObjectContext:(NSManagedObjectContext *)context{
    Theme *theme = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Theme"];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@",themeDictionary[@"id"]];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    
    if(!fetchedObjects || error || [fetchedObjects count] >1){
        NSLog(@"ERROR in %s",__FUNCTION__);
    }else if([fetchedObjects count]){
        theme = fetchedObjects.firstObject;
    }else if(![fetchedObjects count]){
        NSManagedObject *theme = [NSEntityDescription insertNewObjectForEntityForName:@"Theme" inManagedObjectContext:context];
        [theme setValue:themeDictionary[@"id"] forKey:@"id"];
        //NSLog(@"id:%@",[story valueForKey:@"id"]);
        [theme setValue:themeDictionary[@"name"] forKey:@"name"];
        [theme setValue:themeDictionary[@"description"] forKey:@"descrip"];
        [theme setValue:themeDictionary[@"image"] forKey:@"imageURL"];
        [theme setValue:themeDictionary[@"color"] forKey:@"color"];
        
        
        NSError *saveError = nil;
        [context save:&saveError];
        
        NSLog(@"insert theme sucess");
    }

}

- (RACSignal *)fetchJSONFromURL:(NSString *)url {
    //NSLog(@"Fetching: %@",url.absoluteString);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            if(responseObject){
                [subscriber sendNext:responseObject];
                
            } else {
                NSLog(@"暂无数据");
                //[subscriber sendCompleted];
            }
            
        }failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
            [subscriber sendError:error];
            [subscriber sendCompleted];
            NSLog(@"%@",error);
        }];
        

        
        return nil;

    }] doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (NSString *)dateStringOfToday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
@end
