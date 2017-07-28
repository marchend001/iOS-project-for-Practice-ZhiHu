//
//  Date+Create.m
//  ZhiHu
//
//  Created by Marchend on 2017/7/25.
//  Copyright © 2017年 Marchend. All rights reserved.
//

#import "Date+Create.h"

@implementation Date (Create)

+ (Date *)dateWiteDateString:(NSString *)dateString inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Date *date = nil;
    if([dateString length]){
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Date"];
        request.predicate = [NSPredicate predicateWithFormat:@"dateString = %@",dateString];
        
        NSError *error;
        NSArray *matchArray = [context executeFetchRequest:request error:&error];
        
        if(!matchArray || error || [matchArray count] >1){
            NSLog(@"ERROR in %s",__FUNCTION__);
        }else if([matchArray count]){
            date = matchArray.firstObject;
        }else if(![matchArray count]){
            date = [NSEntityDescription insertNewObjectForEntityForName:@"Date" inManagedObjectContext:context];
            date.dateString = dateString;
        }
    }
    return  date;
}
@end
