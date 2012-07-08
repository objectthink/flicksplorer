//
//  MainViewController.m
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "utilityAppDelegate.h"

#import "SVWebViewController.h"
#import "MBProgressHUD.h"

#define BIG 3010349
#define INFO_HEIGHT 118

#pragma mark - InfoViewEx
@implementation InfoViewEx
@synthesize dateTaken;
@synthesize tags;

#pragma mark - 
-(void)updateWithPhoto:(Photo*)p;
{
   //NSLog(@"%s", __PRETTY_FUNCTION__); 
   
   if(p == nil) return;
   
   self.dateTaken.text = p.dateTaken;
   self.tags.text = p.tags;
}
@end

#pragma mark - InfoView
@implementation InfoView
@synthesize owner;
@synthesize title;
@synthesize description;
@synthesize descriptionView;
@synthesize locationAvailable;
@synthesize photo;
@synthesize popover;
@synthesize mapover;
@synthesize thumb;
@synthesize buddy;
@synthesize owners = _owners;

#pragma mark - popover delegate
-(void)popoverControllerDidDismissPopover:(WEPopoverController *)popoverController
{
}

-(BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)popoverController
{
   return YES;
}

-(IBAction)reticleClicked:(id)sender
{   
   //NSLog(@"%s", __PRETTY_FUNCTION__);  
   
   //SNE CHECK
   //add map view
   /////////////////
//   if(!mapover)
//   {
//      UIViewController *c = [[[UIViewController alloc] init] autorelease];
//      
//      MKMapView* mapView 
//      = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 290, 220)] autorelease];
//      
//      [mapView addAnnotation:photo.mapPoint];
//      [mapView setCenterCoordinate:photo.mapPoint.coordinate];
//      
//      if([[NSUserDefaults standardUserDefaults] boolForKey:SETTING_MAP_TYPE])
//      {
//         mapView.mapType = MKMapTypeSatellite;
//      }
//      
//      MKCoordinateRegion region = 
//      MKCoordinateRegionMakeWithDistance([photo.mapPoint coordinate], 2500, 2500);
//      
//      [mapView setRegion:region animated:YES];
//
//      c.view = mapView;
//      
//      c.contentSizeForViewInPopover = 
//      CGRectMake(0, 0,290,220).size;
//      
//      mapover = [[WEPopoverController alloc] initWithContentViewController:c];
//      
//      [mapover setDelegate:self];
//   } 
   
   WEPopoverController* mTemp;
   
   UIViewController *c = [[[UIViewController alloc] init] autorelease];
   
   MKMapView* mapView 
   = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 290, 220)] autorelease];
   
   [mapView addAnnotation:photo.mapPoint];
   [mapView setCenterCoordinate:photo.mapPoint.coordinate];
   
   if([[NSUserDefaults standardUserDefaults] boolForKey:SETTING_MAP_TYPE])
   {
      mapView.mapType = MKMapTypeSatellite;
   }
   
   MKCoordinateRegion region = 
   MKCoordinateRegionMakeWithDistance([photo.mapPoint coordinate], 2500, 2500);
   
   [mapView setRegion:region animated:YES];
   
   c.view = mapView;
   
   c.contentSizeForViewInPopover = 
   CGRectMake(0, 0,290,220).size;
   
   mTemp = [[WEPopoverController alloc] initWithContentViewController:c];
   
   [mTemp setDelegate:self];

   if([mapover isPopoverVisible]) 
   {
      [mapover dismissPopoverAnimated:YES];
      [mapover setDelegate:nil];
      [mapover autorelease];
      
      //mapover = nil;
      mapover = mTemp;
   } 
   else 
   {
      utilityAppDelegate* app =
      (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
      
      mapover = mTemp;
      
      [mapover 
       presentPopoverFromRect:CGRectMake(15, 340, 75, 75)
       inView:app.mainViewController.view
       permittedArrowDirections:UIPopoverArrowDirectionDown
       animated:YES];
   }

}

-(void)downloadImage
{
   NSData  *imageData = [NSData dataWithContentsOfURL:self.photo.photoURL];
   UIImage *image = [UIImage imageWithData:imageData];
   
   photo.image = image;   
}

