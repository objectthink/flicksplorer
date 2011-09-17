//
//  utilityAppDelegate.m
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import "utilityAppDelegate.h"
#import "MainViewController.h"
#import "Session.h"
#import "Photo.h"

@implementation MyRequest

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
   NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest, inResponseDictionary);   
   
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
   NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest, inError);   
}
@end

@implementation utilityAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;
@synthesize photos;
@synthesize photosUpdatedDelegate;

@synthesize fContext;
@synthesize fRequest;

//dispatch_semaphore_t sema;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   //sema = dispatch_semaphore_create(0);

   // Override point for customization after application launch.
   // Add the main view controller's view to the window and display.
   
   //////////////////
   //ObjectiveFlickr test
   
   //NSString* test = [OBJECTIVE_FLICKR_API_KEY copy];
   
   self.fContext = [OFFlickrAPIContext alloc];
   
   [self.fContext initWithAPIKey:OBJECTIVE_FLICKR_API_KEY 
                    sharedSecret:OBJECTIVE_FLICKR_API_SHARED_SECRET];
   
   self.fRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.fContext];
   
   [self.fRequest setDelegate:self];
   
   self.photos = [NSMutableArray arrayWithCapacity:10];
   
//   dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//   
//   dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//
//   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//   dispatch_async(queue, 
//                  ^{
//                     MyRequest* r = [[MyRequest alloc] init];
//                     
//                     OFFlickrAPIContext* fContext = [OFFlickrAPIContext alloc];
//                     [fContext initWithAPIKey:OBJECTIVE_FLICKR_API_KEY sharedSecret:OBJECTIVE_FLICKR_API_SHARED_SECRET];
//                     
//                     OFFlickrAPIRequest* fRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:fContext];
//                     
//                     [fRequest setDelegate:r];
//                     
//                     [fRequest 
//                      callAPIMethodWithGET:@"flickr.panda.getList" 
//                      arguments:[NSDictionary dictionaryWithObjectsAndKeys:nil]
//                      ];  
//
//                     dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//                  });  

   //////////////////

   self.window.rootViewController = self.mainViewController;
   [self.window makeKeyAndVisible];
   
   return YES;
}

-(void)getPanda
{
   [self.photos removeAllObjects];
   
   self.fRequest.sessionInfo = [Session sessionWithRequestType:PANDA];
   
   [self.fRequest 
    callAPIMethodWithGET:@"flickr.panda.getPhotos" 
    arguments:[NSDictionary dictionaryWithObjectsAndKeys:
               @"ling ling", @"panda_name",@"description, license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_m, url_z, url_l, url_o", @"extras",nil]
    ];  
}

-(void)getRecent
{
   [self.photos removeAllObjects];
   
   self.fRequest.sessionInfo = [Session sessionWithRequestType:RECENT];
   
   [self.fRequest 
    callAPIMethodWithGET:@"flickr.photos.getRecent" 
    arguments:[NSDictionary dictionaryWithObjectsAndKeys:
               @"description,license, date_upload, date_taken, owner_name, icon_server, original_format, last_update, geo, tags, machine_tags, o_dims, views, media, path_alias, url_sq, url_t, url_s, url_m, url_z, url_l, url_o", @"extras",@"200",@"per_page",@"10",@"page",nil]
    ];     
}

-(void)getSearchWith:(NSString*)s
{
   
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest 
 didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
   NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest, inResponseDictionary); 
      
   Session* session = (Session*)inRequest.sessionInfo;
   switch (session.requestType) 
   {
      case PANDA:
      {
         NSArray* rphotos = 
         [inResponseDictionary valueForKeyPath:@"photos.photo"];
         
         NSLog(@"%@", rphotos);
         
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
            NSString* photoid = [d objectForKey:@"photoid"];
            
            Photo* photo = [[Photo alloc] init];
            
            photo.title = title;
            photo.ownername = ownername;
            photo.photoid = photoid;
            
            [self.photos addObject:photo];
         }
         
         [photosUpdatedDelegate photosUpdated];
      }
         break;
      case RECENT:
      {
         NSArray* rphotos = 
         [inResponseDictionary valueForKeyPath:@"photos.photo"];
         
         NSLog(@"%@", rphotos);
         
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
            NSString* photoid = [d objectForKey:@"photoid"];
            
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
            photo.photoid = photoid;
            photo.description = description;
            
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
            if([iconserver isEqualToString:@"0"]) 
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
         }
         
         [photosUpdatedDelegate photosUpdated];
      }
      default:
         break;
   }
}
   
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
   NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest, inError);   
   
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
