//
//  NSManagedObject+FromWebAPI.h
//  RSSCoreData
//
//  Created by Froese, Matt on 2014-05-20.
//  Copyright (c) 2014 DSBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (CrudyWebAPI)

+ (NSString *)webApiUrl;
+ (void)fetchFromWebAPI: ( void ( ^ )( NSURLResponse *response, NSData *data, NSError *error ) )callback maxResults:(int)maxResults offset:(int)offset;
+ (void)syncWithCrudy:(NSArray *)items;

@end
