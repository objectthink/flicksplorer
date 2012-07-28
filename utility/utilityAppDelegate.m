//
//  utilityAppDelegate.m
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import "utilityAppDelegate.h"
#import "MainViewController.h"
#import "SVWebViewController.h"
#import "Session.h"
#import "Photo.h"

@implementation MyRequest

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
   //NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest, inResponseDictionary);   
   
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
   //NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest, inError);   
}
@end

@implementation utilityAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;
@synthesize photos;
@synthesize pandas;
@synthesize photosUpdatedDelegate;

@synthesize fContext;
@synthesize fRequest;

@synthesize photoCache;

////////////////////////////////////////////////////////////////////////////////
//locationManager:didUpdateToLocation:fromLocation
//store the current location to be used in the new stop
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
   NSLog(@"%@ time:%f",newLocation,[[newLocation timestamp]timeIntervalSinceNow]);
   
   currentLocation = [newLocation coordinate];
   
   // test that the horizontal accuracy does not indicate an invalid measurement
   if (newLocation.horizontalAccuracy < 0) return;
   // test the age of the location measurement to determine if the measurement is cached
   // in most cases you will not want to rely on cached measurements
   NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
   if (locationAge > 5.0) return;
   
   //WEVE GOT A LOCATION SO STOP UPDATES
   [locationManager stopUpdatingLocation];
}

BOOL userInformedOfDisabledLocationServices = NO;
////////////////////////////////////////////////////////////////////////
//locationManager:didFailWithError
//there was an error getting the current location
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
   
   //[ModalAlert say:[error localizedDescription]];
   
   if ([error domain] == kCLErrorDomain)
   {
      // We handle CoreLocation-related errors here
      switch ([error code])
      {
            // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
            // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
         case kCLErrorDenied:
            // USER HAS DISALLOWED LOCATION SERVICES
            // STOP UPDATING LOCATION
            [locationManager stopUpdatingLocation];
            break;
         case kCLErrorLocationUnknown:
            break;
         default:
            break;
      }
   }
   else
   {
      // We handle all non-CoreLocation errors here
   }
}

///////////////////////////////////////////////////////////////////////////////
//UIImagePicker delegate interface
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
   //STOP THE LOCATION MANAGER
   [locationManager stopUpdatingLocation];
   
   [self.mainViewController dismissModalViewControllerAnimated:YES];
}
///////////////////////////////////////////////////////////////////////////////
//imagePickerController:didFInishPickingMediaWithInfo:
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
   //[image retain];
      
   [self.mainViewController dismissModalViewControllerAnimated:YES];
      
   /////////////////////////////////////////////////////////////////////////
   // we schedule this call in run loop because we want to dismiss the modal view first
   //[self performSelector:@selector(getStopInfo:) withObject:image afterDelay:0.5];
   //[self performSelector:@selector(Upload:) withObject:image afterDelay:0.5];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // Override point for customization after application launch.
   // Add the main view controller's view to the window and display.
      
   self.fContext = [OFFlickrAPIContext alloc];
   
   [self.fContext initWithAPIKey:OBJECTIVE_FLICKR_API_KEY 
                    sharedSecret:OBJECTIVE_FLICKR_API_SHARED_SECRET];
   
   self.fRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.fContext];
   
   [self.fRequest setDelegate:self];
   
   self.photos = [NSMutableArray arrayWithCapacity:10];
   
   //self.pandas = [NSMutableArray arrayWithObjects:@"ling ling",@"hsing hsing",@"wang wang", nil];
      
   self.window.rootViewController = self.mainViewController;
   [self.window makeKeyAndVisible];
   
   self.photoCache = [[NSCache alloc] init];
   
   //[self getPandaList];
   
   //populate pandas array from static data for now
   self.pandas = [NSMutableArray array];
   
   if([[NSUserDefaults standardUserDefaults] boolForKey:PANDA_LING_LING])
      [self.pandas addObject:@"ling ling"];

   if([[NSUserDefaults standardUserDefaults] boolForKey:PANDA_HSING_HSING])
      [self.pandas addObject:@"hsing hsing"];
   
   if([[NSUserDefaults standardUserDefaults] boolForKey:PANDA_WANG_WANG])
      [self.pandas addObject:@"wang wang"];
   
   if([self.pandas count]==0)
      [self.pandas addObject:@"ling ling"];

   //CREATE THE LOCATION MANAGER INSTANCE
   locationManager = [[CLLocationManager alloc] init];
   [locationManager setDistanceFilter:kCLDistanceFilterNone];
   [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

   return YES;
}

