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
            return nil;
            //NSLog(@"");
        }];
        
        return signal;
    }];
    
}

@end
