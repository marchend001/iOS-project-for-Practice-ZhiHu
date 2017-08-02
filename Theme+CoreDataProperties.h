//
//  Theme+CoreDataProperties.h
//  
//
//  Created by Marchend on 2017/7/31.
//
//

#import "Theme+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Theme (CoreDataProperties)

+ (NSFetchRequest<Theme *> *)fetchRequest;

@property (nonatomic) int32_t color;
@property (nullable, nonatomic, copy) NSString *descrip;
@property (nonatomic) int32_t id;
@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) ThemeStory *stories;

@end

NS_ASSUME_NONNULL_END
