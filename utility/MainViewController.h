//
//  MainViewController.h
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "FlipsideViewController.h"
#import "utilityAppDelegate.h"
#import "Photo.h"
#import "WEPopoverController.h"
#import "Session.h"

#import "PRPTileView.h"

typedef enum {
   WALL        = 0,
   LIST        = 1
}VIEWTYPE;

@interface InfoView : UIView <PopoverControllerDelegate>
{
   //Photo* photo;
   
   WEPopoverController* popover;
}

@property (retain) IBOutlet UILabel* owner;
@property (retain) IBOutlet UILabel* title;
@property (retain) IBOutlet UILabel* description;
@property (retain) IBOutlet UITextView* descriptionView;
@property (retain) IBOutlet UIImageView* thumb;
@property (retain) IBOutlet UIImageView* buddy;
@property (retain) IBOutlet UIButton* locationAvailable;

@property (retain) Photo* photo; 

-(void)updateWithPhoto:(Photo*)photo;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface MainViewController : UIViewController <
FlipsideViewControllerDelegate, 
UITableViewDataSource, 
UITableViewDelegate,
UIScrollViewDelegate,
PhotosUpdatedDelegate> 
{
   IBOutlet UITableView* tableView;
   IBOutlet UIScrollView* scrollView;
   IBOutlet UIPageControl* pageControl;
   IBOutlet UISegmentedControl* choice;
   
   VIEWTYPE viewType;
   REQUESTTYPE requestType;
}

@property (retain) MKMapView* mapView;
@property (retain) InfoView* infoView;
@property (retain) UIScrollView* photoWall;
@property (retain) PRPTileView *tiles;

- (IBAction)showInfo:(id)sender;
- (IBAction)choiceMade:(id)sender;
- (IBAction)viewTypeTapped:(id)sender;
- (IBAction)refreshTapped:(id)sender;
- (IBAction)photoTapped:(id)sender;

- (void)photosUpdated;
@end

