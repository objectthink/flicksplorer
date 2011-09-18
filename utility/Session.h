//
//  OFSession.h
//  utility
//
//  Created by stephen eshelman on 9/10/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
   PANDA       = 0,
   RECENT      = 1,
   SEARCH      = 2
}REQUESTTYPE;


@interface Session : NSObject
{
   REQUESTTYPE requestType;
}
+(Session*)sessionWithRequestType:(REQUESTTYPE)requestType;
@property (assign) REQUESTTYPE requestType;

@end
