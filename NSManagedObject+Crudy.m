//
//  NSManagedObject+EasyFetching.m
//  RSSCoreData
//
//  Created by Froese, Matt on 2014-05-20.
//  Copyright (c) 2014 DSBN. All rights reserved.
//

#import "DSBNAppDelegate.h"
#import "NSManagedObject+Crudy.h"

@implementation NSManagedObject (Crudy)

+ (NSManagedObjectContext *) appManagedObjectContext {
    return ((DSBNAppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
}

#pragma mark Save
+(void) save {
    [self save:[self appManagedObjectContext]];
}

+(void) save:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

#pragma mark Creating empty
+ (NSManagedObject*) create {
    return [self create:[self appManagedObjectContext]];
}

+ (NSManagedObject*) create:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    return (NSManagedObject*)[NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:context];
}


#pragma mark Find Methods

+ (NSArray *) find {
    return [self findWithPredicate:nil offset:0 limit:0 withContext:[self appManagedObjectContext]];
}
+ (NSArray *) find:(NSManagedObjectContext *)context{
    return [self findWithPredicate:nil offset:0 limit:0 withContext:context];
    
}
+ (NSArray *) find:(int)offset limit:(int)limit{
    return [self findWithPredicate:nil offset:offset limit:limit];
    
}
+ (NSArray *) find:(int)offset limit:(int)limit withContext:(NSManagedObjectContext *)context {
    return [self findWithPredicate:nil offset:offset limit:limit withContext:context];
    
}
+ (NSArray *) findWithPredicate:(NSPredicate *)predicate{
    return [self findWithPredicate:predicate offset:0 limit:0 withContext:[self appManagedObjectContext]];
}
+ (NSArray *) findWithPredicate:(NSPredicate *)predicate withContext:(NSManagedObjectContext *)context{
    return [self findWithPredicate:predicate offset:0 limit:0 withContext:context];
}
+ (NSArray *) findWithPredicate:(NSPredicate *)predicate offset:(int)offset limit:(int)limit {
    return [self findWithPredicate:predicate offset:offset limit:limit withContext:[self appManagedObjectContext]];
}
+ (NSArray *) findWithPredicate:(NSPredicate *)predicate offset:(int)offset limit:(int)limit withContext:(NSManagedObjectContext *)context{
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity: entity];
    
    if( predicate != nil ) {
        [fetchRequest setPredicate: predicate];
    }
    
    NSSortDescriptor *sortById = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortById]];
    
    if( limit > 0 )
        [fetchRequest setFetchLimit:limit];
    
    if( offset > 0 )
        [fetchRequest setFetchOffset:offset];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if (error != nil)
    {
        //handle errors
    }
    return results;
}

#pragma mark Delete Methods

+ (void) delete {
    [self deleteItems: [self find]];
}
+ (void) delete:(NSManagedObjectContext *)context {
    [self deleteItems: [self find] withContext:context];
    
}
+ (void) delete:(int)offset limit:(int)limit {
    [self deleteItems: [self find:offset limit:limit]];
    
}
+ (void) delete:(int)offset limit:(int)limit withContext:(NSManagedObjectContext *)context {
    [self deleteItems: [self find:offset limit:limit withContext:context] withContext:context];
    
}
+ (void) deleteWithPredicate:(NSPredicate *)predicate {
    [self deleteItems: [self findWithPredicate:predicate]];
    
}
+ (void) deleteWithPredicate:(NSPredicate *)predicate withContext:(NSManagedObjectContext *)context {
    [self deleteItems: [self findWithPredicate:predicate withContext:context] withContext:context  ];
    
}
+ (void) deleteWithPredicate:(NSPredicate *)predicate offset:(int)offset limit:(int)limit {
    [self deleteItems: [self findWithPredicate:predicate offset:offset limit:limit]];
}
+ (void) deleteWithPredicate:(NSPredicate *)predicate offset:(int)offset limit:(int)limit withContext:(NSManagedObjectContext *)context {
    [self deleteItems: [self findWithPredicate:predicate offset:offset limit:limit withContext:context] withContext:context];
    
}
+ (void) deleteItems:(NSArray *)items {
    NSManagedObjectContext *context = [self appManagedObjectContext];
    [self deleteItems:items withContext:context];
}
+ (void) deleteItems:(NSArray *)items withContext:(NSManagedObjectContext *)context {
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        NSLog(@" object deleted");
    }
    NSError *error = nil;
    
    if (![context save:&error]) {
    	NSLog(@"Error deleting - error:%@",error);
    }
}

@end