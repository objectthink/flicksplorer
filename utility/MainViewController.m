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
      UIViewController *c = [[UIViewController alloc] init];
      
      c.view = [[UIImageView alloc] initWithImage:photo.image];
      
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
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];

   return [app.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];

   UITableViewCell* cell = 
   [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"test"];
   
   Photo* photo = [app.photos objectAtIndex:indexPath.row];
   
   cell.textLabel.text = [[app.photos objectAtIndex:indexPath.row] title];

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
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   [self updateInfoViewWith:[app.photos objectAtIndex:indexPath.row]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
   [super viewDidLoad];
   
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
   
   //add map view
   self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(320, 0, 320, INFO_HEIGHT)];
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
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   app.photosUpdatedDelegate = self;
   
   /////////////////////////////////////////////////////////////////////////////
   //ADD PHOTO VIEWER
   
   //[tableView removeFromSuperview];
   
   //width = self.view.bounds.size.width;
   //height = self.view.bounds.size.height;
   CGRect frameRect = CGRectMake(0, 42, 320, 262);
	
   //UIScrollView *infScroller = 
   self.photoWall =
   [[UIScrollView alloc] initWithFrame:frameRect];
   
   self.photoWall.contentSize = CGSizeMake(BIG, BIG);
   self.photoWall.delegate = self;
   self.photoWall.contentOffset = CGPointMake(BIG/2, BIG/2);
   self.photoWall.backgroundColor = [UIColor blackColor];
   self.photoWall.showsHorizontalScrollIndicator = NO;
   self.photoWall.showsVerticalScrollIndicator = NO;
   self.photoWall.decelerationRate = UIScrollViewDecelerationRateNormal;
   
   [self.view addSubview:self.photoWall];
   
   [self.photoWall release];
	
   CGRect infFrame = CGRectMake(0, 0, BIG, BIG);
   
   self.tiles = [[PRPTileView alloc] initWithFrame:infFrame];
   
   UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] 
                                  initWithTarget:self 
                                  action:@selector(photoWallTapped:)];								
   [self.tiles addGestureRecognizer:tap];
   [tap release]; 
   
   
   self.tiles.photos = app.photos;
   
   [self.photoWall addSubview:self.tiles];
   [self.tiles release];

   /////////////////////////////////////////////////////////////////////////////
   
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

-(void)getSearchText
{
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];

   UISearchBar* sb = [UISearchBar new];
   
   [app.mainViewController.view addSubview:sb];
}

- (IBAction)refreshTapped:(id)sender
{
   NSLog(@"%s", __PRETTY_FUNCTION__);  
   
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   self.photoWall.scrollEnabled = NO;
   
   MBProgressHUD *hud = 
   [MBProgressHUD showHUDAddedTo:app.mainViewController.view animated:YES];
   
   hud.labelText = @"Loading";   

   switch(requestType)
   {
      case PANDA:
         [app getPanda];
         break;
      case RECENT:
         [app getRecent];
         break;
      case SEARCH:
         //[app getSearchWith:@"cozumel"];
         [self getSearchText];
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
   
   utilityAppDelegate* app =
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   [MBProgressHUD hideHUDForView:app.mainViewController.view animated:YES];
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sv
{
   CGFloat cx = sv.contentOffset.x;
   NSUInteger index = (NSUInteger)(cx / scrollView.frame.size.width);
   if (index >= pageControl.numberOfPages) 
   {
      index = NSNotFound;
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
