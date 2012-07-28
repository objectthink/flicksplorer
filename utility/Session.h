//
//  OFSession.h
//  utility
//
//  Created by stephen eshelman on 9/10/11.
//  Copyright 2011 blue sky computing. All rights reserved.
//

//TEST BRANCH

#import <Foundation/Foundation.h>

typedef enum 
{
   PANDA       = 0,
   RECENT,
   SEARCH,
   PANDA_LIST,
   AUTH,
   UPLOAD
}REQUESTTYPE;


@interface Session : NSObject
{
   REQUESTTYPE requestType;
}
+(Session*)sessionWithRequestType:(REQUESTTYPE)requestType;
@property (assign) REQUESTTYPE requestType;

@end
