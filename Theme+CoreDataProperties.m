//
//  Theme+CoreDataProperties.m
//  
//
//  Created by Marchend on 2017/7/31.
//
//

#import "Theme+CoreDataProperties.h"

@implementation Theme (CoreDataProperties)

+ (NSFetchRequest<Theme *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Theme"];
}

@dynamic color;
@dynamic descrip;
@dynamic id;
@dynamic imageURL;
@dynamic name;
@dynamic stories;

@end
