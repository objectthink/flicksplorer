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

@implementation InfoView
@synthesize owner;
@synthesize title;
@synthesize description;
@synthesize descriptionView;
@synthesize locationAvailable;
@synthesize photo;
@synthesize thumb;
@synthesize buddy;

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
   NSLog(@"%s", __PRETTY_FUNCTION__);  
   //SNE CHECK
   //add map view
   /////////////////
   if(!mapover)
   {
      UIViewController *c = [[[UIViewController alloc] init] autorelease];
      
      MKMapView* mapView 
      = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 290, 220)] autorelease];
      
      [mapView addAnnotation:photo.mapPoint];
      [mapView setCenterCoordinate:photo.mapPoint.coordinate];
      
      MKCoordinateRegion region = 
      MKCoordinateRegionMakeWithDistance([photo.mapPoint coordinate], 2500, 2500);
      
      [mapView setRegion:region animated:YES];

      c.view = mapView;
      
      c.contentSizeForViewInPopover = 
      CGRectMake(0, 0,290,220).size;
      
      mapover = [[WEPopoverController alloc] initWithContentViewController:c];
      
      [mapover setDelegate:self];
   } 
   
   if([mapover isPopoverVisible]) 
   {
      [mapover dismissPopoverAnimated:YES];
      [mapover setDelegate:nil];
      [mapover autorelease];
      
      mapover = nil;
   } 
   else 
   {
      utilityAppDelegate* app =
      (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
      
      [mapover 
       presentPopoverFromRect:CGRectMake(15, 340, 75, 75)
       inView:app.mainViewController.view
       permittedArrowDirections:UIPopoverArrowDirectionDown
       animated:YES];
   }

}

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   NSLog(@"%s", __PRETTY_FUNCTION__);  

   if(photo.image == nil)
   {
      NSData  *imageData = [NSData dataWithContentsOfURL:self.photo.photoURL];
      UIImage *image = [UIImage imageWithData:imageData];
      
      photo.image = image;
   }
   
   /////////////////
   if(!popover)
   {
      UIViewController *c = [[[UIViewController alloc] init] autorelease];
      
      c.view = [[[UIImageView alloc] initWithImage:photo.image] autorelease];
      
      c.contentSizeForViewInPopover = 
      CGRectMake(0, 0,photo.image.size.width,photo.image.size.height).size;
      
      popover = [[WEPopoverController alloc] initWithContentViewController:c];
      
      [popover setDelegate:self];
   } 
   
   if([popover isPopoverVisible]) 
   {
      [popover dismissPopoverAnimated:YES];
      [popover setDelegate:nil];
      [popover autorelease];
      
      popover = nil;
   } 
   else 
   {
      utilityAppDelegate* app =
      (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];

      [popover 
       presentPopoverFromRect:CGRectMake(15, 340, 75, 75)
       inView:app.mainViewController.view
       permittedArrowDirections:UIPopoverArrowDirectionDown
       animated:YES];
   }
/////////////////
}

-(void)updateWithPhoto:(Photo*)p;
{
   NSLog(@"%s", __PRETTY_FUNCTION__); 
   self.photo = p;
   
   if(self.photo == nil) return;
   
   self.owner.text            = [self.photo ownername];
   self.title.text            = [self.photo title];
   self.description.text      = [self.photo description];
   self.descriptionView.text  = [self.photo description];
   self.thumb.image           = [self.photo thumb];
   self.buddy.image           = [self.photo buddy];
   
   if(photo.mapPoint.coordinate.latitude != 0)
   { 
      self.locationAvailable.hidden = NO;
   }
   else
      self.locationAvailable.hidden = YES;
}

-(void)dealloc
{
   [super dealloc];
}
@end

@implementation MainViewController

@synthesize mapView;
@synthesize infoView;
@synthesize photoWall;
@synthesize tiles;
@synthesize searchBar;
@synthesize app;

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
      
//   self.infoView.owner.text            = [photo ownername];
//   self.infoView.title.text            = [photo title];
//   self.infoView.description.text      = [photo description];
//   self.infoView.descriptionView.text  = [photo description];
//   self.infoView.thumb.image           = [photo thumb];
//   self.infoView.buddy.image           = [photo buddy];
   
//   [self.infoView sizeToFit];
   
   [self.mapView removeAnnotations:[self.mapView annotations]];
   
   if(photo.mapPoint.coordinate.latitude != 0)
   { 
      [self.mapView addAnnotation:photo.mapPoint];
      [self.mapView setCenterCoordinate:photo.mapPoint.coordinate];
   
      MKCoordinateRegion region = 
      MKCoordinateRegionMakeWithDistance([photo.mapPoint coordinate], 2500, 2500);
   
      [self.mapView setRegion:region animated:YES];
      
//      self.infoView.locationAvailable.hidden = NO;
   }
