//
//  CreatoreDiContesti.m
//  Thousands Words
//
//  Created by Adriano Falleti on 08/09/15.
//  Copyright (c) 2015 Adriano Falleti. All rights reserved.
//

#import "CreatoreDiContesti.h"
#import <UIKit/UIKit.h>

@implementation CreatoreDiContesti


+(NSManagedObjectContext*)contesto {
    
    NSManagedObjectContext *contesto = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate respondsToSelector:@selector(managedObjectContext)]) {
        
        contesto = [delegate managedObjectContext];
        
    }
    
    
    return contesto;
    
    
    
    
}













@end
