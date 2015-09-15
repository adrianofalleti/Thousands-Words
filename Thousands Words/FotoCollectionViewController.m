//
//  FotoCollectionViewController.m
//  Thousands Words
//
//  Created by Adriano Falleti on 08/09/15.
//  Copyright (c) 2015 Adriano Falleti. All rights reserved.
//

#import "FotoCollectionViewController.h"
#import "FotoCollectionViewCell.h"
#import "Photos.h"
#import "CreatoreDiContesti.h"
#import "DetailViewController.h"
@interface FotoCollectionViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic) NSMutableArray *foto;




@end

@implementation FotoCollectionViewController

-(NSMutableArray *)foto {
    if (!_foto) {
        _foto = [[NSMutableArray alloc] init];
    }
    
    return _foto;
    
    
    
}







static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[FotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    
    NSSet *immaginiDaAlbum = self.albumScelto.photos;
    
    NSArray *DescrittoreDiOrdinamento = @[[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:YES]];
    
    NSArray *immaginiOrdinate = [immaginiDaAlbum sortedArrayUsingDescriptors:DescrittoreDiOrdinamento];
    
    self.foto = [immaginiOrdinate mutableCopy];
    
    [self.collectionView reloadData];
    
    
    
    
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
    
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        
        if ([segue.destinationViewController isKindOfClass:[DetailViewController class]]) {
            
            DetailViewController *classe = segue.destinationViewController;
            
            NSIndexPath *index = sender;
            
            classe.foto = self.foto[index.row];
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)[self.foto count]);
    return [self.foto count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.backgroundColor = [UIColor whiteColor];
    //impostiamo l'immagine
    
    cell.imageView.image = [self.foto[indexPath.row] immagine];
    
    NSLog(@"%@",[self.foto[indexPath.row] immagine]);
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (IBAction)pickAnImage:(UIBarButtonItem *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *immagine = info[UIImagePickerControllerEditedImage];
    
    if (!immagine) {
        immagine = info[UIImagePickerControllerOriginalImage];
    }
    

    
    [self.foto addObject:[self fotoDaImmagine:immagine]];
    
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
#pragma mark CREAZIONE FOTO
-(Photos *)fotoDaImmagine:(UIImage *)immagine {
    
    Photos *foto = [NSEntityDescription insertNewObjectForEntityForName:@"Photos" inManagedObjectContext:[self.albumScelto managedObjectContext]];
    
    foto.immagine = immagine;
    
    foto.data = [NSDate date];
    
    foto.albumBook = self.albumScelto;
    
    NSError *errore = nil;
    
    if (![[self.albumScelto managedObjectContext] save:&errore]) {
        NSLog(@"%@",errore);
    }
    
    return foto;
    
    
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toFoto" sender:indexPath];
}





@end
