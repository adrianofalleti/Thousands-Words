//
//  AlbumTableViewController.h
//  
//
//  Created by Adriano Falleti on 08/09/15.
//
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface AlbumTableViewController : UITableViewController


@property (strong,nonatomic) NSMutableArray *albums;



- (IBAction)addAlbumButton:(UIBarButtonItem *)sender;






@end
