//
//  Photos.h
//  
//
//  Created by Adriano Falleti on 08/09/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photos : NSManagedObject

@property (nonatomic, retain) id immagine;
@property (nonatomic, retain) NSDate * data;
@property (nonatomic, retain) Album *albumBook;

@end
