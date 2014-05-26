//
//  NSManagedObject+FromWebAPI.m
//  RSSCoreData
//
//  Created by Froese, Matt on 2014-05-20.
//  Copyright (c) 2014 DSBN. All rights reserved.
//

#import <objc/message.h>
#import "Post.h"

#import "NSManagedObject+Crudy.h"
#import "NSManagedObject+CrudyWebAPI.h"

@implementation NSManagedObject (CrudyWebAPI)

+ (NSString *)webApiUrl {
    return [NSString stringWithFormat:@"http://augie.test.dsbn.org/v1/ios/%@", NSStringFromClass(self)];
}

+ (void)syncWithCrudy:(NSArray *)items {
    NSArray *allManagedObjects = [self find];
    
    // minor syncing example
    for( NSDictionary *item in items ) {
        
        // init temp object for either adding or update
        id managedObjectTemp = nil;
        
        // look for item by id
        int itemId = [[item objectForKey:@"id"] integerValue];
        BOOL update = NO;
        
        for( id managedObject in allManagedObjects ) {
            if(class_getProperty([managedObject class], [@"id" UTF8String])) {
                NSString *value = [managedObject valueForKey:[NSString stringWithUTF8String:[@"id" UTF8String]]];
                int managedObjectId = [value integerValue];
                
                if( managedObjectId == itemId ){
                    // we have a match, flag an update and assign managedObjectTemp
                    managedObjectTemp = managedObject;
                    update = YES;
                    break;
                }
            }
        }
        
        if( update == NO ) {
            // no match was found so we need to add a new one, assign empty MO to temp
            managedObjectTemp = [[self class] valueForKey:[NSString stringWithUTF8String:[@"create" UTF8String]]];
            update = YES;
            NSLog( @"Neeed to add %@", [item objectForKey:@"title"] );
        }
        
        if( update ) {
            unsigned int outCount, i;
            objc_property_t *properties = class_copyPropertyList([managedObjectTemp class], &outCount);
            
            for(i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                const char *propName = property_getName(property);
                if(propName) {
                    NSString *propertyName = [NSString stringWithCString:propName
                                                                encoding:[NSString defaultCStringEncoding]];
                    [managedObjectTemp setValue:[item objectForKey:propertyName] forKey:propertyName];
                }
            }
            free(properties);
            
            NSLog( @"Updated %@", [item objectForKey:@"title"] );
        }
    }
    
    // straight clear and add
    
    [self save];
}

+ (void)fetchFromWebAPI:( void ( ^ )( NSURLResponse *response, NSData *data, NSError *error ) )callback maxResults:(int)maxResults offset:(int)offset {
    
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *url = [NSString stringWithFormat:@"%@?maxResults=%d&offset=%d", [self webApiUrl], maxResults, offset];
    
    NSLog( @"Calling json data source: %@", url );
    
    NSMutableURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                            completionHandler:^( NSURLResponse *response, NSData *data, NSError *error ) {
                                
                                // might turf this
                                [self delete:offset limit:maxResults];
                                
                                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                NSArray *items = [json valueForKey:@"Results"];
                                
                                [self syncWithCrudy:items];
                                
                                callback( response, data, error );

                           }];
}


@end
