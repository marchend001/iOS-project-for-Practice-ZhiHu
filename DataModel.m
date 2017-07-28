//
//  DataModel.m
//  ZhiHu
//
//  Created by Marchend on 2017/7/25.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)init {
    if(self = [super init]){
        [self setupContext];
    }
    return self;
}


- (void)setupContext {
    NSManagedObjectContext *managedObjectContext = nil;
    NSPersistentStoreCoordinator *coordinator = [self createPersistentStoreCoordinator];
    if(coordinator != nil){
        managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    self.managedObjectContext = managedObjectContext;
}


/*- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *managedObjectContext = nil;
    
    return managedObjectContext;
}*/

- (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator {
    
    NSPersistentStoreCoordinator *persistentStoreCoordinatpr = nil;
    
    NSManagedObjectModel * model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ZhiHu.sqlite"];
    NSLog(@"%@",storeURL);
    persistentStoreCoordinatpr = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSLog(@"see me");
    
    
    NSError *error = nil;
    
    if(![persistentStoreCoordinatpr addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error ]){
     
        NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
    }
    
    return persistentStoreCoordinatpr;
    
}



- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
