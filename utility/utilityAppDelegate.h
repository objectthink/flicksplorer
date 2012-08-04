//
//  utilityAppDelegate.h
//  utility
//
//  Created by stephen eshelman on 9/3/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"
#import "Photo.h"

#define OBJECTIVE_FLICKR_API_KEY             @"d383d50645fa96a10d0b9f69004b08f2"
#define OBJECTIVE_FLICKR_API_SHARED_SECRET   @"ea0b1f6014bae383"
#define CALLBACK_BASE_STRING                 @"flicksplorer://auth"

@class MainViewController;

@protocol PhotosUpdatedDelegate <NSObject>
-(void)photosUpdated;
-(void)photosReturnedError:(NSError*)error;
-(void)flickrAuthorizationReceived;
@end

@interface AuthorizedUser : NSObject
{
}

@property (copy) NSString* username;
@property (copy) NSString* fullname;
@property (copy) NSString* token;
@property (copy) NSString* secret;

@end

@interface utilityAppDelegate : NSObject <
UIApplicationDelegate,
OFFlickrAPIRequestDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
CLLocationManagerDelegate>
{
   CLLocationManager* locationManager;
   CLLocationCoordinate2D currentLocation;
   UIActionSheet* uploadProgressActionSheet;
   UIProgressView* progressView;
}

//CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation;

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

-(void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest 
   didCompleteWithResponse:(NSDictionary *)inResponseDictionary;

-(void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError;

-(void)getPandaList;
-(void)refreshPandaList;
-(NSString*)nextPanda;
-(void)getPanda:(NSString*)s;
-(void)getRecent;
-(void)getSearchWith:(NSString*)s;
-(void)getSearchWithOwner:(NSString*)s;
-(void)authorization;
-(void)upload;

@property (nonatomic, retain) AuthorizedUser* user;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) NSMutableArray* photos;
@property (nonatomic, retain) NSMutableArray* pandas;

@property (nonatomic, retain) OFFlickrAPIContext* fContext;
@property (nonatomic, retain) OFFlickrAPIRequest* fRequest;
@property (nonatomic, retain) OFFlickrAPIContext* fUploadContext;
@property (nonatomic, retain) OFFlickrAPIRequest* fUploadRequest;
@property (readonly,getter = isAuthorized) BOOL authorized;

@property (retain) NSCache* photoCache;

@property (assign) id<PhotosUpdatedDelegate> photosUpdatedDelegate;
@end

@interface MyRequest : NSObject <OFFlickrAPIRequestDelegate>
{
}
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest 
 didCompleteWithResponse:(NSDictionary *)inResponseDictionary;

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest 
        didFailWithError:(NSError *)inError;
@end
