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

@synthesize photoid;
@synthesize ownername;
@synthesize title;
@synthesize description;
@synthesize dateTaken;
@synthesize tags;

@synthesize photoURL;
@synthesize photoSourceURL;
@synthesize photoThumbURL;
@synthesize buddyURL;
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
   
   [photoid release];
   [ownername release];
   [title release];
   [description release];
   [dateTaken release];
   [tags release];
   
   [photoURL release];
   [photoSourceURL release];
   [photoThumbURL release];
   [buddyURL release];
      
   [thumb release];
   [image release];
   [buddy release];
   
   [mapPoint release];
   
   [super dealloc];
}

@end
