//
//  Photo.m
//  utility
//
//  Created by stephen eshelman on 9/8/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import "Photo.h"
#import "utilityAppDelegate.h"

@implementation MapPoint
@synthesize coordinate, title;

+(MapPoint*)withCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
   MapPoint* mapPoint = [[MapPoint alloc] init];
   
   mapPoint.coordinate = c;
   mapPoint.title = t;
   
   return [mapPoint autorelease];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
	self = [super init];
   
	coordinate = c;
	
   [self setTitle:t];
	
	return [self autorelease];
}

- (void)dealloc
{
	[title release];
	[super dealloc];
}
@end


@implementation Photo

@synthesize photoid = _photoid;
@synthesize ownername = _ownername;
@synthesize owner =_owner;
@synthesize title = _title;
@synthesize description = _description;
@synthesize dateTaken = _dateTaken;
@synthesize tags = _tags;
@synthesize isFetching = _isFetching;

@synthesize photoURL = _photoURL;
@synthesize photoSourceURL = _photoSourceURL;
@synthesize photoThumbURL = _photoThumbURL;
@synthesize buddyURL = _buddyURL;
@synthesize image;
@synthesize thumb;
@synthesize buddy;
@synthesize location;
@synthesize mapPoint;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(NSString*)getImageKey
{
   return [NSString stringWithFormat:@"%@2X",self.photoid];
}

-(void)setimage:(UIImage *)t
{
   utilityAppDelegate* app = 
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   [app.photoCache setObject:t forKey:[self getImageKey]];
}

-(UIImage*)getimage
{
   utilityAppDelegate* app = 
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   return (UIImage*)[app.photoCache objectForKey:[self getImageKey]];
}

-(void)setthumb:(UIImage *)t
{
   utilityAppDelegate* app = 
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];
   
   [app.photoCache setObject:t forKey:self.photoid];
}

-(UIImage*)getthumb
{
   utilityAppDelegate* app = 
   (utilityAppDelegate*)[[UIApplication sharedApplication] delegate];

   return (UIImage*)[app.photoCache objectForKey:self.photoid];
}

-(void) dealloc
{
   NSLog(@"%s", __PRETTY_FUNCTION__); 
   
   [_owner release];
   [_photoid release];
   [_ownername release];
   [_title release];
   [_description release];
   [_dateTaken release];
   [_tags release];
      
   [_photoURL release];
   [_photoSourceURL release];
   [_photoThumbURL release];
   [_buddyURL release];
      
   [thumb release];
   [image release];
   [buddy release];
   
   [mapPoint release];
   
   _owner = nil;
   _photoid = nil;
   _ownername = nil;
   _title = nil;
   _description = nil;
   _dateTaken = nil;
   _tags = nil;
   _photoURL = nil;

   [super dealloc];
}

@end
