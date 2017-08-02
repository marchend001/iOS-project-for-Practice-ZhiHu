//
//  StoryContentViewModel.m
//  ZhiHu
//
//  Created by Marchend on 2017/7/28.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "StoryContentViewModel.h"

@implementation StoryContentViewModel

- (instancetype)init {
    
    if(self = [super init]){
        [self setupRACCommand];
    }
    return  self;
}


- (void)setupRACCommand {
    
    @weakify(self);
    _fetchStoryContentCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input){
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSLog(@"1===");
            self.url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/3/news/%@", input];
            NSLog(@"url:%@",self.url);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager GET:self.url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress){
                
            }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
                
                if(responseObject){
                    NSLog(@"2.1===上传数据");
                    [subscriber sendNext:responseObject];
                    NSLog(@"2===上传数据");
                    //[subscriber sendCompleted];
                                                            
                } else {
                    [subscriber sendCompleted];

                }
                
            }failure:^(NSURLSessionDataTask * _Nonnull task, NSError *error){
                NSLog(@"2.3===失败");
                [subscriber sendError:error];
                
            }];

            return nil;
            //NSLog(@"");
        }];
        
        return signal;
    }];
    
}

@end
