//
//  Photo.h
//  utility
//
//  Created by stephen eshelman on 9/8/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPoint : NSObject <MKAnnotation>
{
	NSString *title;
	CLLocationCoordinate2D coordinate;
}

+(id)withCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;
-(id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;

@property (nonatomic      ) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@end

@interface Photo : NSObject
{
}

//farm = 3;
//id = 3993538040;
//owner = "34701630@N05";
//ownername = "SoleDance\U2605";
//secret = 725e929d89;
//server = 2543;
//title = "";

@property (nonatomic, copy) NSString* photoid;
@property (nonatomic, copy) NSString* ownername;
@property (nonatomic, copy) NSString* owner;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* description;
@property (nonatomic, copy) NSString* dateTaken;
@property (nonatomic, copy) NSString* tags;
@property (assign)          BOOL      isFetching;

@property (retain) NSURL* photoURL;
@property (retain) NSURL* photoThumbURL;
@property (retain) NSURL* photoSourceURL;
@property (retain) NSURL* buddyURL;
@property (retain, getter=getimage, setter=setimage:) UIImage* image;
@property (retain,getter=getthumb, setter=setthumb: ) UIImage* thumb;
@property (retain) UIImage* buddy;

@property (assign) CLLocationCoordinate2D location;
@property (retain) MapPoint* mapPoint;

-(NSString*)getImageKey;
@end
