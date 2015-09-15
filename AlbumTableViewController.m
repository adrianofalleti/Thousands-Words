//
//  AlbumTableViewController.m
//  
//
//  Created by Adriano Falleti on 08/09/15.
//
//

#import "AlbumTableViewController.h"
#import "CreatoreDiContesti.h"
#import "FotoCollectionViewController.h"

@interface AlbumTableViewController () <UIAlertViewDelegate>

@end







@implementation AlbumTableViewController
-(NSMutableArray *)albums{
    
    if (!_albums) {
        _albums = [[NSMutableArray alloc] init];
    }
    
    return _albums;
    
}



-(void)viewWillAppear:(BOOL)animated {
    
    NSFetchRequest *richiesta = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    
    
    richiesta.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"data" ascending:YES]];
    
    NSError *errore = nil;

    NSMutableArray *array = [[[CreatoreDiContesti contesto] executeFetchRequest:richiesta error:&errore] mutableCopy];
    
    self.albums = array;
    
    [self.tableView reloadData];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cella" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self.albums[indexPath.row] nome];
    NSLog(@"%@",[self.albums[indexPath.row] nome]);
    
    //ritorno cella
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark add album process


-(Album *)creoAlbumConTitolo:(NSString *)nome {
    
    //per creare un managed object model usiamo questo metodo sotto e poi gli assegnamo tutti gli attributi e poi lo salviamo nel contesto a cui appartiene,c'è da dire che se si arriva ad un entità tipo le foto da un altra entità tipo gli album,le foto dovranno essere aggiunte al managed object context dell'album.
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:[CreatoreDiContesti contesto]];
    
    album.nome = nome;
    
    album.data = [NSDate date];
    
    NSError *errore = nil;
    
    if ([[CreatoreDiContesti contesto] save:&errore]) {
        
        NSLog(@"%@",errore);
        
    }
    
    
    return album;
    
    
    
    
}










- (IBAction)addAlbumButton:(UIBarButtonItem *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add album" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [alert show];
    
    
}

#pragma  mark ui alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        //aggiungiamo un album
        NSString *testo = [[alertView textFieldAtIndex:0] text];
        
        [self.albums addObject:[self creoAlbumConTitolo:testo]];
       
      
    }
    
    
}


#pragma mark prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"foto"]) {
        if ([segue.destinationViewController isKindOfClass:[FotoCollectionViewController class]]) {
            
            FotoCollectionViewController *classe = segue.destinationViewController;
            
            NSIndexPath *index = [[self.tableView indexPathsForSelectedRows] lastObject];
            //qui sempicemente facciamo si che l'album che abbiamo scelto sia quello di cui dobbiamo far vedere le foto,quindi entriamo nel managed object context e poi dopo quando entriamo nella detail view controller entriamo nel managed object context della foto.
            
            classe.albumScelto = self.albums[index.row];
            
        }
    }
    
    
    
    
    
    
    
    
    
    
}










@end