-(void)getPandaList
{
//   OFFlickrAPIContext* c = 
//   [[OFFlickrAPIContext alloc] 
//    initWithAPIKey:OBJECTIVE_FLICKR_API_KEY 
//    sharedSecret:OBJECTIVE_FLICKR_API_SHARED_SECRET];
//   
//   OFFlickrAPIRequest* r =
//   [[OFFlickrAPIRequest alloc] initWithAPIContext:c];
//   
//   r.sessionInfo = [Session sessionWithRequestType:PANDA_LIST];
//   
//   [r 
//    callAPIMethodWithGET:@"flickr.panda.getList" 
//    arguments:nil];

   self.fRequest.sessionInfo = [Session sessionWithRequestType:PANDA_LIST];
   
   [self.fRequest 
    callAPIMethodWithGET:@"flickr.panda.getList" 
    arguments:nil];
}

-(void)refreshPandaList
{
   [self.pandas removeAllObjects];

   if([[NSUserDefaults standardUserDefaults] boolForKey:PANDA_LING_LING])
      [self.pandas addObject:@"ling ling"];
   
   if([[NSUserDefaults standardUserDefaults] boolForKey:PANDA_HSING_HSING])
      [self.pandas addObject:@"hsing hsing"];
   
   if([[NSUserDefaults standardUserDefaults] boolForKey:PANDA_WANG_WANG])
      [self.pandas addObject:@"wang wang"];
   
   if([self.pandas count]==0)
      [self.pandas addObject:@"ling ling"];
}

int pandaIndex=0;
-(NSString*)nextPanda
{
   if(pandaIndex >= [self.pandas count])
      pandaIndex = 0;
   
   return [self.pandas objectAtIndex:pandaIndex++];
}

-(void)getPanda:(NSString*)s
{
   [self.photos removeAllObjects];
   
   [self.photoCache removeAllObjects];
   
   self.fRequest.sessionInfo = [Session sessionWithRequestType:PANDA];
   
   [self.fRequest 
    callAPIMethodWithGET:@"flickr.panda.getPhotos" 
    arguments:[NSDictionary dictionaryWithObjectsAndKeys:
               s, @"panda_name",
               @"description, license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_m, url_z, url_l, url_o", @"extras",nil]
    ];  
}

int page = 0;
-(void)getRecent
{
   page++;
   
   NSString* ps =
   [NSString stringWithFormat:@"%d",page];
   
   [self.photos removeAllObjects];
   
   [self.photoCache removeAllObjects];

   self.fRequest.sessionInfo = [Session sessionWithRequestType:RECENT];
   
   [self.fRequest 
    callAPIMethodWithGET:@"flickr.photos.getRecent" 
    arguments:[NSDictionary dictionaryWithObjectsAndKeys:
               @"description,license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_m, url_z, url_l, url_o", @"extras",@"100",@"per_page",ps,@"page",nil]
    ];     
}

-(void)getSearchWith:(NSString*)s
{
   [self.photos removeAllObjects];
   
   [self.photoCache removeAllObjects];
   
   page++;
   
   NSString* ps =
   [NSString stringWithFormat:@"%d",page];

   
   //CHANGE THIS TO SEARCH
   self.fRequest.sessionInfo = [Session sessionWithRequestType:RECENT];
      
   [self.fRequest 
    callAPIMethodWithGET:@"flickr.photos.search" 
    arguments:[NSDictionary dictionaryWithObjectsAndKeys:
s,@"text",@"description,license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_m, url_z, url_l, url_o", @"extras",@"100",@"per_page",ps,@"page",nil]

    ];        
}

-(void)getSearchWithOwner:(NSString*)s
{
   [self.photos removeAllObjects];
   
   [self.photoCache removeAllObjects];
   
   page++;
   
   NSString* ps =
   [NSString stringWithFormat:@"%d",page];
   
   
   //CHANGE THIS TO SEARCH
   self.fRequest.sessionInfo = [Session sessionWithRequestType:RECENT];
   
   [self.fRequest 
    callAPIMethodWithGET:@"flickr.photos.search" 
    arguments:[NSDictionary dictionaryWithObjectsAndKeys:
               s,@"user_id",@"description,license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_m, url_z, url_l, url_o", @"extras",@"100",@"per_page",ps,@"page",nil]
    
    ];        
}

-(void)authorization
{
   //set these to nil each time for now
   self.fContext.OAuthToken = nil;
   self.fContext.OAuthTokenSecret = nil;

   self.fRequest.sessionInfo = [Session sessionWithRequestType:AUTH];
   [self.fRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:CALLBACK_BASE_STRING]];
}
      
/**
	take and upload photo to flickr
 */
