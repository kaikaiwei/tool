//
//  APLEvent.h
//  coredata
//
//  Created by Caland on 14/10/31.
//  Copyright (c) 2014年 Caland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface APLEvent : NSManagedObject

@property (nonatomic, retain) NSString * sectionIdentifier;//注意，这个属性的Property为Transient,Optional
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * title;

@end
