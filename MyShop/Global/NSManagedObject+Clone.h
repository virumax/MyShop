//
//  NSManagedObject+Clone.h
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/6.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObject (Clone)
-(NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context withCopiedCache:(NSMutableDictionary *)alreadyCopied exludeEntities:(NSArray *)namesOfEntitiesToExclude;
-(NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context exludeEntities:(NSArray *)namesOfEntitiesToExclude;
-(NSManagedObject *) clone;
@end

NS_ASSUME_NONNULL_END
