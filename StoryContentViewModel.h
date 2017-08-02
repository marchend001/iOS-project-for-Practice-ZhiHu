//
//  StoryContentViewModel.h
//  ZhiHu
//
//  Created by Marchend on 2017/7/28.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>

@interface StoryContentViewModel : NSObject

@property (nonatomic,strong)RACCommand *fetchStoryContentCommand;
@property (nonatomic,strong)NSString *url;

@end
