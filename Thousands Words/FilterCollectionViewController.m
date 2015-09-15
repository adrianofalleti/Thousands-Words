//
//  FilterCollectionViewController.m
//  Thousands Words
//
//  Created by Adriano Falleti on 10/09/15.
//  Copyright (c) 2015 Adriano Falleti. All rights reserved.
//

#import "FilterCollectionViewController.h"
#import "FotoCollectionViewCell.h"
#import "Photos.h"
@interface FilterCollectionViewController ()

//aggiungiamo un array di filtri cosicche nel collection view data source possiamo far si che 'immagine sia ripetuta per tutti i filtri che creiamo

@property (strong,nonatomic) NSMutableArray *filtri;
//per far si che si possa applicare ad un immagine un filtro si deve usare il cifilter context.é imporantissimo

@property (strong,nonatomic) CIContext *contesto;



@end

@implementation FilterCollectionViewController

//lazy instantiation
-(NSMutableArray *)filtri {
    if (!_filtri) {
        _filtri = [[NSMutableArray alloc] init];
    }
    
    
    return _filtri;
    
    
}
-(CIContext *)contesto {
    
    if (!_contesto) _contesto = [CIContext contextWithOptions:nil];
    
    
    return _contesto;
    
    
    
}





static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[FotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    
    for (CIFilter *filtro in [[self class] creatoreDiFiltri]) {
        
        [self.filtri addObject:filtro];
        
        
    }
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.filtri count];//chiaramente ora questo ci darà zero perchè non ci sono oggetti nel mutable array,quindi per crearli creiamo un class method nell'implemetazione di questa classe che ci ritorna un array di filtri.
}

- (FotoCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  
    // Configure the cell

    cell.backgroundColor = [UIColor whiteColor];
    
    //ora qui useremo il multithreading,quindi per prima cosa creiamo un altra thread,cioè un altra corsia per il vecchietto
    

    
    
    dispatch_queue_t FilterQueue = dispatch_queue_create("filter queue",NULL);
    
    //ora facciamo spostare il vecchietto su questa queue,dicendo al computer di concentrarsi per un attimo su questa thread e assegnargli questo blocco
    //quindi succede che creando un altra thread e spostandoci in essa la nostra app eseguirà questa thread,ma nel frattempo eseguirà anche i blocchi della main thread e tra questi c'è quello che indica all'applicazione di andare nella collection view.
    
dispatch_async(FilterQueue, ^{
    
    UIImage *immagineFiltrata = [self immagineFiltrataDaImmagine:self.foto.immagine eFiltro:self.filtri[indexPath.row]];
    
    //nel blocco della nostra thread diciamo all'app che non appena otteniamo un immagine questa la deve caricare,però noi ci potremmo chiedere perchè ci spostiamo nella main thread per fare ciò?
    //Semplice,perchè i cambiamenti della UI DEVONO essere FATTI NELLA MAIN THREAD/QUEUE
    

    dispatch_async(dispatch_get_main_queue(), ^{
        
        //dobbiamo però risolvere un bug cioè quando noi selezioniamo una foto anche se non è caricata noi la possiamo selezionare quindi dobbiamo risolvere questo bug e lo risolviamo nel metodo didSelectItemAtIndexPath
        
        cell.imageView.image = immagineFiltrata;
        
    });
    
});
    
    //quindi prima noi cliccavamo il bottone add filter e quindi questo prevedeva che la collection view si dovesse aprire.L'apertura comprendeva questo metodo nel quale noi avevamo detto:
    // crea l'immagine col filtro e poi imposti la cella,e questo lo doveva fare con tutti i filtri.Quindi arrivato a questo metodo,cioè quando noi cliccavamo l'app si bloccava diciamo,perchè doveva caricare tutte le celle.
    // Faccio un esempio della thread : Clicco il bottone;la collection view chiama il metodo cell for row at indexPath;qui si blocca perchè deve caricare tutti i filtri;infine ci da la collection view
    //Mentre se utilizzassimo un altra thread succederebbe questo
    //Clicco il bottone;la collection view chiama il metodo cell for row at indexPath;qui gli diciamo di creare e spingere nell'esecuzione dell'app un altra thread;quindi eseguiamo questa e in contemporanea la main thread;la main thread prevede che entriamo nella collection view,infatti,l'app entra;e nel frattempo che entra sta succedendo qualcosa nella thread che abbiamo creato,cioè ogni qual volta che un immagine è filtrata,noi impostiamo la cella.
    
    //quindi l'esempio del vecchietto che è in autostrada e che va piano e che noi spostiamo lui su una corsia(quindi lui va nel frattempo) e il resto del traffico su un altra(anche questo va nel frattempo) è perfetto.Perche in entrambe le corsie ci si muove.
    
    
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FotoCollectionViewCell *cellaSelezionata = (FotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];//questo si chiama CAST che consiste nel dire al compilatore : "noi dal metodo [collectionView cellForItemAtIndexPath:indexPath] vogliamo assolutamente e solamentte una cella di tipo/classe FotoCollectionViewCell".Questo lo facciamo per essere sicurissimi che la cella sia una cella del tipo che vogliamo noi
    
    self.foto.immagine = cellaSelezionata.imageView.image;
    
    if (cellaSelezionata.imageView.image) {
        //quindi qua stiamo dicendo che se c'è l'immagin,allora l'utente la può salvare
    
    NSError *errore = nil;
    //qui chiaramente salviamo per registrare i nostri cambiamenti
    if (![[self.foto managedObjectContext] save:&errore]) {
        NSLog(@"%@",errore);
    }
    
    // e infine chiaramente eliminiamo la viewController
    [self.navigationController popViewControllerAnimated:YES];
    
    }
    
    
    
}







