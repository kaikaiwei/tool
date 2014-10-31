//
//  DataManager.h
//  coredata
//
//  Created by Caland on 14/10/31.
//  Copyright (c) 2014年 Caland. All rights reserved.
//

/**
 *  //参照了DateSectionTitle工程，可以在Xcode中DataManager中找到
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


#define DBFileName  @"database"



@interface DataManager : NSObject

@property (nonatomic, retain) NSManagedObjectContext *objectContext;


/**
 *  @abstract 单实例模式
 *
 */
+ (DataManager *) defaultInstance;

/**
 *  @abstract 保存数据
 *
 */
- (void) saveContext;

/**
 *  @abstract 抓取数据，不应该用到的啊
 *  @entityName 数据库表名称
 *  @predicate 查询条件
 *  @limit  数据总数
 *  @offset 数据偏移量
 *  @sortDescriptors 排序描述符
 */
- (NSArray *)arrayFromCoreData:(NSString *)entityName
                     predicate:(NSPredicate *)predicate
                         limit:(NSUInteger)limit
                        offset:(NSUInteger)offset
                       orderBy:(NSArray *)sortDescriptors;


@end
