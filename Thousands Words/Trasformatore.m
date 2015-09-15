//
//  Trasformatore.m
//  Thousands Words
//
//  Created by Adriano Falleti on 08/09/15.
//  Copyright (c) 2015 Adriano Falleti. All rights reserved.
//

#import "Trasformatore.h"
#import <UIKit/UIKit.h>

@implementation Trasformatore

+(Class)transformedValueClass{
    
    return [NSData class];
    
    
}

+(BOOL)allowsReverseTransformation {
    return YES;
}

-(id)transformedValue:(id)value {
    
    return UIImagePNGRepresentation(value);
    
    
}

-(id)reverseTransformedValue:(id)value {
    
    
    return [UIImage imageWithData:value];
    
    
    
    
}







@end