//   else
//      self.infoView.locationAvailable.hidden = YES;
}
#pragma mark - UITableViewDelegate
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//   return @"header";
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//   return @"footer";
//}
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
   
   //SNE CHECK
   //add map view
   self.mapView = 
   [[[MKMapView alloc] initWithFrame:CGRectMake(320, 0, 320, INFO_HEIGHT)] autorelease];
   
   //SNE CHECK - TRY ALLOWING SCROLLING IN MAP
   self.mapView.scrollEnabled = NO;
   
   //scroll view
   scrollView.contentSize = CGSizeMake(640, INFO_HEIGHT);
   scrollView.pagingEnabled = YES;
   scrollView.delegate = self;
   
   //setup the page control
   pageControl.numberOfPages = 2;
   [pageControl 
    addTarget:self 
    action:@selector(pageControlTapped) 
    forControlEvents:UIControlEventValueChanged];
   
   
   [scrollView addSubview:infoView];
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
   
   //SNE CHECK
   //[self.photoWall release];
	
   CGRect infFrame = CGRectMake(0, 0, BIG, BIG);
   
   self.tiles = [[[PRPTileView alloc] initWithFrame:infFrame] autorelease];
   
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                  initWithTarget:self 
                                  action:@selector(photoWallTapped:)];								
   [self.tiles addGestureRecognizer:tap];
   [tap release]; 
   
   
   self.tiles.photos = self.app.photos;
   
   [self.photoWall addSubview:self.tiles];
   
   //SNE CHECK
   //[self.tiles release];

   /////////////////////////////////////////////////////////////////////////////
   
   [self.view bringSubviewToFront:self.searchBar];
   
   [self refreshTapped:nil];
}

- (void)photoWallTapped:(UITapGestureRecognizer *)tap 
{ 
   NSLog(@"%s", __PRETTY_FUNCTION__);  

   //PRPTileView *theTiles = (PRPTileView *)tap.view;
   
   CGPoint tapPoint = [tap locationInView:tiles];
   
   Photo* photo = [tiles photoFromTouch:tapPoint];
   
   [self updateInfoViewWith:photo];
}


#pragma mark - button events
-(void)pageControlTapped
{
   NSLog(@"%s %d", __PRETTY_FUNCTION__,pageControl.currentPage);
   
   CGRect moveTo = CGRectMake(320*(pageControl.currentPage), 0, 320, 118);
   [scrollView scrollRectToVisible:moveTo animated:YES];
}

- (IBAction)viewTypeTapped:(id)sender
{
   NSLog(@"%s", __PRETTY_FUNCTION__);  
   
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

-(void)doSearch
{
   CGRect searchBarFrame = self.searchBar.frame;
   CGRect startFrame = self.searchBar.frame;
   
   startFrame.origin.y = -searchBarFrame.size.height;
   
   self.searchBar.frame = startFrame;
   
   self.searchBar.hidden = NO;  
   
   [UIView animateWithDuration:0.7
                         delay:0.0
                       options: UIViewAnimationCurveEaseOut
                    animations:
                  ^{
                     self.searchBar.frame = searchBarFrame;
                  } 
                    completion:
                  ^(BOOL finished)
                  {
                     [self.searchBar becomeFirstResponder];
                  }];

   //[self.searchBar becomeFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   self.searchBar.hidden = YES;
   [self.searchBar resignFirstResponder];
   
   [self showWaitWith:self.searchBar.text];
   
   [self.app getSearchWith:self.searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
   self.searchBar.hidden = YES;
   [self.searchBar resignFirstResponder];
}

- (IBAction)refreshTapped:(id)sender
{
   NSLog(@"%s", __PRETTY_FUNCTION__);  
   
   switch(requestType)
   {
      case PANDA:
         [self showWaitWith:@"panda"];
         [app getPanda];
         break;
      case RECENT:
         [self showWaitWith:@"recent"];
         [app getRecent];
         break;
      case SEARCH:
         [self doSearch];
         break;
   }
}

- (IBAction)choiceMade:(id)sender;
{
   NSLog(@"%s", __PRETTY_FUNCTION__);  
   
   UISegmentedControl* c = (UISegmentedControl*) sender;
   
   requestType = c.selectedSegmentIndex;
   
   [self refreshTapped:nil];
}

- (IBAction)photoTapped:(id)sender
{
   NSLog(@"%s", __PRETTY_FUNCTION__);  
}

- (void)photosUpdated
{
   NSLog(@"%s", __PRETTY_FUNCTION__); 
   
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

- (IBAction)showInfo:(id)sender
{    
//   FlipsideViewController *controller = 
//   [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
//   controller.delegate = self;
//    
//   controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//   [self presentModalViewController:controller animated:YES];
//    
//   [controller release];
   
   SVWebViewController *webViewController = 
   [[SVWebViewController alloc] 
    initWithAddress:[self.infoView.photo.photoSourceURL absoluteString]];
	
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