-(void)processPopover
{
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   /////////////////
//   if(!popover)
//   {
//      UIViewController *c = [[[UIViewController alloc] init] autorelease];
//      
//      c.view = [[[UIImageView alloc] initWithImage:photo.image] autorelease];
//      
//      c.contentSizeForViewInPopover = 
//      CGRectMake(0, 0,photo.image.size.width,photo.image.size.height).size;
//      
//      popover = [[WEPopoverController alloc] initWithContentViewController:c];
//      
//      [popover setDelegate:self];
//   } 
   
   WEPopoverController* pTemp;
   
   UIViewController *c = [[[UIViewController alloc] init] autorelease];
   
   c.view = [[[UIImageView alloc] initWithImage:photo.image] autorelease];
   
   c.contentSizeForViewInPopover = 
   CGRectMake(0, 0,photo.image.size.width,photo.image.size.height).size;
   
   pTemp = [[WEPopoverController alloc] initWithContentViewController:c];
   
   [pTemp setDelegate:self];

   if([popover isPopoverVisible]) 
   {
      [popover dismissPopoverAnimated:YES];
      [popover setDelegate:nil];
      [popover autorelease];
      
      popover = nil;
      //popover = pTemp;
   } 
   else 
   {
      popover = pTemp;
      
      [popover 
       presentPopoverFromRect:CGRectMake(15, 340, 75, 75)
       inView:app.mainViewController.view
       permittedArrowDirections:UIPopoverArrowDirectionDown
       animated:YES];
   }
}

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   //NSLog(@"%s", __PRETTY_FUNCTION__);  

   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   MainViewController* mainViewController = (MainViewController*)app.mainViewController;

   __block BOOL process = false;
   __block BOOL processOwner = false;
   [touches enumerateObjectsUsingBlock:
    ^(id object, BOOL *stop) 
   {
      UITouch* touch = (UITouch*)object;
      
      CGPoint p = [touch locationInView:self];
      
      CGRect frame = [self.thumb frame];
      
      if(CGRectContainsPoint(frame, p))
         process = YES;
      
      CGRect buddyFrame = [self.buddy frame];

      if(CGRectContainsPoint(buddyFrame, p))
         processOwner = YES;
   }];
   
   if( (process == NO)&&(processOwner == NO)) return;
      
   if(process == YES)
   if((photo.image == nil)&&(!photo.isFetching))
   {
      //NSLog(@"PHOTO IS NIL");
      photo.isFetching=YES;
      [MBProgressHUD showHUDAddedTo:self.thumb animated:YES];

      dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), 
                     ^{
                        [self downloadImage];
                        
                        dispatch_sync(dispatch_get_main_queue(), 
                                       ^{
                                          [self processPopover];
                                          
                                          //NSLog(@"UPDATE------------");
                                          [MBProgressHUD hideHUDForView:self.thumb animated:YES];
                                       });
                        
                        
                        photo.isFetching = NO;
                     });      
   }
   else
      [self processPopover];
   
   if(processOwner == YES)
   {
      UIActionSheet *popupQuery = 
      [[UIActionSheet alloc] 
       initWithTitle:@"flickr user" 
       delegate:self 
       cancelButtonTitle:@"Cancel" 
       destructiveButtonTitle:nil
       otherButtonTitles:photo.ownername, @"Add", @"List", nil];
      
      popupQuery.actionSheetStyle = UIActionSheetStyleAutomatic;
      [popupQuery showInView:mainViewController.view];
      [popupQuery release];

   }
}

