//
//  Photo.m
//  utility
//
//  Created by stephen eshelman on 9/8/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import "Photo.h"

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

-(void) dealloc
{
   [photoid release];
   [ownername release];
   [title release];
   [description release];
   
   [photoURL release];
   [photoSourceURL release];
   [photoThumbURL release];
      
   [thumb release];
   [image release];
   [buddy release];
   
   [super dealloc];
}

@end
