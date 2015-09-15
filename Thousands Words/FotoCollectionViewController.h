//
//  FotoCollectionViewController.h
//  Thousands Words
//
//  Created by Adriano Falleti on 08/09/15.
//  Copyright (c) 2015 Adriano Falleti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
@interface FotoCollectionViewController : UICollectionViewController

@property (strong,nonatomic) Album *albumScelto;


- (IBAction)pickAnImage:(UIBarButtonItem *)sender;




@end
