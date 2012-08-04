//
//  OFSession.h
//  utility
//
//  Created by stephen eshelman on 9/10/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

//TEST BRANCH

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum 
{
   PANDA       = 0,
   RECENT,
   SEARCH,
   PANDA_LIST,
   AUTH,
   UPLOAD,
   IMAGEINFO,
   LOCATION
}REQUESTTYPE;


@interface Session : NSObject
{
   REQUESTTYPE requestType;
}
+(Session*)sessionWithRequestType:(REQUESTTYPE)requestType;
@property (assign) REQUESTTYPE requestType;
@property (assign) CLLocationCoordinate2D location;

@end
