//
//  AppDelegate.h
//  ZhiHu
//
//  Created by Marchend on 2017/5/3.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <CoreData/CoreData.h>
#import <SWRevealViewController/SWRevealViewController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSManagedObjectContext *context;


@end