-(void)upload
{
   //CHANGE THIS TO UPLOAD
   self.fRequest.sessionInfo = [Session sessionWithRequestType:UPLOAD];
   
   ///////////////////////////////////////////////////////
   //START THE LOCATION MANAGER
   locationManager.delegate = self;
   [locationManager startUpdatingLocation];
   
   //////////////////////////////////////////////////////
   //START WITH NO CURRENT LOCATION SO THAT A PREVIOUS
   //LOCATION DOES NOT LEAK INTO A SUBSEQUENT STOP
   //currentLocation.latitude = 0;
   //currentLocation.longitude = 0;
   
   UIImagePickerController* picker = [[UIImagePickerController alloc] init];
   
   picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
   
//   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//      picker.sourceType = UIImagePickerControllerSourceTypeCamera;
   
   picker.delegate = self;
   picker.allowsEditing = YES;
   
   [self.mainViewController
    presentModalViewController:picker
    animated:YES];
   
   [picker release];
}

-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
//   if (self.fRequest.sessionInfo)
//   {
//      // already running some other request
//      NSLog(@"Already running some other request");
//   }
//   else
//   {
      NSString *token = nil;
      NSString *verifier = nil;
      BOOL result = OFExtractOAuthCallback(url, [NSURL URLWithString:CALLBACK_BASE_STRING], &token, &verifier);
      
      if (!result)
      {
         NSLog(@"Cannot obtain token/secret from URL: %@", [url absoluteString]);
         return NO;
      }
      
      self.fRequest.sessionInfo = @"";
      [self.fRequest fetchOAuthAccessTokenWithRequestToken:token verifier:verifier];

      //progress view goes here
   //}
	
   return YES;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
