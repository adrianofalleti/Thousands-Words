//
//  DetailViewController.m
//  Thousands Words
//
//  Created by Adriano Falleti on 10/09/15.
//  Copyright (c) 2015 Adriano Falleti. All rights reserved.
//

#import "DetailViewController.h"
#import "FilterCollectionViewController.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     self.imageView.image = [self.foto immagine];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"filterSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[FilterCollectionViewController class]]) {
            FilterCollectionViewController *classe = segue.destinationViewController;
            
            classe.foto = self.foto;
            
            
            
            
            
        }
    }
    
    
    
    
    
    
}


- (IBAction)deleteButton:(UIButton *)sender {
    
    //la foto non la eliminiamo da dove l'abbiamo aggiunta cioè dal managed object context dell'album perchè siamo già entrati nel managed object context dell'album e ora dobbiamo eliminare solo la foto stessa.
    [[self.foto managedObjectContext] deleteObject:self.foto];
    
    NSError *errore = nil;
    
    if (![[self.foto managedObjectContext] save:&errore]) {
        NSLog(@"%@",errore);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (IBAction)addFilterButton:(UIButton *)sender {
}
@end