/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return YES;
    
    
    
    
    
    
    
}


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

#pragma mark CREAZIONE DI FILTRI

+(NSArray *)creatoreDiFiltri {
    //per creare i filtri si usa una classe di apple molto potente chiamata CIFilter che possiede tantissimi filtri che si creano così
    //è importantissimo scrivere il nome giusto che si possono trovare benissimo nella documentazione e anche le chiavi
    //il primo è creato!
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:nil];
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputRadiusKey,@1, nil];
    
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents",[CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9],@"inputMinComponents",[CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2],nil];
    
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil];
    
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
    
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil];
    
    CIFilter *colorControl = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey,@0.5,nil];
    
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:nil];
    
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
    
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:nil];
    
    NSArray *filtri = @[sepia,blur,colorClamp,instant,noir,vignette,colorControl,transfer,unsharpen,monochrome];
    
    return filtri;
    //ora spostiamoci nel viewDidLoad
    
}

#pragma mark CREATORE DI IMMAGINE CON FILTRO

-(UIImage *)immagineFiltrataDaImmagine:(UIImage *)immagine eFiltro:(CIFilter *)filtro {
    
    //per prima cosa convertiamo la nostra immagine in una ciimage
    
    CIImage *immagineNonFiltrata = [[CIImage alloc] initWithCGImage:immagine.CGImage];
    //ora impostiamo il nostro filtro,cioè gli diciamo che deve usare questa immagine con questa chiave
    
    [filtro setValue:immagineNonFiltrata forKey:kCIInputImageKey];
    
    //ora gli diciamo ridarci l'immagine ma questa volta la vogliamo filtrata
    
    CIImage *immagineFiltrata = [filtro outputImage];
    
    //ora dobbiamo impostare la grandezza di questa immagine
    // extent = estensione,questo è il cgrect dell'immagine filtrata
    CGRect extent = [immagineFiltrata extent];
    
    //ora creiamo un cgimageref,cioè una cgimage con quell'immagine filtrata in quel cgrect,ci si potrebbe chiedere il perchè non usiamo l'immagine immagineFiltrata.Beh usiamo una cgimage perchè vogliamo impostare anche il cgrect
    CGImageRef cgimage = [self.contesto createCGImage:immagineFiltrata fromRect:extent];
    //ora creiamo la uiimage
    
    UIImage *immagineFinale = [UIImage imageWithCGImage:cgimage];
    
    return immagineFinale;
    
    
    //ora andiamo al metodo per il riempimento della collection view e passiamo a questo metodo l'immagine della foto e il filtro per un determinato indexPath.row.Poi vogliamo che quando l'utente salva la foto noi sostituiamo la foto che avevamo con quella scelta dall'utente.Questo lo facciamo nel metodo che tiene traccia della selezione dell'utente,cioè didSelectRowAtIndexPath
    
    
    
}













@end