#pragma mark - owner table
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return @"Choose user to see their photos";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.owners.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"OwnerCell";
   
   UITableViewCell *cell = 
   [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
   if (cell == nil) 
   {
      cell = 
      [[[UITableViewCell alloc] 
        initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:CellIdentifier] autorelease];
   }
   
   cell.textLabel.text = [[self.owners allValues] objectAtIndex:indexPath.row];
 
   return cell;
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{    
   if (editingStyle == UITableViewCellEditingStyleDelete) 
   {
      NSString* ownerKey = [[self.owners allKeys] objectAtIndex:indexPath.row];
      
      NSLog(@"%@", ownerKey);
      NSLog(@"%@", self.owners);
      
      [self.owners removeObjectForKey:ownerKey];
      
      NSLog(@"%@", self.owners);
      
      [self writeOwners];
      
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];

   }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   MainViewController* mainViewController = (MainViewController*)app.mainViewController;

   //fetch owner
   [mainViewController showWaitWith:[[self.owners allValues]objectAtIndex:indexPath.row]];
   [app getSearchWithOwner:[[self.owners allKeys]objectAtIndex:indexPath.row]];
   
   [mainViewController dismissModalViewControllerAnimated:YES];
}

-(void)cancelOwnerList:(id)sender
{
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   MainViewController* mainViewController = (MainViewController*)app.mainViewController;
   
   [mainViewController dismissModalViewControllerAnimated:YES];   
}

-(void)showOwnerList
{
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   MainViewController* mainViewController = (MainViewController*)app.mainViewController;

   UITableViewController* tvc =
   [[[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
     
   UIToolbar* tb = [[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320, 44)] autorelease];
   UIBarButtonItem* tbi = 
   [[[UIBarButtonItem alloc] 
    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelOwnerList:)] autorelease];
   
   [tb setItems:[NSArray arrayWithObject:tbi]];
    
   tvc.tableView.tableHeaderView = tb;
   
   tvc.tableView.delegate = self;
   tvc.tableView.dataSource = self;
   
   [mainViewController presentModalViewController:tvc animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
   [self fetchOwners];
   
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   MainViewController* mainViewController = (MainViewController*)app.mainViewController;

   switch(buttonIndex)
   {
      case 0:         
         //fetch owner
         [mainViewController showWaitWith:photo.ownername];
         [app getSearchWithOwner:photo.owner];
         break;
      case 1:
         [self updateOwners];
         break;
      case 2:
         [self showOwnerList];
         break;
   }
}

-(void)fetchOwners
{
   NSString* documentsPath = 
   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];      
   
   NSString* ownersPath = 
   [documentsPath stringByAppendingPathComponent:@"owners"];
   
   if(self.owners == nil)
   {      
      BOOL ownersExists = [[NSFileManager defaultManager] fileExistsAtPath:ownersPath];
      
      if(ownersExists)
         self.owners = [NSMutableDictionary dictionaryWithContentsOfFile:ownersPath];
      else
         self.owners = [NSMutableDictionary dictionary];
   }
}

//write owners
-(void)writeOwners
{
   
   NSString* documentsPath = 
   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];      
   
   NSString* ownersPath = 
   [documentsPath stringByAppendingPathComponent:@"owners"];
   
   [self.owners writeToFile:ownersPath atomically:YES];
}

//add the current photo owner and save list
-(void)updateOwners
{ 
   NSString* documentsPath = 
   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];      
   
   NSString* ownersPath = 
   [documentsPath stringByAppendingPathComponent:@"owners"];

   [self.owners setValue:photo.ownername forKey:photo.owner];
   [self.owners writeToFile:ownersPath atomically:YES];
}

-(void)updateWithPhoto:(Photo*)p;
{
   //NSLog(@"%s", __PRETTY_FUNCTION__); 
   self.photo = p;
   
   if(self.photo == nil) return;
   
   self.owner.text            = [self.photo ownername];
   self.title.text            = [self.photo title];
   self.description.text      = [self.photo description];
   self.descriptionView.text  = [self.photo description];
   self.thumb.image           = self.photo.thumb;
   self.buddy.image           = [self.photo buddy];
   
   if(photo.mapPoint.coordinate.latitude != 0)
   { 
      self.locationAvailable.hidden = NO;
   }
   else
      self.locationAvailable.hidden = YES;
   
   if([popover isPopoverVisible]) 
   {
      [popover dismissPopoverAnimated:YES];
      [popover setDelegate:nil];
      [popover autorelease];
      
      popover = nil;
   } 
   
   if([mapover isPopoverVisible]) 
   {
      [mapover dismissPopoverAnimated:YES];
      [mapover setDelegate:nil];
      [mapover autorelease];
      
      mapover = nil;
   } 
}

