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

#define OBJECTIVE_FLICKR_API_KEY             @"2a27ceabcdf4b005d9a1b7bcb4f0d488"
#define OBJECTIVE_FLICKR_API_SHARED_SECRET   @"105871eb12e708a4"

@class MainViewController;

@protocol PhotosUpdatedDelegate <NSObject>
-(void)photosUpdated;
@end

@interface utilityAppDelegate : NSObject <UIApplicationDelegate, OFFlickrAPIRequestDelegate>
{
   
}

-(void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest 
 didCompleteWithResponse:(NSDictionary *)inResponseDictionary;

-(void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError;

-(void)getPanda;
-(void)getRecent;
-(void)getSearchWith:(NSString*)s;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) NSMutableArray* photos;

@property (nonatomic, retain) OFFlickrAPIContext* fContext;
@property (nonatomic, retain) OFFlickrAPIRequest* fRequest;

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
