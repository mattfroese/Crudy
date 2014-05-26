//
//  NSManagedObject+Crudy.h
//  A simple class category for managing NSManagedObjects
//
//  Created by Froese, Matt on 2014-05-20.
//  Copyright (c) 2014 DSBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (Crudy)

+ (NSManagedObjectContext *) appManagedObjectContext;
+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context;

+ (NSArray *) find;
+ (NSArray *) find:(NSManagedObjectContext *)context;
+ (NSArray *) find:(int)offset limit:(int)limit;
+ (NSArray *) find:(int)offset limit:(int)limit withContext:(NSManagedObjectContext *)context;
+ (NSArray *) findWithPredicate:(NSPredicate *)predicate;
+ (NSArray *) findWithPredicate:(NSPredicate *)predicate withContext:(NSManagedObjectContext *)context;
+ (NSArray *) findWithPredicate:(NSPredicate *)predicate offset:(int)offset limit:(int)limit;
+ (NSArray *) findWithPredicate:(NSPredicate *)predicate offset:(int)offset limit:(int)limit withContext:(NSManagedObjectContext *)context;

+ (NSManagedObject*) create;
+ (NSManagedObject*) create:(NSManagedObjectContext *)context;

+ (void) save;
+ (void) save:(NSManagedObjectContext *)context;

+ (void) delete;
+ (void) delete:(NSManagedObjectContext *)context;
+ (void) delete:(int)offset limit:(int)limit;
+ (void) delete:(int)offset limit:(int)limit withContext:(NSManagedObjectContext *)context;
+ (void) deleteWithPredicate:(NSPredicate *)predicate;
+ (void) deleteWithPredicate:(NSPredicate *)predicate withContext:(NSManagedObjectContext *)context;
+ (void) deleteWithPredicate:(NSPredicate *)predicate offset:(int)offset limit:(int)limit;
+ (void) deleteWithPredicate:(NSPredicate *)predicate offset:(int)offset limit:(int)limit withContext:(NSManagedObjectContext *)context;
+ (void) deleteItems:(NSArray *)items;
+ (void) deleteItems:(NSArray *)items withContext:(NSManagedObjectContext *)context;

@end
