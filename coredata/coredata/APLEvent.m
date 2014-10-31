//
//  APLEvent.m
//  coredata
//
//  Created by Caland on 14/10/31.
//  Copyright (c) 2014年 Caland. All rights reserved.
//

#import "APLEvent.h"

@interface APLEvent ()

@property (nonatomic) NSDate *primitiveTimeStamp;
@property (nonatomic) NSString *primitiveSectionIdentifier;

@end

@implementation APLEvent

@dynamic sectionIdentifier;
@dynamic timeStamp;
@dynamic title;

@dynamic primitiveSectionIdentifier;
@synthesize primitiveTimeStamp;

#pragma mark - Transient properties
- (NSString *) sectionIdentifier
{
    // Create and cache the section identifier on demand.
    // 在域中创建并缓存章节标识（section identifier）
    [self willAccessValueForKey:@"sectionIdentifier"];//将要得到某个值，发出消息
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];//已经得到某个值，发出消息
    
    if (!tmp)
    {
        /*
         Sections are organized by month and year. 
         Create the section identifier as a string representing the number (year * 1000) + month; 
         this way they will be correctly ordered chronologically regardless of the actual name of the month.
         */
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[self timeStamp]];
        tmp = [NSString stringWithFormat:@"%ld", ([components year] * 1000) + [components month]];
        [self setPrimitiveSectionIdentifier:tmp];
    }
    return tmp;
}

- (void) setTimeStamp:(NSDate *)newDate
{
    // If the time stamp changes, the section identifier become invalid.
    [self willChangeValueForKey:@"timeStamp"];//将要改变某个值，发出消息
    [self setPrimitiveTimeStamp:newDate];
    [self didChangeValueForKey:@"timeStamp"];//已经改变某个值，发出消息
    
    [self setPrimitiveSectionIdentifier:nil];
}


#pragma mark - Key path dependencies
//设置依赖关系，如果timeStamp被修改了，那么章节标识（section identifier）也将会被修改
+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of timeStamp changes, the section identifier may change as well.
    return [NSSet setWithObject:@"timeStamp"];
}

@end
