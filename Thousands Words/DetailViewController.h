//
//  DetailViewController.h
//  Thousands Words
//
//  Created by Adriano Falleti on 10/09/15.
//  Copyright (c) 2015 Adriano Falleti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photos.h"
@interface DetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)deleteButton:(UIButton *)sender;

- (IBAction)addFilterButton:(UIButton *)sender;

@property (strong,nonatomic) Photos *foto;



@end
