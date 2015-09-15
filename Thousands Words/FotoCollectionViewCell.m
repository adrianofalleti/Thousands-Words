//
//  FotoCollectionViewCell.m
//  Thousands Words
//
//  Created by Adriano Falleti on 08/09/15.
//  Copyright (c) 2015 Adriano Falleti. All rights reserved.
//

#import "FotoCollectionViewCell.h"

@implementation FotoCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUp];
    }
    
    return self;
    
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setUp];
    }
    return  self;
    
}

-(void)setUp {
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectInset(self.bounds, BORDO, BORDO)];
    
    [self.contentView addSubview:self.imageView];
    
    
    
}







@end