didObtainOAuthAccessToken:(NSString *)inAccessToken
                  secret:(NSString *)inSecret
            userFullName:(NSString *)inFullName
                userName:(NSString *)inUserName
                userNSID:(NSString *)inNSID
{
   NSLog(@"received authorization");
   
   [photosUpdatedDelegate flickrAuthorizationReceived];
   
   //dismiss progress here
   //store token and secret in user defaults

   //set these here for now
   self.fContext.OAuthToken = inAccessToken;
   self.fContext.OAuthTokenSecret = inSecret;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
didObtainOAuthRequestToken:(NSString *)inRequestToken
                  secret:(NSString *)inSecret
{
   // these two lines are important
   self.fContext.OAuthToken = inRequestToken;
   self.fContext.OAuthTokenSecret = inSecret;
   
   NSURL *authURL =
   [self.fContext
    userAuthorizationURLWithRequestToken:inRequestToken
    requestedPermission:OFFlickrWritePermission];
   
   //[[UIApplication sharedApplication] openURL:authURL];
   
   SVWebViewController *webViewController =
   [[SVWebViewController alloc]
    initWithAddress:[authURL absoluteString]];
   
   webViewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
   //webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
   webViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
   
	[self.mainViewController presentModalViewController:webViewController animated:YES];
   
	[webViewController release];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
 didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
   //NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest, inResponseDictionary); 
   
   NSString* stat = [inResponseDictionary valueForKey:@"stat"];
   if( ![stat isEqualToString:@"ok"] ) return;
      
   Session* session = (Session*)inRequest.sessionInfo;
   switch (session.requestType) 
   {
      case PANDA_LIST:
      {         
      }
         break;
      case PANDA:
      {
         NSArray* rphotos = 
         [inResponseDictionary valueForKeyPath:@"photos.photo"];
         
         //NSLog(@"%@", rphotos);
         
         for(NSDictionary* d in rphotos)
         {
            //farm = 3;
            //id = 3993538040;
            //owner = "34701630@N05";
            //ownername = "SoleDance\U2605";
            //secret = 725e929d89;
            //server = 2543;
            //title = "";
            
            NSString* title = [d objectForKey:@"title"];
            NSString* ownername = [d objectForKey:@"ownername"];
            NSString* owner = [d objectForKey:@"owner"];
            NSString* photoid = [d objectForKey:@"id"];
            NSString* tags = [d objectForKey:@"tags"];
            
            Photo* photo = [[Photo alloc] init];
            
            photo.title = title;
            photo.ownername = ownername;
            photo.owner = owner;
            photo.photoid = photoid;
            photo.dateTaken = @"";
            photo.tags = tags;
            
            photo.photoThumbURL = 
            [self.fContext photoSourceURLFromDictionary:d size:OFFlickrSmallSquareSize];
            
            photo.photoURL =
            [self.fContext photoSourceURLFromDictionary:d size:OFFlickrSmallSize];
            
            photo.photoSourceURL =
            [self.fContext photoWebPageURLFromDictionary:d];
            
            ////////
            //http://farm{icon-farm}.static.flickr.com/{icon-server}/buddyicons/{nsid}.jpg
            
            NSString* buddyS;
            NSString* iconserver = [d objectForKey:@"iconserver"];
            if((iconserver == nil) | [iconserver isEqualToString:@"0"]) 
               buddyS = @"http://www.flickr.com/images/buddyicon.jpg";
            else
               buddyS =
               [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/buddyicons/%@.jpg",
                [d objectForKey:@"iconfarm"],
                [d objectForKey:@"iconserver"],
                [d objectForKey:@"owner"]
                ];
            
            photo.buddyURL =
            [NSURL URLWithString:buddyS];
            ////////

            CLLocationCoordinate2D aLocation = {0.0,0.0};
            
            photo.location = aLocation;
            
            photo.mapPoint = 
            [MapPoint withCoordinate:photo.location title:photo.title];
            
            [self.photos addObject:photo];
            [photo release];
         }         
      }
         break;
         
      case RECENT:
      {
         NSLog(@"%@", inResponseDictionary);

         NSArray* rphotos =
         [inResponseDictionary valueForKeyPath:@"photos.photo"];
         
         
         NSString* numberOfPagesAsString =
         [[inResponseDictionary objectForKey:@"photos"] objectForKey:@"pages"];
         
         //have we seen all the pages?
         int numberOfPages = [numberOfPagesAsString intValue];
         if(page >= numberOfPages)
            page = 0;

         
         for(NSDictionary* d in rphotos)
         {
            //farm = 3;
            //id = 3993538040;
            //owner = "34701630@N05";
            //ownername = "SoleDance\U2605";
            //secret = 725e929d89;
            //server = 2543;
            //title = "";
            
            NSString* title = [d objectForKey:@"title"];
            NSString* ownername = [d objectForKey:@"ownername"];
            NSString* owner = [d objectForKey:@"owner"];
            NSString* photoid = [d objectForKey:@"id"];
            NSString* tags = [d objectForKey:@"tags"];
            NSString* datetaken = [d objectForKey:@"datetaken"];
            
            id escription = [d valueForKey:@"description"];
            NSString* description = [escription objectForKey:@"_text"];
            
            float latitude;
            float longitude;
            
            latitude  = [[d objectForKey:@"latitude"] floatValue];
            longitude = [[d objectForKey:@"longitude"] floatValue];
            
            Photo* photo = [[Photo alloc] init];
            
            //photo.title = (latitude!=0.0f)?[NSString stringWithFormat:@"*%@",title]:title;
            
            photo.title = title;
            photo.ownername = ownername;
            photo.owner = owner;
            photo.photoid = photoid;
            photo.description = description;
            photo.tags = tags;
            photo.dateTaken = datetaken;
            
            photo.photoThumbURL = 
            [self.fContext photoSourceURLFromDictionary:d size:OFFlickrSmallSquareSize];
            
            photo.photoURL =
            [self.fContext photoSourceURLFromDictionary:d size:OFFlickrSmallSize];
            
            photo.photoSourceURL =
            [self.fContext photoWebPageURLFromDictionary:d];
            
            ////////
            //http://farm{icon-farm}.static.flickr.com/{icon-server}/buddyicons/{nsid}.jpg

            NSString* buddyS;
            NSString* iconserver = [d objectForKey:@"iconserver"];
            if((iconserver == nil)| [iconserver isEqualToString:@"0"]) 
               buddyS = @"http://www.flickr.com/images/buddyicon.jpg";
            else
               buddyS =
               [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/buddyicons/%@.jpg",
                [d objectForKey:@"iconfarm"],
                [d objectForKey:@"iconserver"],
                [d objectForKey:@"owner"]
                ];
            
            photo.buddyURL =
            [NSURL URLWithString:buddyS];
            ////////
            
            CLLocationCoordinate2D aLocation = {latitude,longitude};

            photo.location = aLocation;
            
            photo.mapPoint = 
            [MapPoint withCoordinate:photo.location title:photo.title];

            [self.photos addObject:photo];
            [photo release];
         }         
      }
         break;
      default:
         break;
   }
   
   [photosUpdatedDelegate photosUpdated];
}
   
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
   //NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest, inError); 
   
   [photosUpdatedDelegate photosReturnedError:inError];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   /*
    Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   /*
    Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   /*
    Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   /*
    Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   //NSLog(@"%s", __PRETTY_FUNCTION__); 
   
   /*
    Called when the application is about to terminate.
    Save data if appropriate.
    See also applicationDidEnterBackground:.
    */
}

- (void)dealloc
{
   [_window release];
   [_mainViewController release];
   [photos release];
   
    [super dealloc];
}

@end