-(void)dealloc
{
   [super dealloc];
}
@end

@implementation MainViewController

@synthesize mapView;
@synthesize infoView;
@synthesize infoViewEx;
@synthesize photoWall;
@synthesize tiles;
@synthesize searchBar;
@synthesize pandaPicker;
@synthesize app;

#pragma mark - fonemonkey
-(void) fmAssureAutomationInit
{
}


#pragma mark - 
-(void)showWait:(BOOL)on
{
   switch(on)
   {
      case YES:
         self.photoWall.scrollEnabled = NO;
            
         MBProgressHUD *hud = 
         [MBProgressHUD showHUDAddedTo:app.mainViewController.view animated:YES];
         
         hud.labelText = @"Loading";   
         break;
      case NO:
         [MBProgressHUD hideHUDForView:app.mainViewController.view animated:YES];

         self.photoWall.scrollEnabled = YES;
         break;
   }
}

-(void)showWaitWith:(NSString*)s
{
   self.photoWall.scrollEnabled = NO;
         
   MBProgressHUD *hud = 
   [MBProgressHUD showHUDAddedTo:app.mainViewController.view animated:YES];
         
   hud.labelText = s;   
}

-(void)updateInfoViewWith:(Photo*)photo
{
   if(photo == nil) return;
   
   [self.infoView updateWithPhoto:photo];
   [self.infoViewEx updateWithPhoto:photo];
      
   [self.mapView removeAnnotations:[self.mapView annotations]];
   
   if([[NSUserDefaults standardUserDefaults] boolForKey:SETTING_MAP_TYPE])
      self.mapView.mapType = MKMapTypeSatellite;
   else
      self.mapView.mapType = MKMapTypeStandard;
   
   if(photo.mapPoint.coordinate.latitude != 0)
   { 
      [self.mapView addAnnotation:photo.mapPoint];
      [self.mapView setCenterCoordinate:photo.mapPoint.coordinate];
   
      MKCoordinateRegion region = 
      MKCoordinateRegionMakeWithDistance([photo.mapPoint coordinate], 2500, 2500);
   
      [self.mapView setRegion:region animated:YES];
   }
}
#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component
{
   switch(row)
   {
      case 0: return @"ling ling"; 
      case 1: return @"hsing hsing";
      case 2: return @"wang wang";
      default: return @"";
   }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   self.pandaPicker.hidden = YES;

   NSInteger panda = [self.pandaPicker selectedRowInComponent:0];
   
   [self showWaitWith:[app.pandas objectAtIndex:panda]];
   
   [app getPanda:[app.pandas objectAtIndex:panda]];
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
   return [self.app.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tv 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"PhotoCell";

   UITableViewCell *cell = 
   [tv dequeueReusableCellWithIdentifier:CellIdentifier];
   
   if (cell == nil) 
   {
      cell = 
      [[[UITableViewCell alloc] 
        initWithStyle:UITableViewCellStyleSubtitle 
        reuseIdentifier:CellIdentifier] autorelease];
   }
      
   Photo* photo = [self.app.photos objectAtIndex:indexPath.row];
   
   cell.textLabel.text       = [photo title];
   cell.detailTextLabel.text = [photo ownername];
   
   /////////////////////////////////////////////////////////////////////////////
   if(photo.thumb == nil)
   {
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
      dispatch_async(queue, 
                     ^{
                        UIImage* image;
                        
                        if(photo.photoThumbURL == nil)
                        {
                           image = [UIImage imageNamed:@"needs_uploading.png"];
                        }
                        else
                        {
                           NSData *imageData = [NSData dataWithContentsOfURL:photo.photoThumbURL];
                           image = [UIImage imageWithData:imageData];
                           
                           if(imageData == nil)
                              image = [UIImage imageNamed:@"icon.png"];
                        }
                        
                        photo.thumb = image;
                        
                        dispatch_sync(dispatch_get_main_queue(), 
                                      ^{
                                         cell.imageView.image = photo.thumb;
                                         [cell setNeedsLayout];
                                      });
                     });  
   }
   else
   {
      cell.imageView.image = photo.thumb;
   }
   
   return cell;

   /////////////////////////////////////////////////////////////////////////////
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   Photo* photo = [self.app.photos objectAtIndex:indexPath.row];
   
   [self updateInfoViewWith:photo];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
   [super viewDidLoad];
   
   self.app = (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   //view type starts out as WALL
   viewType = WALL;
   
   //roll the corners
   //tableView.layer.cornerRadius = 10.0;
   //scrollView.layer.cornerRadius = 10.0;
      
   //add info view
   NSArray *xibviews = 
   [[NSBundle mainBundle] loadNibNamed: @"InfoView" owner: scrollView options: NULL];
   
   self.infoView = [xibviews objectAtIndex: 0];
   self.infoView.buddy.layer.cornerRadius = 9.0;
   
   self.infoView.thumb.layer.cornerRadius = 9.0;
   self.infoView.thumb.layer.masksToBounds = YES;
   self.infoView.thumb.layer.borderColor = [UIColor blackColor].CGColor;
   self.infoView.thumb.layer.borderWidth = 1.0;
   
   //add extended info view
   NSArray *xibviewsex = 
   [[NSBundle mainBundle] loadNibNamed: @"InfoViewEx" owner: scrollView options: NULL];

   self.infoViewEx = [xibviewsex objectAtIndex:0];
   self.infoViewEx.frame = CGRectMake(320, 0, 320, INFO_HEIGHT);
   
   //SNE CHECK
   //add map view
   self.mapView = 
   [[[MKMapView alloc] initWithFrame:CGRectMake(640, 0, 320, INFO_HEIGHT)] autorelease];
   
   //SNE CHECK - TRY ALLOWING SCROLLING IN MAP
   self.mapView.scrollEnabled = NO;
   
   //scroll view
   scrollView.contentSize = CGSizeMake(960, INFO_HEIGHT);
   scrollView.pagingEnabled = YES;
   scrollView.delegate = self;
   
   //setup the page control
   pageControl.numberOfPages = 3;
   [pageControl 
    addTarget:self 
    action:@selector(pageControlTapped) 
    forControlEvents:UIControlEventValueChanged];
   
   
   [scrollView addSubview:infoView];
   [scrollView addSubview:infoViewEx];
   [scrollView addSubview:mapView];
   
   scrollView.bounces = NO;
   
   //make us the listener for photos changes
   self.app.photosUpdatedDelegate = self;
   
   /////////////////////////////////////////////////////////////////////////////
   //ADD PHOTO VIEWER
   
   //[tableView removeFromSuperview];
   
   //width = self.view.bounds.size.width;
   //height = self.view.bounds.size.height;
   CGRect frameRect = CGRectMake(0, 42, 320, 262);
	
   //UIScrollView *infScroller = 
   self.photoWall =
   [[[UIScrollView alloc] initWithFrame:frameRect] autorelease];
   
   self.photoWall.contentSize = CGSizeMake(BIG, BIG);
   self.photoWall.delegate = self;
   self.photoWall.contentOffset = CGPointMake(BIG/2, BIG/2);
   self.photoWall.backgroundColor = [UIColor blackColor];
   self.photoWall.showsHorizontalScrollIndicator = NO;
   self.photoWall.showsVerticalScrollIndicator = NO;
   self.photoWall.decelerationRate = UIScrollViewDecelerationRateNormal;
   
   [self.view addSubview:self.photoWall];
   
   CGRect infFrame = CGRectMake(0, 0, BIG, BIG);
   
   self.tiles = [[[PRPTileView alloc] initWithFrame:infFrame] autorelease];
   
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                  initWithTarget:self 
                                  action:@selector(photoWallTapped:)];								
   [self.tiles addGestureRecognizer:tap];
   [tap release]; 
   
   
   self.tiles.photos = self.app.photos;
   
   [self.photoWall addSubview:self.tiles];
   
   /////////////////////////////////////////////////////////////////////////////
   
   [self.view bringSubviewToFront:self.searchBar];
   [self.view bringSubviewToFront:self.pandaPicker];
   
   //[app getPandaList];
   
   //[self performSelector:@selector(getPandaList) withObject:nil afterDelay:3.0 inModes:nil];
   
   //[self refreshTapped:nil];
   
   //[self performSelector:@selector(getPandaList) withObject:nil afterDelay:3.0];
   
   [app getPanda:@"ling ling"];
}

-(void)getPandaList
{
   [app getPandaList];
}

- (void)photoWallTapped:(UITapGestureRecognizer *)tap 
{ 
   //NSLog(@"%s", __PRETTY_FUNCTION__);  

   //PRPTileView *theTiles = (PRPTileView *)tap.view;
   
   CGPoint tapPoint = [tap locationInView:tiles];
   
   Photo* photo = [tiles photoFromTouch:tapPoint];
   
   [self updateInfoViewWith:photo];
}


#pragma mark - button events
-(void)pageControlTapped
{
   //NSLog(@"%s %d", __PRETTY_FUNCTION__,pageControl.currentPage);
   
   CGRect moveTo = CGRectMake(320*(pageControl.currentPage), 0, 320, 118);
   [scrollView scrollRectToVisible:moveTo animated:YES];
}

- (IBAction)viewTypeTapped:(id)sender
{
   //NSLog(@"%s", __PRETTY_FUNCTION__);  
   
   UIBarButtonItem* viewTypeButton = (UIBarButtonItem*)sender;
   switch(viewType)
   {
      case LIST:
         [viewTypeButton setImage:[UIImage imageNamed:@"42-photos.png"]];
         self.photoWall.hidden = NO;
         tableView.hidden = YES;
         viewType = WALL;
         
         [self.tiles setNeedsDisplay];
         break;
      case WALL:
         [viewTypeButton setImage:[UIImage imageNamed:@"179-notepad.png"]];
         self.photoWall.hidden = YES;
         tableView.hidden = NO;
         viewType = LIST;
         
         [tableView reloadData];
         break;
      default:
         break;
   }
}

-(void)doPandaX
{
   [self.pandaPicker selectRow:-1 inComponent:0 animated:YES];
   
   CGRect pickerframe = self.pandaPicker.frame;
   CGRect startFrame = self.pandaPicker.frame;
   
   startFrame.origin.y = -pickerframe.size.height;
   
   self.pandaPicker.frame = startFrame;
   
   self.pandaPicker.hidden = NO;  
   
   [UIView animateWithDuration:0.7
                         delay:0.0
                       options: UIViewAnimationCurveEaseOut
                    animations:
   ^{
       self.pandaPicker.frame = pickerframe;
    } 
                    completion:
    ^(BOOL finished)
    {
    }];
}

-(void)doPanda
{
   NSString* panda = [self.app nextPanda];
   
   [self showWaitWith:panda];   
   [self.app getPanda:panda];
}

-(void)doSearch
{
   CGRect searchBarFrame = self.searchBar.frame;
   CGRect startFrame = self.searchBar.frame;
   
   startFrame.origin.y = -searchBarFrame.size.height;
   
   self.searchBar.frame = startFrame;
   
   self.searchBar.hidden = NO;  
   
   [UIView animateWithDuration:0.3
                         delay:0.0
                       options: UIViewAnimationCurveEaseOut
                    animations:
                  ^{
                     self.searchBar.frame = searchBarFrame;
                     [self.searchBar becomeFirstResponder];
                  } 
                    completion:
                  ^(BOOL finished)
                  {
                     //[self.searchBar becomeFirstResponder];
                  }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   //self.searchBar.hidden = YES;
   //[self.searchBar resignFirstResponder];
      
   //MOVE THE SEARCHBAR
   CGRect searchBarFrame = self.searchBar.frame;
   CGRect endFrame = self.searchBar.frame;
   
   endFrame.origin.y = -searchBarFrame.size.height;
   
   self.searchBar.hidden = NO;  
   
   [UIView animateWithDuration:0.3
                         delay:0.0
                       options: UIViewAnimationCurveEaseOut
                    animations:
    ^{
       self.searchBar.frame = endFrame;
       [self.searchBar resignFirstResponder];
    } 
                    completion:
    ^(BOOL finished)
    {
       self.searchBar.hidden = YES;
       self.searchBar.frame = searchBarFrame;
    }];
   ////////////////////
   
   [self showWaitWith:self.searchBar.text];   
   [self.app getSearchWith:self.searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
   //self.searchBar.hidden = YES;
   //[self.searchBar resignFirstResponder];
   
   CGRect searchBarFrame = self.searchBar.frame;
   CGRect endFrame = self.searchBar.frame;
   
   endFrame.origin.y = -searchBarFrame.size.height;
   
   self.searchBar.hidden = NO;  
   
   [UIView animateWithDuration:0.3
                         delay:0.0
                       options: UIViewAnimationCurveEaseOut
                    animations:
    ^{
       self.searchBar.frame = endFrame;
       [self.searchBar resignFirstResponder];
    } 
                    completion:
    ^(BOOL finished)
    {
       self.searchBar.hidden = YES;
       self.searchBar.frame = searchBarFrame;
    }];
}

- (IBAction)refreshTapped:(id)sender
{
   //NSLog(@"%s", __PRETTY_FUNCTION__);  
   
   switch(requestType)
   {
      case PANDA:
         //[self showWaitWith:@"panda"];
         //[app getPanda:@"ling ling"];
         [self doPanda];
         break;
      case RECENT:
         [self showWaitWith:@"recent"];
         [app getRecent];
         break;
      case SEARCH:
         [self doSearch];
         break;
      default:
         break;
   }
}

- (IBAction)choiceMade:(id)sender;
{
   //NSLog(@"%s", __PRETTY_FUNCTION__);  
   
   UISegmentedControl* c = (UISegmentedControl*) sender;
   
   requestType = c.selectedSegmentIndex;
   
   [self refreshTapped:nil];
}

- (IBAction)photoTapped:(id)sender
{
   //NSLog(@"%s", __PRETTY_FUNCTION__);  
}

- (void)photosUpdated
{
   //NSLog(@"%s", __PRETTY_FUNCTION__); 
   
   //[tableView reloadData];
   //self.photoWall.layer.contents = nil;
   //[self.photoWall setNeedsDisplay];
   //[self.photoWall.layer setNeedsDisplay];
   
   [MBProgressHUD hideHUDForView:self.app.mainViewController.view animated:YES];
   self.photoWall.scrollEnabled = YES;
   
   switch(viewType)
   {
      case LIST:
         [tableView reloadData];
         break;
      case WALL:
         [self.tiles setNeedsDisplay];
//         dispatch_async(dispatch_get_main_queue(), 
//                        ^{
//                           [self.tiles setNeedsDisplay];
//                        });
//
         break;
   }
}

-(void)photosReturnedError:(NSError*)error
{
   [MBProgressHUD hideHUDForView:self.app.mainViewController.view animated:YES];
   self.photoWall.scrollEnabled = YES;

   UIAlertView* alert = 
   [[[UIAlertView alloc] 
    initWithTitle:@"flickr error" 
    message:[error localizedDescription] 
    delegate:nil 
    cancelButtonTitle:@"Ok" 
    otherButtonTitles:nil] autorelease];
   
   [alert show];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sv
{
   //is this the scrollview with the info?
   CGFloat cx = sv.contentOffset.x;
   NSUInteger index = (NSUInteger)(cx / scrollView.frame.size.width);
   if (index >= pageControl.numberOfPages) 
   {
      //index = NSNotFound;
   }
   else
   {
      pageControl.currentPage = index; 
   }
}

#pragma mark - flip side
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showSettings:(id)sender
{    
   FlipsideViewController *controller = 
   [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
   controller.delegate = self;
       
   controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
   [self presentModalViewController:controller animated:YES];
       
   [controller release];
}

- (IBAction)showInfo:(id)sender
{    
   SVWebViewController *webViewController = 
   [[SVWebViewController alloc] 
    initWithAddress:[self.infoView.photo.photoSourceURL absoluteString]];
   
   webViewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
   webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
   webViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:webViewController animated:YES];	

	[webViewController release];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
